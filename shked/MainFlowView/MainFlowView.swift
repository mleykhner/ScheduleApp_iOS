//
//  MainFlowView.swift
//  shked
//
//  Created by Максим Лейхнер on 23.02.2023.
//

import SwiftUI

struct MainFlowView: View {
    
    @State var activeTab: Tab = .schedule
    
    var body: some View {
        ZStack(alignment: .bottom){
            switch activeTab {
            case .news:
                Spacer()
                    .frame(maxHeight: .infinity)
            case .schedule:
                ScheduleView()
            case .tasks:
                Spacer()
                    .frame(maxHeight: .infinity)
            }
            TabBarView($activeTab)
                
        }
    }
}

struct MainFlowView_Previews: PreviewProvider {
    static var previews: some View {
        MainFlowView()
    }
}

enum Tab {
    case news
    case schedule
    case tasks
}
