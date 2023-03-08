//
//  Attachment.swift
//  shked
//
//  Created by Максим Лейхнер on 08.03.2023.
//

import Foundation

struct Attachment : Identifiable, Codable {
    var id: String = UUID().uuidString
    var thumbnailUrl: String
    var fileUrl: String
}
