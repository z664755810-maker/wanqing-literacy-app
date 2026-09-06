import 'package:flutter/material.dart';

import '../services/backup_service.dart';
import '../services/tts_service.dart';
import '../state/app_state.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';

/// 设置页。
///
/// 含两块：
/// 1. 显示偏好（字号 / 按钮大小 / 显示拼音）与朗读设置（语速 / 嗓音）—— 走 [AppState]，
///    改动立刻通过 `ListenableBuilder` 全局生效，无需退出重开。
/// 2. 进度备份与恢复（可用）：**零依赖**——备份写进手机应用目录并提示路径，
///    恢复从该目录选文件；不联网、不申请存储权限、不加任何 pub 依赖。
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // 语速档位（物理倍速语义，走 MediaPlayer setSpeed）：默认『慢速』0.7
  static const List<double> _kSpeechRates = <double>[0.7, 0.85, 1.0];
  static const List<String> _kSpeechRateLabels = <String>['慢速', '正常', '稍快'];

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final AppSettings s = AppState.instance.settings;

    // 找到当前选中的档位下标；找不到时回落到默认值，避免界面错位
    int fontIdx = AppDimens.kFontScales.indexOf(s.fontScale);
    if (fontIdx < 0) fontIdx = AppDimens.kFontScales.indexOf(AppDimens.kDefaultFontScale);
    int btnIdx = AppDimens.kButtonScales.indexOf(s.buttonScale);
    if (btnIdx < 0) btnIdx = 0;
    int rateIdx = _kSpeechRates.indexOf(s.speechRate);
    if (rateIdx < 0) rateIdx = 0;

    return Scaffold(
      appBar: AppBar(title: Text('设置', style: AppTheme.serif(size: d.fs(26)))),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(d.pagePad),
          children: <Widget>[
            // ---------------- 显示偏好（改动即时生效）----------------
            Text('显示设置', style: AppTheme.serif(size: d.fs(22), w: FontWeight.w600)),
            SizedBox(height: d.fs(AppDimens.gapS)),
            Text('下面的设置改完立刻生效，不用退出重开。',
                style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2)),
            SizedBox(height: d.fs(AppDimens.gapL)),

            _OptionRow(
              d: d,
              title: '字号',
              hint: '字越大越好认（默认「大」）',
              options: AppDimens.kFontScaleLabels,
              selected: fontIdx,
              onPick: (int i) => AppState.instance
                  .updateSettings(s.copyWith(fontScale: AppDimens.kFontScales[i])),
            ),
            SizedBox(height: d.fs(AppDimens.gapL)),

            _OptionRow(
              d: d,
              title: '按钮大小',
              hint: '按键越大越好点（默认「标准」）',
              options: AppDimens.kButtonScaleLabels,
              selected: btnIdx,
              onPick: (int i) => AppState.instance
                  .updateSettings(s.copyWith(buttonScale: AppDimens.kButtonScales[i])),
            ),
            SizedBox(height: d.fs(AppDimens.gapL)),

            _PinyinRow(
              d: d,
              on: s.showPinyin,
              onToggle: (bool v) => AppState.instance
                  .updateSettings(s.copyWith(showPinyin: v)),
            ),
            SizedBox(height: d.fs(AppDimens.gapL)),

            // ---------------- 朗读设置（语速 + 嗓音，都只作用于本 App 朗读）----------------
            Text('朗读设置', style: AppTheme.serif(size: d.fs(22), w: FontWeight.w600)),
            SizedBox(height: d.fs(AppDimens.gapS)),
            Text('下面是朗读相关的设置，改完立刻生效，不用退出重开。',
                style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2)),
            SizedBox(height: d.fs(AppDimens.gapL)),

            _OptionRow(
              d: d,
              title: '语速',
              hint: '朗读的快慢（默认「慢速」；三档用不同的声音版本，能听出差别）',
              options: _kSpeechRateLabels,
              selected: rateIdx,
              onPick: (int i) async {
                final double r = _kSpeechRates[i];
                AppState.instance.updateSettings(s.copyWith(speechRate: r));
                // v1.16 试听改用「你」「好」——单字在 kVoiceManifest 双套表里都命中，
                // 走预生成音频：慢速档播 -30% 烤的慢速版，其余档播 +0% 烤的原速版——
                // 母亲能立即听出档位差别。
                await TtsService.instance.setSpeechRate(r);
                await TtsService.instance.speak('你好');
              },
            ),
            SizedBox(height: d.fs(AppDimens.gapL)),

            // 朗读嗓音（挑本机自带中文嗓音，不装任何 App）
            _VoiceRow(d: d, current: s.ttsVoice),

            SizedBox(height: d.fs(AppDimens.gapXl)),
            const Divider(),
            SizedBox(height: d.fs(AppDimens.gapL)),

            // ---------------- 进度备份 / 恢复（可用）----------------
            Text('进度备份与恢复', style: AppTheme.serif(size: d.fs(22), w: FontWeight.w600)),
            SizedBox(height: d.fs(AppDimens.gapS)),
            Text(
              '学习进度存在平板本地，卸载应用会清空。点「备份进度」会生成一个文件存进手机目录，'
              '用「文件管理」或连电脑找到它，就能发微信 / 传到另一台设备。纯离线，不联网。',
              style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2, h: 1.5),
            ),
            SizedBox(height: d.fs(AppDimens.gapM)),
            _BackupButton(d: d, label: '备份进度', icon: Icons.backup_outlined, onTap: () => _backup(context)),
            SizedBox(height: d.fs(AppDimens.gapM)),
            _BackupButton(
              d: d,
              label: '恢复进度',
              icon: Icons.restore_from_trash_outlined,
              primary: true,
              onTap: () => _restore(context),
            ),
          ],
        ),
      ),
    );
  }

  /// 备份：写文件到手机目录 → 弹窗显示完整路径（也附 JSON 文本，方便手动复制）。
  Future<void> _backup(BuildContext context) async {
    final AppDimens d = AppDimens.of(context);
    String path;
    try {
      path = await BackupService.exportToFile();
    } catch (e) {
      if (!context.mounted) return; // await 之后界面可能已销毁
      _snack(context, '导出文件失败：$e');
      return;
    }
    if (!context.mounted) return;
    final String snap = BackupService.exportSnapshot();
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text('已存到手机文件', style: AppTheme.serif(size: d.fs(20), w: FontWeight.w700)),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: d.fs(380)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('用手机「文件管理」或连电脑 USB，找到下面这个文件，发微信 / 传到另一台设备即可：',
                  style: AppTheme.sans(size: d.fs(14), color: AppTheme.ink2, h: 1.5)),
              SizedBox(height: d.fs(AppDimens.gapS)),
              SelectableText(path, style: AppTheme.sans(size: d.fs(13), color: AppTheme.dai)),
              SizedBox(height: d.fs(AppDimens.gapM)),
              Text('（若一时找不到文件，也可直接复制下面这段 JSON 保存）',
                  style: AppTheme.sans(size: d.fs(13), color: AppTheme.ink2)),
              SizedBox(height: d.fs(AppDimens.gapS)),
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: SelectableText(snap, style: AppTheme.sans(size: d.fs(13))),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('知道了', style: AppTheme.serif(size: d.fs(17), color: AppTheme.dai)),
          ),
        ],
      ),
    );
  }

  /// 恢复：列出备份目录里的文件，点选后二次确认再落盘。
  Future<void> _restore(BuildContext context) async {
    final AppDimens d = AppDimens.of(context);
    final List<String> files = await BackupService.listBackups();
    if (!context.mounted) return;
    if (files.isEmpty) {
      _snack(context, '还没有导出的备份文件，请先点「备份进度」');
      return;
    }
    showDialog<String>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text('选一份备份恢复', style: AppTheme.serif(size: d.fs(20), w: FontWeight.w700)),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: d.fs(380)),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (final String p in files)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_basename(p), style: AppTheme.sans(size: d.fs(15))),
                      onTap: () => Navigator.of(ctx).pop(p),
                    ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Text('取消', style: AppTheme.serif(size: d.fs(17), color: AppTheme.ink2)),
          ),
        ],
      ),
    ).then((String? chosen) async {
      if (chosen == null) return;
      if (!context.mounted) return; // 选文件期间界面可能已被销毁
      final bool? ok = await showDialog<bool>(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          title: Text('恢复进度？', style: AppTheme.serif(size: d.fs(20), w: FontWeight.w700)),
          content: Text('这会覆盖当前的学习进度。确定从「${_basename(chosen)}」恢复吗？',
              style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2, h: 1.5)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('取消', style: AppTheme.serif(size: d.fs(17), color: AppTheme.ink2)),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('确定恢复', style: AppTheme.serif(size: d.fs(17), color: AppTheme.dai, w: FontWeight.w700)),
            ),
          ],
        ),
      );
      if (ok != true) return;
      final String? err = await BackupService.importFromFile(chosen);
      if (!context.mounted) return;
      // 恢复自标生字到内存，使「我圈的字」即时刷新（否则磁盘已更新、界面仍是旧的）
      if (err == null) await AppState.instance.reloadMarks();
      if (!context.mounted) return;
      _snack(context, err == null ? '进度已恢复' : '恢复失败：$err');
    });
  }

  String _basename(String p) => p.split(RegExp(r'[/\\]')).last;

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: AppTheme.sans(size: 15)), duration: const Duration(seconds: 3)),
    );
  }
}

/// 一行「选项」控件：标题 + 说明 + 一排可点的档位。
class _OptionRow extends StatelessWidget {
  final AppDimens d;
  final String title;
  final String hint;
  final List<String> options;
  final int selected;
  final ValueChanged<int> onPick;

  const _OptionRow({
    required this.d,
    required this.title,
    required this.hint,
    required this.options,
    required this.selected,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: AppTheme.serif(size: d.fs(22), w: FontWeight.w600)),
        SizedBox(height: d.fs(AppDimens.gapS)),
        Text(hint, style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2)),
        SizedBox(height: d.fs(AppDimens.gapM)),
        Wrap(
          spacing: d.fs(AppDimens.gapM),
          runSpacing: d.fs(AppDimens.gapS),
          children: <Widget>[
            for (int i = 0; i < options.length; i++)
              _ChoiceChip(
                d: d,
                label: options[i],
                selected: i == selected,
                onTap: () => onPick(i),
              ),
          ],
        ),
      ],
    );
  }
}

/// 单个档位小药丸（大热区、选中态填黛青浅底）。
class _ChoiceChip extends StatelessWidget {
  final AppDimens d;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.d,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.daiSoft : Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        child: Container(
          constraints: BoxConstraints(minHeight: d.touch),
          padding: EdgeInsets.symmetric(horizontal: d.fs(22), vertical: d.fs(10)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            border: Border.all(
              color: selected ? AppTheme.dai : AppTheme.line,
              width: selected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTheme.serif(
                size: d.fs(20),
                color: selected ? AppTheme.dai : AppTheme.ink2,
                w: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 「显示拼音」开关行。
class _PinyinRow extends StatelessWidget {
  final AppDimens d;
  final bool on;
  final ValueChanged<bool> onToggle;

  const _PinyinRow({required this.d, required this.on, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('显示拼音', style: AppTheme.serif(size: d.fs(22), w: FontWeight.w600)),
              SizedBox(height: d.fs(AppDimens.gapS)),
              Text('关掉后，短句阅读不再显示上方拼音（默认开）',
                  style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2)),
            ],
          ),
        ),
        SizedBox(width: d.fs(AppDimens.gapM)),
        Switch(
          value: on,
          onChanged: onToggle,
          activeThumbColor: AppTheme.dai,
          activeTrackColor: AppTheme.daiSoft,
        ),
      ],
    );
  }
}

/// 朗读嗓音选择行：列出本机已装的**中文**嗓音，点选即应用并试听。
///
/// 🔴 性价比要点：不依赖任何第三方 TTS App（讯飞/Google 等）。荣耀/华为平板自带中文 TTS
/// 引擎通常就够自然，本行只让用户在系统已有嗓音里挑最顺耳的一个；若本机一个好听的都没有，
/// 只要在系统设置开启免费的「中文语音数据」即可，无需安装软件。
class _VoiceRow extends StatefulWidget {
  final AppDimens d;
  final String? current;
  const _VoiceRow({required this.d, required this.current});

  @override
  State<_VoiceRow> createState() => _VoiceRowState();
}

class _VoiceRowState extends State<_VoiceRow> {
  late Future<List<Map<String, String>>> _voices;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
    _voices = TtsService.instance.getZhVoices();
  }

  void _pick(String? key) {
    setState(() => _selected = key);
    AppState.instance.updateSettings(
      AppState.instance.settings.copyWith(ttsVoice: key),
    );
    // 试听：点一下立刻念一句，方便对比哪个嗓音更自然（复用既有 TTS 调用，不新写）
    TtsService.instance.applyVoice(key);
    TtsService.instance.speak('你好，我是晚晴识字');
  }

  @override
  Widget build(BuildContext context) {
    final AppDimens d = widget.d;
    return FutureBuilder<List<Map<String, String>>?>(
      future: _voices,
      builder: (BuildContext ctx, AsyncSnapshot<List<Map<String, String>>?> snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Text('正在读取本机嗓音…', style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2));
        }
        final List<Map<String, String>> vs = snap.data ?? <Map<String, String>>[];
        // 去重后仅 1 项 → 整行隐藏：这是「假选择」，点来点去没变化只会让她以为点坏了。
        //   静默应用这唯一嗓音（自动态即它），不给她无意义的决策压力。
        if (vs.length == 1) return const SizedBox.shrink();

        final List<Widget> col = <Widget>[
          Text('朗读嗓音', style: AppTheme.serif(size: d.fs(22), w: FontWeight.w600)),
          SizedBox(height: d.fs(AppDimens.gapS)),
          Text('从平板自带的中文嗓音里挑一个最自然的（不用装任何软件）。点一下会试听。',
              style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2)),
          SizedBox(height: d.fs(AppDimens.gapM)),
        ];
        if (vs.isEmpty) {
          // 0 项：隐藏选择行，只给一行看得懂的自救指引（不显示开发者黑话）
          col.add(Text(
            '朗读声音由平板提供，可在「系统设置 → 文字转语音」里开启中文语音。',
            style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2, h: 1.5),
          ));
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: col);
        }
        // ≥2 项：自动（推荐）+ 去重后的 N 个嗓音 chip
        final List<Widget> chips = <Widget>[
          _VoiceChip(d: d, label: '自动（推荐）', selected: _selected == null, onTap: () => _pick(null)),
        ];
        for (final Map<String, String> v in vs) {
          chips.add(_VoiceChip(
            d: d,
            label: v['label'] ?? '未知嗓音',
            selected: _selected == v['key'],
            onTap: () => _pick(v['key']),
          ));
        }
        col.add(Wrap(
          spacing: d.fs(AppDimens.gapM),
          runSpacing: d.fs(AppDimens.gapS),
          children: chips,
        ));
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: col);
      },
    );
  }
}

/// 单个嗓音药丸（字号略小以容纳较长的嗓音名）。
class _VoiceChip extends StatelessWidget {
  final AppDimens d;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _VoiceChip({required this.d, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.daiSoft : Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        child: Container(
          constraints: BoxConstraints(minHeight: d.touch),
          padding: EdgeInsets.symmetric(horizontal: d.fs(18), vertical: d.fs(10)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            border: Border.all(
              color: selected ? AppTheme.dai : AppTheme.line,
              width: selected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: AppTheme.serif(
              size: d.fs(17),
              color: selected ? AppTheme.dai : AppTheme.ink2,
              w: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// 设置页里的整宽按钮（风格对齐 BigButton：黛青主操作 + 描边次操作）。
class _BackupButton extends StatelessWidget {
  final AppDimens d;
  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  const _BackupButton({
    required this.d,
    required this.label,
    required this.icon,
    this.primary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color fg = primary ? AppTheme.dai : AppTheme.ink2;
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Container(
          constraints: BoxConstraints(minHeight: d.touch),
          padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapM)),
          decoration: BoxDecoration(
            color: primary ? AppTheme.daiSoft : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.radius),
            border: Border.all(color: primary ? AppTheme.dai : AppTheme.line, width: primary ? 1.5 : 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: d.fs(26), color: fg),
              SizedBox(width: d.fs(AppDimens.gapS)),
              Text(label, style: AppTheme.serif(size: d.fs(19), color: fg, w: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
