//
//  ScheduleView.swift
//  swagApp
//
//  Created by Максим Лейхнер on 19.02.2023.
//

import SwiftUI

struct ScheduleView: View {
    
    @StateObject var vm = ScheduleViewModel()
    
    @State var selectedDay = Date()
    
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView(.vertical, showsIndicators: false){
                Text("М3О–225Бк–21")
                    .font(.custom("Unbounded", size: 32))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                showClasses(vm.getClassesForDate(selectedDay))
            }
            
            
            CalendarView(selectedDay: $selectedDay)
                .padding(.bottom, 59)
        }
        
    }
    
    func showClasses(_ classes: [ClassModel]) -> some View {
        var hasSecondClass = false
        classes.forEach { classObject in
            if classObject.ordinal == 2 {
                hasSecondClass = true
            }
        }
        return Group {
            ForEach(classes, id: \.self) {
                classObject in
                if hasSecondClass && classObject.ordinal == 3 {
                    BreakView()
                }
                ClassView(ClassObject: classObject/*, colorId: 1*/)
            }
            .transition(.slide)
            .animation(.easeOut(duration: 0.1))
        }
        
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
