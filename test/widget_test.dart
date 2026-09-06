import 'package:flutter_test/flutter_test.dart';

import 'package:wanqing_shizi/main.dart';

void main() {
  testWidgets('晚晴识字 启动冒烟测试', (WidgetTester tester) async {
    // 仅验证应用能正常构建并显示出标题，不依赖任何业务计数。
    await tester.pumpWidget(const WanqingApp());
    expect(find.text('晚晴识字'), findsWidgets);
  });
}
