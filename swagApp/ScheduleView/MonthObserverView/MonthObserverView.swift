//
//  MonthObserverView.swift
//  swagApp
//
//  Created by Максим Лейхнер on 21.02.2023.
//

import SwiftUI
import SwiftUIPager

struct MonthObserverView: View {
    
    init(selectedDay: Binding<Date>, onDateChange: @escaping (Date) -> Any = {_ in return}){
        self._selectedDay = selectedDay
        self.onDateChange = onDateChange
        _vm = StateObject(wrappedValue: MonthObserverViewModel(selectedDay.wrappedValue))
    }
        
    @Binding var selectedDay: Date
    let onDateChange: (Date) -> Any
    
    @State var page: Page = Page.withIndex(1)
    @State var deltaMonths: [Int] = [-1, 0, 1]
    @State var disableButtons: Bool = false
    
    @StateObject var vm: MonthObserverViewModel
    @StateObject var tm = ThemeManager.shared
    
    private let generator = UISelectionFeedbackGenerator()
    
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
                            generator.selectionChanged()
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
                                
                        }.disabled(disableButtons)
                        
                    }
                    
                }
            }
            .padding(.horizontal, 18)
        }
        .singlePagination()
        .pagingPriority(.simultaneous)
        .onDraggingBegan({
            disableButtons = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                disableButtons = false
            })
        })
        .onPageWillChange({ (newPage) in
            withAnimation {
                //Moving forward or backward a month
                selectedDay = vm.deltaMonth(delta: (newPage - page.index), day: selectedDay)
            }
        })
        .onPageChanged({ newPage in
            generator.selectionChanged()
            if newPage >= deltaMonths.count - 1 {
                    deltaMonths.append((deltaMonths.last ?? 0) + 1)
                    deltaMonths.removeFirst()
                    page.index -= 1
            } else if newPage <= 0 {
                    deltaMonths.insert((deltaMonths.first ?? 0) - 1, at: 0)
                    deltaMonths.removeLast()
                    page.index += 1
            }
        })
        
    }
}

struct MonthObserverView_Previews: PreviewProvider {
    
    @State static var selectedDay: Date = Date()
    
    static var previews: some View {
        MonthObserverView(selectedDay: $selectedDay)
    }
}
