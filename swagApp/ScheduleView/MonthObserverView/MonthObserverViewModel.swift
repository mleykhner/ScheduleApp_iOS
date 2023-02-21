//
//  MonthObserverViewModel.swift
//  swagApp
//
//  Created by Максим Лейхнер on 21.02.2023.
//

import Foundation

class MonthObserverViewModel : ObservableObject {
    
    init(_ originDate: Date){
        self.originDate = originDate
    }
    
    @Published var originDate: Date
    
    func updateOrigin(_ date: Date){
        originDate = date
    }
    
    func deltaMonth(delta: Int, day: Date? = nil) -> Date{
        let day = day ?? originDate
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: delta, to: day)!
    }
    
    func fetchMonth(_ date: Date = Date()) -> [Date]{
        //Подключем колендать пользователя
        let calendar = Calendar.current
        
        //Получаем месяц
        let month = calendar.dateInterval(of: .month, for: date)
        
        //Находим первый день месяца
        guard let firstMonthDay = month?.start else{
            return []
        }
        
        var result = calendar.range(of: .day, in: .month, for: date)!.compactMap { (dayNum: Int) -> Date in
            return calendar.date(byAdding: .day, value: dayNum - 1, to: firstMonthDay)!
        }
        
        let firstWeekDay = calendar.component(.weekday, from: result.first!)
                
        for _ in 0..<(7 + firstWeekDay - calendar.firstWeekday) % 7 {
            result.insert(Date.distantPast, at: 0)
        }
        
        return result
    }
}
