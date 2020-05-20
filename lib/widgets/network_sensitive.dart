// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:earth_cam/services/connectivity_service.dart';
import 'package:earth_cam/utils/constants.dart';

class NetworkSensitive extends StatefulWidget {
  final Widget child;
  final double opacity;

  NetworkSensitive({
    this.child,
    this.opacity = 0.5,
  });

  @override
  _NetworkSensitiveState createState() => _NetworkSensitiveState();
}

class _NetworkSensitiveState extends State<NetworkSensitive> {
  @override
  Widget build(BuildContext context) {
    // Get our connection status from the provider
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    if (connectionStatus == ConnectivityStatus.WiFi) {
      return widget.child;
    }

    if (connectionStatus == ConnectivityStatus.Cellular) {
      return widget.child;
    }

    return Stack(
      children: [
        Opacity(
          opacity: 0.1,
          child: widget.child,
        ),
        Positioned.fill(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No Connection available. Please Check your Network Connection.',
                  style: GoogleFonts.righteous(
                    fontSize: 20,
                    color: AppColor.kThemeColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
