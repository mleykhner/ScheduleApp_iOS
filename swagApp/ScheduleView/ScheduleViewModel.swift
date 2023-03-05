//
//  ScheduleViewModel.swift
//  swagApp
//
//  Created by Максим Лейхнер on 22.02.2023.
//

import Foundation

class ScheduleViewModel : ObservableObject {
    
    init(){
        getScheduleForPrefferedGroup()
    }
    
    @Published var schedule: ScheduleModel?
    
    func getScheduleForPrefferedGroup() {
        if let scheduleData = ScheduleManager.shared.getCachedScheduleData() {
            self.schedule = ScheduleManager.shared.parseSchedule(jsonData: scheduleData)
        } else {
            reload()
        }
    }
    
    func reload() {
        if let preferredGroup = UserDefaults().string(forKey: "preferredGroup") {
            Task{
                if let scheduleData = await ScheduleManager.shared.loadData(preferredGroup) {
                    ScheduleManager.shared.cacheScheduleData(scheduleData)
                    DispatchQueue.main.async {
                        self.schedule = ScheduleManager.shared.parseSchedule(jsonData: scheduleData)
                    }
                }
            }
        }
    }
    
    func loadScheduleForGroup(_ group: String){
        Task{
            if let scheduleData = await ScheduleManager.shared.loadData(group) {
                DispatchQueue.main.async {
                    self.schedule = ScheduleManager.shared.parseSchedule(jsonData: scheduleData)
                }            }
        }
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
