//
//  VKAuth.swift
//  shked
//
//  Created by Максим Лейхнер on 25.03.2023.
//

import Foundation
import VKSDK
import SwiftUI

class VKAuthController: VKIDFlowDelegate {
    
    static let shared = VKAuthController()
    
    func vkid(_ vkid: VKSDK.VKID.Module, didCompleteAuthWith result: Result<VKSDK.VKID.UserSession, Error>) {
        
    }

    var sharedVK: VK.Type2<VKSDK.App, VKID>?
    func initializeVK(){
        do {
            self.sharedVK = try VK {
                App(credentials: .init(clientId: "value", clientSecret: "value"))
                VKID()
            }
        } catch {
            fatalError("Couldn't initialze VK with error: \(error)")
        }
    }
}

struct VKIDButton: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let authController = VKID.AuthController(
            flow: .externalCodeFlow(),
            delegate: VKAuthController.shared
        )
        
        let oneTapButton = VKID.OneTapButton(
            appearance: .init(color: .white, cornerRadius: .custom(15), title: .init(textCreator: .basic({
                return String(localized: .init("continueWithVKID"))
            }))),
            controllerConfiguration: .authController(authController, presenter: .newUIWindow)
        )
        do {
            let button = try VKAuthController.shared.sharedVK?.vkid.ui(for: oneTapButton).uiView(configuration: .init(height: 50)) ?? UIProgressView()
            
            return button
        } catch {
            print(error)
        }
        return UIProgressView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
