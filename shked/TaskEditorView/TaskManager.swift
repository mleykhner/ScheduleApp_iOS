//
//  TaskManager.swift
//  shked
//
//  Created by Максим Лейхнер on 14.03.2023.
//

import Foundation
import Alamofire
import UIKit

class TaskManager : ObservableObject {
    
    static let shader = TaskManager()
    
    @Published var isUploading = false
    @Published var uploadingProgress = Float.zero
    
    func uploadAttachment(_ attachment: Attachment) async {
        let headers: HTTPHeaders = await [
            "User-Id": "developer" + (UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString),
            "Content-Type" : attachment.type.preferredMIMEType ?? ""
        ]
        //AF.upload()
    }
}
