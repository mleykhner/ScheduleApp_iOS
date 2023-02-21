//
//  swagAppApp.swift
//  swagApp
//
//  Created by Максим Лейхнер on 18.02.2023.
//

import SwiftUI

@main
struct swagAppApp: App {
    
    init(){
        demo = test.parse(jsonData: test.readLocalFile(forName: "testResponse")!)
    }
    
    let test = ScheduleManager()
    var demo: ScheduleModel
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
