//
//  ScheduleViewModel.swift
//  swagApp
//
//  Created by Максим Лейхнер on 22.02.2023.
//

import Foundation

class ScheduleViewModel : ObservableObject {
    
    init(){
        schedule = sm.parse(jsonData: sm.readLocalFile(forName: "testResponse")!)
    }
    
    let sm = ScheduleManager()
    var schedule: ScheduleModel
    
    func getClassesForDate(_ date: Date) -> [ClassModel] {
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
//        let schedulesForWeekday = schedule.schedule.week[dayNumber]
//        for weekdaySchedule in schedulesForWeekday.daysSchedules {
//            for scheduleDate in weekdaySchedule.dates{
//                if scheduleDate.isSameAs(date){
//                    return weekdaySchedule.classes
//                }
//            }
//        }
        return []
    }
    
    
    
    
    
}
