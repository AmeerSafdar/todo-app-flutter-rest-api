// ignore_for_file: use_build_context_synchronously

import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  Future<PermissionStatus> askCameraPermission(Permission permissions) async {
    PermissionStatus status = await permissions.request();
    if (status.isDenied == true) {
      return status;
    }
    if (status.isPermanentlyDenied == true) {
      return status;
    } else if (status.isGranted) {
      return status;
    }
    return status;
  }
}
