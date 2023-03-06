//
//  InfoMessageView.swift
//  shked
//
//  Created by Максим Лейхнер on 28.02.2023.
//

import SwiftUI

struct InfoMessageView: View {
    @State var showProgressView: Bool = false
    @State var messageText: String = "Загружаю расписание"
    
    var body: some View {
        HStack(spacing: 12){
            Text(messageText)
                .font(.custom("Golos Text VF", size: 16))
                .foregroundColor(Color.black)
            ProgressView()
                .tint(Color.black)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedCorners(radius: 30, corners: [.bottomLeft, .bottomRight])
                .foregroundColor(Color.yellow)
                .ignoresSafeArea()
        )
        .transition(.opacity.animation(.easeOut))
        
    }
}

struct InfoMessageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            InfoMessageView()
            Spacer()
        }
        
    }
}
