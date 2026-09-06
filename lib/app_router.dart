import 'package:flutter/material.dart';

import 'screens/char_detail_screen.dart';
import 'screens/hanzi_screen.dart';
import 'screens/dictionary_screen.dart';
import 'screens/trace_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lesson_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/read_screen.dart';
import 'screens/review_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/story_reader_screen.dart';
import 'screens/story_shelf_screen.dart';
import 'screens/pinyin_screen.dart';
import 'data/story.dart';
import 'data/story_model.dart';

/// 晚晴识字 · 集中路由表。
///
/// 约定：路由常量只能从这里取，禁止在 widget 里硬编码路由字符串；
/// 页面间参数一律用 `ModalRoute.of(context)!.settings.arguments`。
class AppRouter {
  AppRouter._();

  /// 学习（首页 / 今天学什么）
  static const String home = '/';
  /// 新课学习
  static const String lesson = '/lesson';
  /// 单字详情
  static const String charDetail = '/char';
  /// 描红写一写（带参：char）
  static const String trace = '/trace';
  /// 当堂轻练习
  static const String practice = '/practice';
  /// 智能复习
  static const String review = '/review';
  /// 短句阅读
  static const String read = '/read';
  /// 故事屋 · 书架
  static const String storyShelf = '/story';
  /// 故事屋 · 阅读器（带参：StoryBook）
  static const String storyReader = '/story_reader';
  /// 我的字库
  static const String library = '/library';
  /// 字典（按课序浏览全部生字）
  static const String dictionary = '/dictionary';
  /// 设置
  static const String settings = '/settings';
  /// 拼音学习（声母/韵母/整体认读/四声/拼读）
  static const String pinyin = '/pinyin';

  static const String initialRoute = home;

  // ⚠️ 只放「不需要参数」的路由。凡是带参页面（lesson/charDetail/trace/practice/storyReader）
  // 必须走 onGenerateRoute 读取 settings.arguments；若也写进本表，Flutter 会优先用本表、
  // 永远不调用 onGenerateRoute，导致参数被静默丢弃（历史上因此整条「学字」链路失效）。
  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    home: (_) => const HomeScreen(),
    review: (_) => const ReviewScreen(),
    read: (_) => const ReadScreen(),
    storyShelf: (_) => const StoryShelfScreen(),
    library: (_) => const HanziScreen(),
    dictionary: (_) => const DictionaryScreen(),
    settings: (_) => const SettingsScreen(),
    pinyin: (_) => const PinyinScreen(),
  };

  /// 带参数的页面统一走这里，从 `settings.arguments` 取值。
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;
    switch (settings.name) {
      case lesson:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => LessonScreen(lessonId: args is int ? args : 1),
        );
      case charDetail:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => CharDetailScreen(char: args is String ? args : ''),
        );
      case trace:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => TraceScreen(char: args is String ? args : ''),
        );
      case practice:
        List<String> chars = const <String>[];
        String mode = 'audio';
        if (args is Map) {
          chars = args['chars'] is List
              ? List<String>.from(args['chars'] as List)
              : const <String>[];
          mode = args['mode'] is String ? args['mode'] as String : 'audio';
        } else if (args is List<String>) {
          chars = args;
        } else if (args is String) {
          chars = <String>[args];
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => PracticeScreen(chars: chars, mode: mode),
        );
      case storyReader:
        final StoryBook book = args is StoryBook ? args : kAllStories.first;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => StoryReaderScreen(book: book),
        );
      default:
        return null;
    }
  }
}
