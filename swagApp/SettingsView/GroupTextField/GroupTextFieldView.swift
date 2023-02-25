//
//  GroupTextFieldView.swift
//  swagApp
//
//  Created by Максим Лейхнер on 24.02.2023.
//

import SwiftUI

struct GroupTextFieldView: View {
    
    @State var groupName: String = ""
    @State var hint: String = ""
    
    
    var body: some View {
        
        ZStack {
            Text(hint)
                .foregroundColor(Color.black.opacity(0.4))
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Группа", text: $groupName)
                .onChange(of: groupName) { newValue in
                    format()
                }
        }
        .font(.custom("Unbounded", size: 24))
        .padding(12)
        
    }
    
    private func format(){
        let patternIntituteAndType = "\\w\\d{1,2}|и\\w"
        let pattern = "(\\w)(\\d{1,2}|и)(\\w)(\\d{3})(\\w{1,3})(\\d{2})"
        let result = groupName.replacingOccurrences(of: pattern, with: "$1$2$3-$4$5-$6", options: .regularExpression)
    }
}

struct GroupTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        GroupTextFieldView()
    }
}
