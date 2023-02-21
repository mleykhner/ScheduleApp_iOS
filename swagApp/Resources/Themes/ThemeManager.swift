//
//  ThemeManager.swift
//  swagApp
//
//  Created by Максим Лейхнер on 19.02.2023.
//

import Foundation

class ThemeManager : ObservableObject {
    
    static let shared = ThemeManager()
    
    private var selectedTheme: Theme = CalmTheme()
    
    func getTheme() -> Theme {
        return selectedTheme
    }
    
    func setTheme(_ theme: Theme){
        selectedTheme = theme
    }
    
}
