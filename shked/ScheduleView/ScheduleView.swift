//
//  ScheduleView.swift
//  shked
//
//  Created by Максим Лейхнер on 19.02.2023.
//

import SwiftUI

struct ScheduleView: View {
    
    @StateObject var vm = ScheduleViewModel()
    @StateObject var tm = ThemeManager.shared
    @StateObject var sm = ScheduleManager.shared
    
    @State var selectedDay: Date = Date()
    @State var showSettings: Bool = false
    @State var showInfoMessage: Bool = false
    
    @State var headerHeight: CGFloat = CGFloat.zero
    @State var scrollOffset: CGPoint = CGPoint.zero
    
    var body: some View {
        ZStack(alignment: .bottom){
            OffsetObservingScrollView(axes: .vertical, showsIndicators: false, offset: $scrollOffset){
                    Spacer()
                        .frame(height: headerHeight)
                    showClasses(vm.getClassesForDate(selectedDay))
                    Spacer()
                        .frame(height: 223)
                }
                .refreshable{
                    if !sm.loading {
                        vm.reload()
                    }
            }
            
            
            VStack {
                VStack {
                    if sm.loading {
                        InfoMessageView()
                            .transition(.opacity)
                            .animation(.easeOut(duration: 0.3), value: sm.loading)
                    }
                    HStack(alignment: .center) {
                        Text(vm.schedule?.groupName.longDash() ?? "Группа не установлена")
                            .font(.custom("Unbounded", size: 32))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        
                        Button {
                            showSettings.toggle()
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 24))
                        }
                        .popover(isPresented: $showSettings) {
                            SettingsView()
                        }
                        .onChange(of: showSettings) { newValue in
                            if !newValue {
                                vm.reload()
                            }
                        }
                    }
                    .foregroundColor(Color(tm.getTheme().foregroundColor))
                    .padding(12)
                }
                .background(
                    Color.clear
                        .measureSize { size in
                        headerHeight = size.height
                    }
                )
                .background(
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .background(Material.ultraThin.opacity(scrollOffset.y > 0 ? 1 : 0))
                        .animation(.easeIn(duration: 0.3), value: scrollOffset.y)
                )
                Spacer()
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
                ClassView(classObject: classObject/*, colorId: 1*/)
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

struct MeasureSizeModifier: ViewModifier {
  func body(content: Content) -> some View {
    content.background(GeometryReader { geometry in
      Color.clear.preference(key: SizePreferenceKey.self,
                             value: geometry.size)
    })
  }
}

extension View {
  func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
    self.modifier(MeasureSizeModifier())
          .onPreferenceChange(SizePreferenceKey.self){ newValue in
              action(newValue)
              print("The new child size is: \(newValue)")
          }
  }
}

struct PositionObservingView<Content: View>: View {
    var coordinateSpace: CoordinateSpace
    @Binding var position: CGPoint
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: PreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace).origin
                )
            })
            .onPreferenceChange(PreferenceKey.self) { position in
                self.position = position
            }
    }
}

private extension PositionObservingView {
    enum PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGPoint { .zero }

        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
            // No-op
        }
    }
}

struct OffsetObservingScrollView<Content: View>: View {
    var axes: Axis.Set = [.vertical]
    var showsIndicators = true
    @Binding var offset: CGPoint
    @ViewBuilder var content: () -> Content

    private let coordinateSpaceName = UUID()

    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            PositionObservingView(
                coordinateSpace: .named(coordinateSpaceName),
                position: Binding(
                    get: { offset },
                    set: { newOffset in
                        //withAnimation {
                            offset = CGPoint(
                                x: -newOffset.x,
                                y: -newOffset.y
                            )
                        //}
                        
                    }
                ),
                content: content
            )
        }
        .coordinateSpace(name: coordinateSpaceName)
    }
}
