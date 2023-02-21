//
//  ScheduleModel.swift
//  swagApp
//
//  Created by Максим Лейхнер on 22.02.2023.
//

import Foundation

struct ScheduleModel : Codable {
    var groupName: String
    var schedule: GroupSchedule
}

struct GroupSchedule : Codable {
    var week: [WeekSchedule]
}

struct WeekSchedule : Codable {
    var daysSchedules: [DaySchedules]
}

struct DaySchedules : Codable {
    var dates: [Date]
    var classes: [ClassModel]
}
