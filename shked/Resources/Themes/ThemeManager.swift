//
//  ThemeManager.swift
//  shked
//
//  Created by Максим Лейхнер on 19.02.2023.
//

import Foundation

class ThemeManager : ObservableObject {
    
    init(){
        let selectedThemeId = UserDefaults.standard.integer(forKey: "selectedTheme")
        
        switch selectedThemeId {
        case 1:
            selectedTheme = MinimalTheme()
        case 2:
            selectedTheme = CalmTheme()
        default:
            selectedTheme = SWAGTheme()
        }
    }
    
    static let shared = ThemeManager()
    
    private var selectedTheme: AppTheme
    
    func getTheme() -> AppTheme {
        return selectedTheme
    }
    
    func setTheme(_ theme: AppTheme){
        selectedTheme = theme
        
        switch theme {
        case is MinimalTheme:
            UserDefaults.standard.set(1, forKey: "selectedTheme")
        case is CalmTheme:
            UserDefaults.standard.set(2, forKey: "selectedTheme")
        default:
            UserDefaults.standard.set(3, forKey: "selectedTheme")
        }
        objectWillChange.send()
    }
    
}


