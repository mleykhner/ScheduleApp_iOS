//
//  ScheduleViewModel.swift
//  swagApp
//
//  Created by Максим Лейхнер on 22.02.2023.
//

import Foundation

class ScheduleViewModel : ObservableObject {
    
    init(){
        if let preferredGroup = UserDefaults().string(forKey: "preferredGroup") {
            schedule = sm.parse(jsonData: sm.readLocalFile(forName: preferredGroup)!)
        }
    }
    
    let sm = ScheduleManager()
    var schedule: ScheduleModel?
    
    func loadScheduleForGroup(_ group: String){
        schedule = sm.parse(jsonData: sm.readLocalFile(forName: group)!)
        objectWillChange.send()
    }
    
    func getClassesForDate(_ date: Date) -> [ClassModel] {
        if let schedule = schedule {
            let calendar = Calendar.current
            let dayNumber = calendar.component(.weekday, from: date) - 1
            for weekday in schedule.schedule.week {
                if weekday.dayNumber == dayNumber {
                    for weekdaySchedule in weekday.daysSchedules {
                        for scheduleDate in weekdaySchedule.dates{
                            if scheduleDate.isSameAs(date){
                                return weekdaySchedule.classes
                            }
                        }
                    }
                }
            }
        }
        return []
    }
    
    
    
    
    
}
