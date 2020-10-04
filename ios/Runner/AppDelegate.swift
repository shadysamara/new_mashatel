import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyCTRG8gcAzVYCB9AQ4Bn3DGL5zyrAiTw1Q")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
   
