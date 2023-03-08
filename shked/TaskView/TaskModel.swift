//
//  TaskModel.swift
//  shked
//
//  Created by Максим Лейхнер on 07.03.2023.
//

import Foundation

struct TaskModel : Identifiable, Codable {
    var id: String = UUID().uuidString
    var text: String?
    var deadline: Date?
    var isPublic: Bool = true
    var isDone: Bool = false
    var attachments: [Attachment]?
    var notificationIds: [String] = []
}

