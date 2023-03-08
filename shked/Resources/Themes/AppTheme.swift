//
//  Theme.swift
//  shked
//
//  Created by Максим Лейхнер on 19.02.2023.
//

import Foundation
import SwiftUI

protocol AppTheme {
    
    var contentColors: [String] { get }
    
    var foregroundColor: String { get }
    var backgroundColor: String { get }
    
    var secondaryForegroundColor: String { get }
    var secondaryBackgroundColor: String { get }
    
    var themeName: String { get }
}

extension AppTheme {
    
    func getColor(_ id: UInt) -> Color {
        return Color(contentColors[Int(id) % contentColors.count])
    }
    
    func getColorName(_ id: UInt) -> String {
        return contentColors[Int(id) % contentColors.count]
    }
}
