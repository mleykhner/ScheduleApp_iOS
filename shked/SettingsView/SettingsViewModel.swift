//
//  SettingsViewModel.swift
//  shked
//
//  Created by Максим Лейхнер on 05.03.2023.
//

import Foundation
import Alamofire
import UIKit

class SettingsViewModel : ObservableObject {
    
    @Published var isCheckingGroupValidity: Bool = false
    
    func checkGroupName(_ group: String) async -> GroupValidityResponse? {
        let pattern = "[^А-Яа-я0-9]+"
        let preparedGroup = group.replacingOccurrences(of: pattern, with: "", options: .regularExpression).lowercased()
        
        self.isCheckingGroupValidity = true
        
        let headers: HTTPHeaders = await [
            "User-Id": UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        ]
        
        let dataTask = AF.request("http://172.27.132.170:8080/Groups/GetGroupValidity/\(preparedGroup)".encodeUrl, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).serializingDecodable(GroupValidityResponse.self)
        
        do {
            let value = try await dataTask.value
            isCheckingGroupValidity = false
            return value
        } catch {
            print(error)
            isCheckingGroupValidity = false
            return nil
        }
    }
}

struct GroupValidityResponse : Decodable {
    var requestedGroup: String
    var formattedName: String
    var isValid: Bool
}
