//
//  BreakView.swift
//  swagApp
//
//  Created by Максим Лейхнер on 18.02.2023.
//

import SwiftUI

struct BreakView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 18){
            VLine()
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [0, 10]))
                .frame(maxWidth: 2.5)
            VStack(alignment: .leading, spacing: 4){
                Text("Жоский чилл".uppercased())
                    .font(.custom("Unbounded", size: 20))
                    .fontWeight(.bold)
                Text("45 минут")
                    .font(.custom("Unbounded", size: 16))
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 12)
        }
        .foregroundColor(Color("Foreground"))
        .padding(.vertical, 8)
        .padding(.leading, 32)
    }
}

struct BreakView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            BreakView()
        }
        
    }
}

struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}
