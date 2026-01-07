import 'package:flutter/material.dart';
import 'screens/signup_page.dart';

/*
  1. step 기반의 회원가입 폼을 구현하라
  2. 각 단계별로 유효성을 검사하라(validator)
  3. 비동기로 이메일 중복 검사를 실행하라
  4. 모든 데이터를 가져와서 취합 후 springboot로 전송하라
  5. 회원가입 완료 시 완료 페이지로 이동하라

  폴더 구성
  lib/
    | -- main.dart
    | -- screens /
    |       | -- signup_page.dart
    | -- services /
    |       | -- db_service.dart
    | -- models /
    |       | -- user_model.dart

    * SafeArea : 각각의 휴대전화 제조사마다 버튼 등의 위치가 제각각이라 기종에 따라 내용이
                 가려지거나 사라지는 UI가 존재하게 된다.
                 그러면 직접 margin, padding을 줘야한다.
                 그러나 SafeArea를 사용하면 위의 과정이 필요없다. 충분한 padding을 알아서 준다.
                 
    * stepper : 단계별 진행 상황을 표시한다.
      - steps : 화면에 보여줄 step 리스트
      - type : 수직인지 수평인지 보여줄 방향
      - elevation : type이 수평으로 설정되어 있을 때만 사용이 가능, 상단에 표시되는 스텝들의 높이를 지정
      - currentStep : 현재 표시되는 시스템의 index값
      - onStepTapped : 스템들을 탭했을 때 동작할 로직을 구현
      - onStepContinue : 다음 버튼을 탭했을 때 동작할 로직을 구현
      - onStepCancel : 취소 버튼을 탭했을 때 동작할 로직을 구현
 */

void main() {
  runApp(MaterialApp(
    home: SignUpPage(), // 회원가입하는 곳
  ));
}

/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Stepper Sample')),
        body: const Center(child: StepperExample()),
      ),
    );
  }
}

class StepperExample extends StatefulWidget {
  const StepperExample({super.key});

  @override
  State<StepperExample> createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index <= 0) {
          setState(() {
            _index += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          title: const Text('Step 1 title'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: const Text('Content for Step 1'),
          ),
        ),
        const Step(title: Text('Step 2 title'), content: Text('Content for Step 2')),
      ],
    );
  }
}
 */