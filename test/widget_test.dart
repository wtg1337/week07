import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/Test1.dart';

void main() {
  group('아침 등교길 비 확인 앱 인수 조건(AC) 테스트', () {
    testWidgets('AC1: 초기 진입 시 비 옴 상태와 우산 안내 문구가 표시된다', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const WeatherApp());

      expect(find.text('지금 밖에 비가 옵니다!'), findsOneWidget);
      expect(find.text('우산을 꼭 챙겨서 나가세요 ☂️'), findsOneWidget);
      expect(find.byIcon(Icons.umbrella_rounded), findsOneWidget);
      expect(find.textContaining('최신 확인 시각:'), findsOneWidget);
    });

    testWidgets('AC2: 새로고침 클릭 시 1초 로딩 후 비 안 옴 상태로 토글된다', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const WeatherApp());

      final refreshButton = find.widgetWithText(ElevatedButton, '지금 상태 새로고침');
      await tester.tap(refreshButton);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('최신 날씨 확인 중...'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('지금 비가 오지 않습니다'), findsOneWidget);
      expect(find.text('우산 없이 가볍게 출석하세요 ☀️'), findsOneWidget);
      expect(find.byIcon(Icons.wb_sunny_rounded), findsOneWidget);
    });
  });
}
