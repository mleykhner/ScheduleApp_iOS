//
//  TaskView.swift
//  shked
//
//  Created by Максим Лейхнер on 07.03.2023.
//

import SwiftUI

struct TaskView: View {
    
    @State var task: TaskModel
    
    @StateObject var tm: ThemeManager = ThemeManager.shared
    
    var body: some View {
        if let text = task.text {
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Button {
                    task.isDone.toggle()
                } label: {
                    HStack(alignment: .bottom, spacing: 6){
                        Image(systemName: task.isDone ? "checkmark" : "square.and.pencil")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .frame(width: 20, height: 20)
                        Text(task.isDone ? "Выполнено" : "Выполнить")
                            .font(.custom("PT Root UI VF", size: 16))
                            .fontWeight(.medium)
                    }
                    
                }
                Spacer()
                Menu {
                    Button("Удалить", role: .destructive) {
                        
                    }
                    Button("Изменить") {
                        
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 20))
                        .fontWeight(.regular)
                        .frame(width: 20, height: 20)
                }

            }
            Divider()
            HStack {
                Text("До 12 марта")
                    .font(.custom("PT Root UI VF", size: 14))
                    .fontWeight(.semibold)
                Spacer()
                Text("Добавил ты")
                    .font(.custom("PT Root UI VF", size: 14))
                    .fontWeight(.thin)
            }
            .foregroundColor(Color(tm.getTheme().foregroundColor).opacity(0.5))
        }
        
    }
}

struct TaskView_Previews: PreviewProvider {
    static let string = """
                        ### Решить 10 заданий из раздела "Несобственные интегралы"
                        """
    static let task = TaskModel(text: string, isDone: false)
    static let classes = ClassModel(name: "Математический анализ", ordinal: 1, type: .lecture, location: "3-412")
    static var previews: some View {
        ScrollView {
            ClassView(classObject: classes, task: task)
        }
    }
}
