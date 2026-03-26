import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'whats_new_dialog.dart';

class AppWrapper extends StatefulWidget {
  final Widget child;

  const AppWrapper({super.key, required this.child});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _shouldShowWhatsNew = false;

  @override
  void initState() {
    super.initState();
    _checkForNewVersion();
  }

  void _checkForNewVersion() async {
    final prefs = await SharedPreferences.getInstance();
    
    const String currentVersion = '2.0';
    final lastVersion = prefs.getString('lastVersion');
    
    if (lastVersion != null && lastVersion != currentVersion) {
      setState(() {
        _shouldShowWhatsNew = true;
      });
    }
    
    await prefs.setString('lastVersion', currentVersion);
  }

  void _closeWhatsNew() {
    setState(() {
      _shouldShowWhatsNew = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_shouldShowWhatsNew)
          Positioned.fill(
            child: Material(
              color: Colors.black54,
              child: WhatsNewDialog(onClose: _closeWhatsNew),
            ),
          ),
      ],
    );
  }
}
