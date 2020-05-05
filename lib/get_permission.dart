import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermissionForContribute() async {

  int camera = 0;
  int storage = 0;

  PermissionStatus permissionCamera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
  PermissionStatus permissionStorage = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

  if(permissionCamera == PermissionStatus.denied){
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  }else if(permissionCamera == PermissionStatus.granted){
    camera = 1;
  }else{

  }

  if(permissionStorage == PermissionStatus.denied){
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }else if(permissionStorage == PermissionStatus.granted){
    storage = 1;
  }else{

  }

  if(camera == 1 && storage == 1 ){
    return true;
  }else{
    return false;
  }
}