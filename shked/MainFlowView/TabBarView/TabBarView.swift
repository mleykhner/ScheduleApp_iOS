//
//  TabBarView.swift
//  shked
//
//  Created by Максим Лейхнер on 23.02.2023.
//

import SwiftUI

struct TabBarView: View {
    
    init(_ activeTab: Binding<Tab>){
        _activeTab = activeTab
    }
    
    @Binding var activeTab: Tab
    @StateObject var tm = ThemeManager.shared
    
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        VStack(spacing: 4) {
            Divider()
            HStack{
                VStack(spacing: 4){
                    Image(systemName: "newspaper")
                        .font(.system(size: 24))
                    Text("news")
                        .font(.custom("Unbounded", size: 12))
                        .fontWeight(activeTab == .news ? .semibold : .regular)
                        
                }
                .foregroundColor(Color(tm.getTheme().foregroundColor).opacity(activeTab == .news ? 1 : 0.4))
                .onTapGesture {
                    generator.selectionChanged()
                    withAnimation(.easeOut(duration: 0.05)) {
                        activeTab = .news
                    }
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 4){
                    Image(systemName: "list.bullet.below.rectangle")
                        .font(.system(size: 24))
                    Text("schedule")
                        .font(.custom("Unbounded", size: 12))
                        .fontWeight(activeTab == .schedule ? .semibold : .regular)
                }
                .onTapGesture {
                    generator.selectionChanged()
                    withAnimation(.easeOut(duration: 0.05)) {
                        activeTab = .schedule
                    }
                }
                .onLongPressGesture {
                    
                }
                .foregroundColor(Color(tm.getTheme().foregroundColor).opacity(activeTab == .schedule ? 1 : 0.4))
                .frame(maxWidth: .infinity)
                
                
                VStack(spacing: 4){
                    Image(systemName: "book")
                        .font(.system(size: 24))
                    Text("tasks")
                        .font(.custom("Unbounded", size: 12))
                        .fontWeight(activeTab == .tasks ? .semibold : .regular)
                        
                }
                .onTapGesture {
                    generator.selectionChanged()
                    withAnimation(.easeOut(duration: 0.05)) {
                        activeTab = .tasks
                    }
                }
                .foregroundColor(Color(tm.getTheme().foregroundColor).opacity(activeTab == .tasks ? 1 : 0.4))
                .frame(maxWidth: .infinity)
            }
            .padding(/*[.horizontal, .top], */4)
        
        }
        .background(.thinMaterial)
    }
    
}

struct TabBarView_Previews: PreviewProvider {
    @State static var page: Tab = .schedule
    static var previews: some View {
        TabBarView($page)
    }
}
