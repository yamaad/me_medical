import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:me_medical_app/models/icon.widget.dart';

class UserSettings extends StatelessWidget {
  static const keyLanguage = 'key-language';
  static const keyStock = 'key-low-stock';

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: 'Settings',
      subtitle: 'Language, Password',
      leading: const IconWidget(
        icon: Icons.settings,
        color: Colors.redAccent,
      ),
      child: SettingsScreen(
        children: [
          TextInputSettingsTile(
            title: 'Low stock quantity',
            settingKey: keyStock,
            initialValue: '10',
            onChange: (lowStock) {},
          ),
        ],
      ),
    );
  }
}
