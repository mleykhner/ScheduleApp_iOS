//
//  MonthObserverView.swift
//  swagApp
//
//  Created by Максим Лейхнер on 21.02.2023.
//

import SwiftUI
import SwiftUIPager

struct MonthObserverView: View {
    
    init(namespace: Namespace.ID, selectedDay: Binding<Date>, onDateChange: @escaping (Date) -> Any = {_ in return}){
        self.namespace = namespace
        self._selectedDay = selectedDay
        self.onDateChange = onDateChange
        _vm = StateObject(wrappedValue: MonthObserverViewModel(selectedDay.wrappedValue))
    }
        
    let namespace: Namespace.ID
    @Binding var selectedDay: Date
    let onDateChange: (Date) -> Any
    
    @State var page: Page = Page.withIndex(3)
    @State var deltaMonths: [Int] = [-3, -2, -1, 0, 1, 2, 3]
    
    @StateObject var vm: MonthObserverViewModel
    @StateObject var tm = ThemeManager.shared
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        Pager(page: page, data: deltaMonths, id: \.self) {
            month in
            LazyVGrid(columns: columns) {
                //!!!! selectedDay
                ForEach (vm.fetchMonth(vm.deltaMonth(delta: month)), id: \.self){ day in
                    if day == Date.distantPast {
                        Spacer()
                    } else {
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
                                .if(deltaMonths[page.index] == month, then: { view in
                                        view.matchedGeometryEffect(id: day, in: namespace)
                                }) { $0.transition(.slide) }
                                
                        }
                        
                    }
                    
                }
            }
            .padding(.horizontal, 18)
        }
        .singlePagination()
        .pagingPriority(.simultaneous)
        .onPageChanged({ newPage in
            if newPage >= deltaMonths.count - 2 {
                (1..<4).forEach { _ in
                    deltaMonths.append((deltaMonths.last ?? 0) + 1)
                    deltaMonths.removeFirst()
                    page.index -= 1
                }
            } else if newPage <= 1 {
                (1..<4).forEach { _ in
                    deltaMonths.insert((deltaMonths.last ?? 0) + 1, at: 0)
                    deltaMonths.removeLast()
                    page.index += 1
                }
            }
        })
    }
}

struct MonthObserverView_Previews: PreviewProvider {
    
    @State static var selectedDay: Date = Date()
    @Namespace static var namespace
    
    static var previews: some View {
        MonthObserverView(namespace: namespace, selectedDay: $selectedDay)
    }
}
