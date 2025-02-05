//
//  EthereumIntegration.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

//import Foundation
////import Flutter
//import FirebaseAuth
//import FirebaseFirestore
//@UIApplicationMain
//@objc class AppDelegate: FlutterAppDelegate {
//    override func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//        GeneratedPluginRegistrant.register(with: self)
//        // Register the MethodChannel
//        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
//        let channel = FlutterMethodChannel(name: "com.example.blockchain/channel",
//                                           binaryMessenger: controller.binaryMessenger)
//        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
//            if call.method == "sendEthereumAddress" {
//                guard let arguments = call.arguments as? [String: Any],
//                      let ethereumAddress = arguments["ethereumAddress"] as? String,
//                      let email = arguments["email"] as? String else {
//                    result(FlutterError(code: "INVALID_ARGUMENTS",
//                                        message: "Invalid arguments passed to sendEthereumAddress",
//                                        details: nil))
//                    return
//                }
//                self.sendEthereumAddress(ethereumAddress: ethereumAddress, email: email, result: result)
//            } else {
//                result(FlutterMethodNotImplemented)
//            }
//        }
//        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//    }
//    // Send Ethereum Address and Email Logic
//    private func sendEthereumAddress(ethereumAddress: String, email: String, result: @escaping FlutterResult) {
//        let db = Firestore.firestore()
//        // Example: Storing Ethereum address in Firestore for the provided email
//        db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
//            if let error = error {
//                result(FlutterError(code: "FIRESTORE_ERROR",
//                                    message: "Error fetching user: \(error.localizedDescription)",
//                                    details: nil))
//            } else if let document = querySnapshot?.documents.first {
//                document.reference.updateData(["ethereumAddress": ethereumAddress]) { error in
//                    if let error = error {
//                        result(FlutterError(code: "UPDATE_ERROR",
//                                            message: "Failed to update Ethereum address: \(error.localizedDescription)",
//                                            details: nil))
//                    } else {
//                        result("Ethereum address updated successfully.")
//                    }
//                }
//            } else {
//                result(FlutterError(code: "USER_NOT_FOUND",
//                                    message: "No user found with the provided email",
//                                    details: nil))
//            }
//        }
//    }
//}
