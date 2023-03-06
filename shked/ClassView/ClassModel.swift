//
//  ClassModel.swift
//  shked
//
//  Created by Максим Лейхнер on 18.02.2023.
//

import Foundation

struct ClassModel : Codable, Hashable {
    var name: String
    var teacher: String?
    var ordinal: Int
    var type: ClassType
    var location: String
}

enum ClassType : String, Codable {
    case lecture = "lecture"
    case practical = "practical"
    case laboratory = "laboratory"
    case test = "test"
    case exam = "exam"
    
    func getLocalizedName() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

extension ClassModel {
    func getTimeString() -> String {
        switch self.ordinal {
        case 1:
            return "9:00 – 10:30"
        case 2:
            return "10:45 – 12:15"
        case 3:
            return "13:00 – 14:30"
        case 4:
            return "14:45 – 16:15"
        case 5:
            return "16:30 – 18:00"
        default:
            return "–"
        }
    }
}
