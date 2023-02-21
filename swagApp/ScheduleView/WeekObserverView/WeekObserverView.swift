//
//  WeekObserverView.swift
//  swagApp
//
//  Created by Максим Лейхнер on 21.02.2023.
//

import SwiftUI
import SwiftUIPager

struct WeekObserverView: View {
    
    init(namespace: Namespace.ID, selectedDay: Binding<Date>, onDateChange: @escaping (Date) -> Any = {_ in return}){
        self.namespace = namespace
        self._selectedDay = selectedDay
        self.onDateChange = onDateChange
        _vm = StateObject(wrappedValue: WeekObserverViewModel(selectedDay.wrappedValue))
    }

    let namespace: Namespace.ID
    @Binding var selectedDay: Date
    let onDateChange: (Date) -> Any
    
    @State var page: Page = Page.withIndex(3)
    @State var deltaWeeks: [Int] = [-3, -2, -1, 0, 1, 2, 3]
    
    
    @StateObject var vm: WeekObserverViewModel
    @StateObject var tm = ThemeManager.shared
    
    var body: some View {
        Pager(page: page, data: deltaWeeks, id: \.self) { deltaWeek in
            HStack{
                ForEach(vm.fetchWeek(vm.deltaWeek(delta: deltaWeek)), id: \.self){ day in
                    Button {
                        withAnimation(.easeOut) {
                            selectedDay = day
                        }
                        _ = onDateChange(day)
                    } label: {
                        Text(day.extractDate("dd"))
                            .font(.custom("Unbounded", size: 20))
                            .fontWeight(.bold)
                            .frame(width: 42, height: 42)
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .stroke(lineWidth: selectedDay.isSameAs(day) ? 2 : 0)
                                    .frame(width: 46, height: 46)
                            })
                            .foregroundColor(Color(tm.getTheme().foregroundColor))
                            .frame(maxWidth: .infinity)
                            .if(deltaWeeks[page.index] == deltaWeek, then: { view in
                                    view
                                    .matchedGeometryEffect(id: day, in: namespace)
                            }) { $0 }
                            
                    }
                }
            }.padding(.horizontal, 18)
        }
        .singlePagination()
        .pagingPriority(.simultaneous)
        .onPageChanged({ newPage in
            if newPage >= deltaWeeks.count - 2 {
                (1..<4).forEach { _ in
                    deltaWeeks.append((deltaWeeks.last ?? 0) + 1)
                    deltaWeeks.removeFirst()
                    page.index -= 1
                }
            } else if newPage <= 1 {
                (1..<4).forEach { _ in
                    deltaWeeks.insert((deltaWeeks.last ?? 0) + 1, at: 0)
                    deltaWeeks.removeLast()
                    page.index += 1
                }
            }
        })
        .itemSpacing(50)
        .frame(height: 48)
        
    }
}

struct WeekObserverView_Previews: PreviewProvider {
    @State static var selectedDay: Date = Date()
    @Namespace static var namespace
    static var previews: some View {
        WeekObserverView(namespace: namespace, selectedDay: $selectedDay)
    }
}

extension View {

    @ViewBuilder
    public func `if`<T: View, U: View>(
        _ condition: Bool,
        then modifierT: (Self) -> T,
        else modifierU: (Self) -> U
    ) -> some View {

        if condition { modifierT(self) }
        else { modifierU(self) }
    }
}
