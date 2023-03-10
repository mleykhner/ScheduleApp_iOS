//
//  ClassView.swift
//  shked
//
//  Created by Максим Лейхнер on 18.02.2023.
//

import SwiftUI

struct ClassView: View {
    
    init(classObject: ClassModel){
        self.classObject = classObject
        self.task = nil
    }
    
    init(classObject: ClassModel, task: TaskModel){
        self.classObject = classObject
        self.task = task
    }

    
    let classObject: ClassModel
    let task: TaskModel?
    
    @StateObject var vm = ClassViewModel()
    @StateObject var tm = ThemeManager.shared

    @State var currentClass: Bool = false
    @State private var taskOpened: Bool = false
    
    @State private var taskEditorOpened: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        let colorId = vm.getColorIndexForClass(classObject.name)
        
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 18) {
                VStack {
                    Text("\(classObject.ordinal)")
                        .foregroundColor(Color(tm.getTheme().secondaryForegroundColor))
                        .font(.custom("Unbounded", size: 20))
                        .fontWeight(.bold)
                        .monospacedDigit()
                        .frame(width: 42, height: 42)
                        .background(Color(tm.getTheme().secondaryBackgroundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    
                        RoundedRectangle(cornerRadius: 2)
                        .frame(maxWidth: 2.5, maxHeight: .infinity)
                        .foregroundColor(Color(tm.getTheme().secondaryBackgroundColor))
                }
                VStack(alignment: .leading, spacing: 4) {
                    if currentClass {
                        Text(LocalizedStringKey("now"))
                            .textCase(.uppercase)
                            .font(.custom("Unbounded", size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(getContrastColor(tm.getTheme().getColorName(colorId)).opacity(0.8))
                    }
                    VStack(alignment: .leading, spacing: 8){
                        Text(classObject.name.uppercased())
                            .foregroundColor(getContrastColor(tm.getTheme().getColorName(colorId)))
                            .font(.custom("Unbounded", size: 20))
                        .fontWeight(.bold)
                        HStack {
                            HStack(spacing: 14){
                                Text(classObject.type.getLocalizedName().uppercased())
                                    .fontWeight(.black)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(lineWidth: 2)
                                    }
                                    
                                Text(classObject.location)
                                    .fontWeight(.bold)
                                Text(classObject.getTimeString())
                            }
                            .font(.custom("PT Root UI VF", size: 16))
                            .foregroundColor(getContrastColor(tm.getTheme().getColorName(colorId)).opacity(0.75))
                            Spacer()
                            Button{
                                withAnimation(.spring(dampingFraction: 0.65)) {
                                    taskOpened.toggle()
                                }
                            }
                            label: {
                                Image(systemName: "chevron.down.circle")
                                    .font(.system(size: 24))
                                .foregroundColor(getContrastColor(tm.getTheme().getColorName(colorId)))
                                .rotationEffect(
                                    .degrees(taskOpened ? 180 : 0))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                    
            }
                VStack(alignment: .leading){
                    HStack (alignment: .center) {
                        Image(systemName: "person")
                            .font(.system(size: 20))
                        Text(classObject.teacher?.capitalized ?? "–")
                            .font(.custom("PT Root UI VF", size: 16))
                            .fontWeight(.semibold)
                    }
                    Divider()
                    if let task = task {
                        TaskView(task: task)
                    } else {
                        HStack{
                            Text("noTask")
                                .font(.custom("PT Root UI VF", size: 16))
                                .fontWeight(.semibold)
                            Spacer()
                            Button {
                                taskEditorOpened.toggle()
                            } label: {
                                HStack (alignment: .center) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 20))
                                    Text("add")
                                        .font(.custom("PT Root UI VF", size: 16))
                                        .fontWeight(.bold)
                                }
                                .foregroundColor(Color(tm.getTheme().foregroundColor))
                            }
                        }
                    }
                    
                }
                .padding(12)
                .frame(maxWidth: .infinity, maxHeight: taskOpened ? nil : 0, alignment: .leading)
                .background(Color(tm.getTheme().backgroundColor))
                .opacity(taskOpened ? 1 : 0)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .padding([.horizontal, .top], 12)
        .padding(.bottom, taskOpened ? 12 : 0)
        .frame(maxWidth: .infinity)
        .background(tm.getTheme().getColor(colorId))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .popover(isPresented: $taskEditorOpened) {
            TaskEditorView()
        }
        
    }
    
    func getContrastColor(_ colorName: String) -> Color {
        let uiColor = UIColor(named: colorName)
        let ciColor = CIColor(color: uiColor!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .init(colorScheme))))
        let components = ciColor.components
        
        let r: CGFloat = components[0]
        let g: CGFloat = components[1]
        let b: CGFloat = components[2]

        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        
        if luminance > 0.5 {
            return Color("Black")
        } else {
            return Color("White")
        }
    }
}

struct ClassView_Previews: PreviewProvider {
    
    static var newClass = ClassModel(name: "Физическая культура очка", teacher: "сергей андрейич", ordinal: 4, type: .practical, location: "ГУК Б-420")
    
    static var previews: some View {
        ScrollView(.vertical){
            ForEach(Array(0..<4), id: \.self){
                i in
                if i == 2 {
                    BreakView()
                }
                ClassView(classObject: newClass/*, colorId: i.magnitude*/)
            }
        }
            
        }
    }

