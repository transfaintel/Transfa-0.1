import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let wifiChannel = FlutterMethodChannel(name: "app.settings/wifi", binaryMessenger: controller.binaryMessenger)
    let cellularChannel = FlutterMethodChannel(name: "app.settings/cellular", binaryMessenger: controller.binaryMessenger)
    
    wifiChannel.setMethodCallHandler { (call, result) in
      if call.method == "openWifiSettings" {
        if let url = URL(string: "App-Prefs:root=WIFI") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
          result(nil)
        } else if let url = URL(string: "App-Prefs:root=General&path=WIFI") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
          result(nil)
        } else {
          result(FlutterError(code: "UNAVAILABLE", message: "Cannot open Wi-Fi settings", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    cellularChannel.setMethodCallHandler { (call, result) in
      if call.method == "openCellularSettings" {
        if let url = URL(string: "App-Prefs:root=MOBILE_DATA_SETTINGS_ID") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
          result(nil)
        } else if let url = URL(string: "App-Prefs:root=General&path=MOBILE_DATA_SETTINGS_ID") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
          result(nil)
        } else {
          result(FlutterError(code: "UNAVAILABLE", message: "Cannot open Cellular settings", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}