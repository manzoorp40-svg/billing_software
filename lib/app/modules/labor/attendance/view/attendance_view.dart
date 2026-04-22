import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/worker_attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Attendance View placeholder'),
      ),
    );
  }
}
