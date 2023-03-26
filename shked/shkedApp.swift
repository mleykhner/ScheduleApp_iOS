//
//  shkedApp.swift
//  shked
//
//  Created by Максим Лейхнер on 18.02.2023.
//

import SwiftUI
import UIKit
import VKSDK

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        VKAuthController.shared.initializeVK()
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        (try? VKAuthController.shared.sharedVK?.open(url: url)) ?? false
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        if
            let webpageURL = userActivity.webpageURL,
            let openResult = try? VKAuthController.shared.sharedVK?.open(url: webpageURL)
        {
            return openResult
        }

        return false
    }

}


@main
struct shkedApp: SwiftUI.App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainFlowView()
        }
    }
}
