//
//  WeekObserverView.swift
//  shked
//
//  Created by Максим Лейхнер on 21.02.2023.
//

import SwiftUI
import SwiftUIPager

struct WeekObserverView: View {
    
    init(_ day: Binding<Date>){
        _selectedDay = day
        _originDate = State(initialValue: day.wrappedValue)
    }

    @Binding var selectedDay: Date
    @State var originDate: Date
    
    @State var page: Page = Page.withIndex(3)
    @State var previousPageIndex:Int = 3
    @State var deltaWeeks: [Int] = [-3, -2, -1, 0, 1, 2, 3]
    @State var disableButtons: Bool = false
    
    let vm =  WeekObserverViewModel()
    @StateObject var tm = ThemeManager.shared
    
    let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        Pager(page: page, data: deltaWeeks, id: \.self) { deltaWeek in
            HStack{
                ForEach(vm.fetchWeek(vm.deltaWeek(delta: deltaWeek, day: originDate)), id: \.self){ day in
                    Button {
                        generator.selectionChanged()
                        selectedDay = day
                        
                    } label: {
                        Text(day.extractDate("dd"))
                            .font(.custom("Unbounded", size: 20))
                            .fontWeight(.bold)
                            .frame(width: 42, height: 42)
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .stroke(lineWidth: selectedDay.isSameAs(day) ? 2 : 0)
                                    .frame(width: 46, height: 46)
                                    .animation(.easeOut, value: selectedDay)
                            })
                            .foregroundColor(Color(tm.getTheme().foregroundColor).opacity(day.isSameMonth(selectedDay) ? 1 : 0.4))
                            .frame(maxWidth: .infinity)
                            
                    }
                    .disabled(disableButtons)
                }
            }.padding(.horizontal, 18)
        }
        .singlePagination()
        .pagingPriority(.simultaneous)
        .onDraggingBegan({
            disableButtons = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                disableButtons = false
            })
        })
        .onPageChanged({ _ in
            print("Page changed")
            if page.index >= deltaWeeks.count - 2 {
                (1..<4).forEach { _ in
                    deltaWeeks.append((deltaWeeks.last ?? 0) + 1)
                    deltaWeeks.removeFirst()
                    page.index -= 1
                }
                selectedDay = vm.deltaWeek(delta: 1, day: selectedDay)
            } else if page.index <= 1 {
                (1..<4).forEach { _ in
                    deltaWeeks.insert((deltaWeeks.first ?? 0) - 1, at: 0)
                    deltaWeeks.removeLast()
                    page.index += 1
                }
                selectedDay = vm.deltaWeek(delta: -1, day: selectedDay)
            } else {
                selectedDay = vm.deltaWeek(delta: page.index - previousPageIndex, day: selectedDay)
            }
            previousPageIndex = page.index
            generator.selectionChanged()
            
        })
        .itemSpacing(50)
        .frame(height: 48)
        
    }
}

struct WeekObserverView_Previews: PreviewProvider {
    @State static var selectedDay: Date = Date()
    static var originDate: Date = Date()
    static var previews: some View {
        WeekObserverView($selectedDay)
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
