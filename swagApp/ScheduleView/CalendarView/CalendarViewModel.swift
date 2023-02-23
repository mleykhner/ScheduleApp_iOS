//
//  CalendarViewModel.swift
//  swagApp
//
//  Created by Максим Лейхнер on 19.02.2023.
//

import Foundation
import SwiftUIPager
import SwiftUI

class CalendarViewModel : ObservableObject {
    
    func getMonthSymbol(_ date: Date) -> String{
            let calendar = Calendar.current
        return calendar.standaloneMonthSymbols[calendar.component(.month, from: date) - 1]
        }
    
    
    func fetchWeekdays() -> [String] {
        //Подключаем календарь пользователя
        let calendar = Calendar.current
        //Забираем локализованные названия дней недели
        let weekdays = calendar.veryShortWeekdaySymbols
        //Забираем номер первого дня недели
        let firstDay = calendar.firstWeekday
        //Переносим дни согласно этому номеру
        var result: [String] = []
                for i in (0..<7){
                    //Добавляем в массив
                    result.append(weekdays[(i + firstDay - 1) % 7])
                }
        return result
    }
    
    
}
