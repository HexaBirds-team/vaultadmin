import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../helpers/style_sheet.dart';
import '../../controllers/app_settings_controller.dart';

class AdminAppSettings extends StatefulWidget {
  const AdminAppSettings({super.key});

  @override
  State<AdminAppSettings> createState() => _AdminAppSettingsState();
}

class _AdminAppSettingsState extends State<AdminAppSettings> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("App Settings", style: GetTextTheme.sf20_bold),
      ),
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.all(15.sp),
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Expanded(
                  child: SizedBox(
                child: Text("Dark Mode", style: GetTextTheme.sf16_regular),
              )),
              Switch.adaptive(
                  value: settings.isDark,
                  onChanged: (value) => settings.setisDark(value))
            ],
          )
        ],
      )),
    );
  }
}
