import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

final notifications = FlutterLocalNotificationsPlugin();

// 앱 로드시 실행할 기본설정
initNotification(context) async {
  // 시간대 데이터 초기화
  tz.initializeTimeZones();

  // var androidSetting = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var androidSetting = const AndroidInitializationSettings('notification.dart');



  // 안드로이드 13 이상 권한 요청
  if (Platform.isAndroid) {
    notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // iOS 설정
  var iosSetting = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting
  );

  await notifications.initialize(
    initializationSettings,
    // 알림을 클릭 시, 새 창을 열려면
    onDidReceiveNotificationResponse: (payload) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(appBar: AppBar(), body: Text('창이 열리는 알림'))
          )
      );
    }
  );
}

showNotification() {
  var androidDetails = AndroidNotificationDetails(
    '유니크한 알림 아이디',
    '알림 테스트용',
    priority: Priority.high,
    importance: Importance.max
    // color: Color.fromARGB(255,255,0,0)
  );

  var iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true
  );

  notifications.show(
    1,
    'Test',
    'It is a test',
    NotificationDetails(android: androidDetails, iOS: iosDetails),
    payload: '정보들' // 알림에 대한 정보들을 몰래 심어놓을 수 있다
    // 그런데 잘 쓰지 않을 뿐더러 버그도 많고 재렌더링도 불가능하다
  );
}


showNotificationII() async {
  var androidDetails = AndroidNotificationDetails(
      '유니크한 알림 아이디',
      '알림 테스트용',
      priority: Priority.high,
      importance: Importance.max
    // color: Color.fromARGB(255,255,0,0)
  );

  var iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
  );

  /*
  // 매분마다 반복 알림
  await notifications.periodicallyShow(
      3,
      '반복 알림 제목',
      '매분마다 반복 알림',
      RepeatInterval.everyMinute,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.inexact
  );
  */

  /*
  // 매분마다 반복 알림
  await notifications.periodicallyShow(
      3,
      '반복 알림 제목',
      '매분마다 반복 알림',
      RepeatInterval.everyMinute,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.inexact
  );
  */

  /*
  // 매달 또는 매년 같은 시간이라면?
  await notifications.zonedSchedule(
      4,
      '매달 같은 시간',
      '똥이나 쳐먹어 이 새끼들아!',
      tz.TZDateTime.now(tz.local),
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.inexact,
      matchDateTimeComponents: DateTimeComponents.dateAndTime // 매년 같은 날짜 그리고 같은 시간에 알림을 발신한다
      // matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime // 매달 같은 요일 그리고 같은 시간에 알림을 발신한다
      // matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime // 매주 같은 요일 그리고 같은 시간에 알림을 발신한다
      // matchDateTimeComponents: DateTimeComponents.time // 매일 같은 시간에 알림을 발신한다
  );
   */

  // 자신이 원하는 날짜와 시간을 주고 반복 알림
  await notifications.zonedSchedule(
      5,
      '내가 주는 채찍',
      '똥이나 쳐먹어 이 새끼들아!',
      makeDate(13, 15, 00),
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.inexact,
      matchDateTimeComponents: DateTimeComponents.time
  );

  // 예정된 알림을 취소하려면?
  await notifications.cancel(1);
  // 모든 알림을 취소하려면?
  await notifications.cancelAll();
}

makeDate(hour, min, sec) {
  var now = tz.TZDateTime.now(tz.local);
  var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);
  if(when.isBefore(now)) {
    return when.add(Duration(days: 1));
  } else {
    return when;
  }
}


