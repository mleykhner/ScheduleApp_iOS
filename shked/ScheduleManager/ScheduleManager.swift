//
//  ScheduleManager.swift
//  shked
//
//  Created by Максим Лейхнер on 22.02.2023.
//

import Foundation
import Alamofire
import UIKit
import Keys


class ScheduleManager : ObservableObject {
    
    static let shared = ScheduleManager()
    
    var schedule: ScheduleModel? = nil
    @Published var loading: Bool = false
    @Published var errorOccured: Bool = false
    @Published var errorCode: Int? = nil
    
    func loadData(_ group: String) async -> Data? {
        let keys = ShkedKeys()
        //var result: Data?
        //Text
        DispatchQueue.main.async {
            self.loading = true
        }
        
        let headers: HTTPHeaders = await [
            "User-Id": "developer" + (UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString)
        ]
        
        let dataTask = AF.request("\(keys.backendURL)/Groups/\(group)".encodeUrl, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 15 }).serializingData()
        
        if let data = try? await dataTask.value {
            DispatchQueue.main.async {
                self.loading = false
            }
            return data
        }
        
        DispatchQueue.main.async {
            self.loading = false
        }
    
        return nil
    }
    
    func cacheScheduleData(_ data: Data){
        UserDefaults.standard.set(data, forKey: "cachedScheduleData")
    }
    
    func getCachedScheduleData() -> Data? {
        return UserDefaults.standard.data(forKey: "cachedScheduleData")
    }
    
    
    
    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func parseSchedule(jsonData: Data) -> ScheduleModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        do {
            let decodedData = try decoder.decode(ScheduleModel.self,
                                                 from: jsonData)
            
            print("Decoded group: \(decodedData.groupName)")
            return decodedData
            
        } catch {
            print(error)
        }
        return ScheduleModel(groupName: "Fail", schedule: GroupSchedule(week: []))
    }
}

extension DateFormatter {
    static let noTimeDecoder: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        //formatter.timeStyle = .none
        return formatter
    }()
}

extension String{
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}

