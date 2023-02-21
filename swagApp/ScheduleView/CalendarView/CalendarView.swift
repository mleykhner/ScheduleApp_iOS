//
//  CalendarView.swift
//  swagApp
//
//  Created by Максим Лейхнер on 19.02.2023.
//

import SwiftUI
import SwiftUIPager

struct CalendarView: View {
    
    @Namespace var namespace
    
    @StateObject var vm = CalendarViewModel()
    @StateObject var tm = ThemeManager.shared
    
    @State var page: Page = Page.withIndex(3)
    @State var deltaWeeks: [Int] = [-3, -2, -1, 0, 1, 2, 3]
    
    @State var selectedDay: Date = Date()
    
    @State var animationProgress: CGFloat = 0.0
    @State var visibleObserver: Bool = true
    
    
    var body: some View {
        VStack(spacing: 6){
            Capsule()
                .frame(width: 84, height: 4)
                .background(.ultraThinMaterial)
            VStack(spacing: 12){
                HStack {
                    Text(vm.getMonthSymbol(selectedDay).capitalized)
                        .font(.custom("Unbounded", size: 20))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Menu {
                        Button {
                            //Изменить группу
                            withAnimation {
                                visibleObserver.toggle()
                            }
                            
                        } label: {
                            HStack {
                                Text("changeGroup")
                                Image(systemName: "person.2.badge.gearshape")
                            }
                        }
                        Button(role: .destructive) {
                            //Сообщить об ошибке
                        } label: {
                            HStack {
                                Text("reportABug")
                                Image(systemName: "exclamationmark.triangle")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                            .frame(width: 26, height: 26)
                    }
                }
                .foregroundColor(Color(tm.getTheme().foregroundColor))
                if visibleObserver{
                    WeekObserverView(namespace: namespace, selectedDay: $selectedDay)
                        .padding(.horizontal, -18)
                } else {
                    MonthObserverView(namespace: namespace, selectedDay: $selectedDay, onDateChange: {
                        _ in
                        withAnimation {
                            closeMonthView()
                        }
                    })
                        .frame(maxHeight: 280)
                        .padding(.horizontal, -18)
                    //MARK: Подумать еще
                        .transition(.opacity.animation(.easeOut(duration: 0.3)))
                }
                
                
            
                HStack{
                    ForEach(vm.fetchWeekdays(), id: \.self){
                        day in
                        Text(day.uppercased())
                            .font(.custom("Unbounded", size: 12))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(tm.getTheme().foregroundColor).opacity(0.3))
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity)
            .background(
                RoundedCorners(radius: 30, corners: [.topLeft, .topRight])
                    .fill(Material.thin)
            )
        }
            
    }
    
    func closeMonthView(){
        visibleObserver = true
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            CalendarView()
        }
    }
}

struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path
    {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius))
        
        return Path(path.cgPath)
    }
}
