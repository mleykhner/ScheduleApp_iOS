//
//  WeekObserverViewModel.swift
//  swagApp
//
//  Created by Максим Лейхнер on 21.02.2023.
//

import Foundation

class WeekObserverViewModel : ObservableObject {
    
    init(_ originDate: Date){
        self.originDate = originDate
    }
    
    @Published var originDate: Date
    
    func updateOrigin(_ date: Date){
        originDate = date
    }
    
    func deltaWeek(delta: Int, day: Date? = nil)->Date{
        let day = day ?? originDate
        let calendar = Calendar.current
        return calendar.date(byAdding: .weekOfYear, value: delta, to: day)!
    }
    
    func fetchWeek(_ date: Date = Date()) -> [Date] {
        //Подключем колендать пользователя
        let calendar = Calendar.current
        //Получаем текущую неделю
        let week = calendar.dateInterval(of: .weekOfMonth, for: date)
        //Находим первый день недели
        guard let firstWeekDay = week?.start else{
            return []
        }
        
        var result: [Date] = []
        
        //Добавляем дни
        (0...6).forEach{
            day in
            //Переходим к следующему дню
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                //Добавляем в массив
                result.append(weekday)
            }
        }
        return result
    }
}

extension Date {
    func extractDate(_ format: String) -> String{
            //Подключаем форматировщик дат
            let formatter = DateFormatter()
            //Устанавливаем формат
            formatter.dateFormat = format
            //Разбиваем отформатированную дату на части
            let parts = formatter.string(from: self).split(separator: "/")
            var newDate = ""
            //Собираем обратно удаляя незначащие нули
            for i in 0..<parts.count {
                newDate = "\(newDate)\(i == 0 ? "" : "/")\(Int(parts[i])!)"
            }
            return newDate
        }
    
    func isSameAs (_ date: Date) -> Bool{
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }
}
