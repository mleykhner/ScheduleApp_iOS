//
//  Attachment.swift
//  shked
//
//  Created by Максим Лейхнер on 08.03.2023.
//

import Foundation
import UniformTypeIdentifiers

struct Attachment : Identifiable, Codable {
    var id: String = UUID().uuidString
    var thumbnail: Data
    var fileUrl: String?
    var fileData: Data?
    var type: UTType
}


