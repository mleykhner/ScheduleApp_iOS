//
//  ScheduleManager.swift
//  swagApp
//
//  Created by Максим Лейхнер on 22.02.2023.
//

import Foundation

class ScheduleManager {
    
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
    
    func parse(jsonData: Data) -> ScheduleModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        //decoder.dateDecodingStrategy = .formatted(.)
        
        do {
            let decodedData = try decoder.decode(ScheduleModel.self,
                                                       from: jsonData)
            
            print("Group: \(decodedData.groupName)")
            return decodedData
            //print("===================================")
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
