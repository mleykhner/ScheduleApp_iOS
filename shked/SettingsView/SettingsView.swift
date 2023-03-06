//
//  SettingsView.swift
//  shked
//
//  Created by Максим Лейхнер on 24.02.2023.
//

import SwiftUI

struct SettingsView: View {
    
    private enum Field : Int, Hashable {
        case myGroup, friendGroupLabel, friendGroup
    }
    
    init(){
        if let data = UserDefaults.standard.value(forKey: "friendsGroups") as? Data {
            friendsGroups = try! PropertyListDecoder().decode(Array<groupWithLabel>.self, from: data)
        } else {
            friendsGroups = []
        }
    }
    
    @StateObject var tm = ThemeManager.shared
    
    @State var preferredGroup: String = UserDefaults().string(forKey: "preferredGroup") ?? ""
    @State var friendsGroups: [groupWithLabel]
    
    @State var newGroup: String = ""
    @State var newGroupLabel: String = ""
    
    @State var addingNewGroup: Bool = false
    @State var groupNumberTyped: Bool = false
    @State var isEditingFriendsGroups: Bool = false
    @State var isEditingMyGroup: Bool = false
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("settings")
                .font(.custom("Unbounded", size: 32))
                .fontWeight(.bold)
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
                .frame(height: 20)
            VStack(alignment: .leading) {
                Text("schedule")
                    .font(.custom("Unbounded", size: 20))
                    .fontWeight(.medium)
                    .padding(.horizontal, 18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 18){
                    VStack {
                        HStack(alignment: .firstTextBaseline){
                            Text("myGroup")
                                .font(.custom("Unbounded", size: 16))
                                .fontWeight(.regular)
                            Spacer()
                            if !isEditingMyGroup {
                                Button{
                                    withAnimation{
                                        isEditingMyGroup.toggle()
                                    }
                                    focusedField = .myGroup
                                } label: {
                                    Text("edit")
                                        .font(.custom("Unbounded", size: 12))
                                        .fontWeight(.regular)
                                }
                            }
                        }
                        TextField("group", text: $preferredGroup)
                            .font(.custom("Golos Text VF", size: 16))
                            .fontWeight(.medium)
                            .disabled(!isEditingMyGroup) //Активировать с кнопки
                            .focused($focusedField, equals: .myGroup)
                            .onSubmit {
                                UserDefaults().set(preferredGroup, forKey: "preferredGroup")
                                isEditingMyGroup.toggle()
                            }
                            .padding(12)
                            .background(Color(tm.getTheme().backgroundColor))
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        
                    }
                    
                    VStack {
                        HStack(alignment: .firstTextBaseline){
                            Text("friendsGroups")
                                .font(.custom("Unbounded", size: 16))
                                .fontWeight(.regular)
                            Spacer()
                            if !friendsGroups.isEmpty {
                                Button{
                                    withAnimation {
                                        isEditingFriendsGroups.toggle()
                                    }
                                    focusedField = .friendGroup
                                } label: {
                                    Text(isEditingFriendsGroups ? "Готово" : "edit")
                                        .font(.custom("Unbounded", size: 12))
                                        .fontWeight(.regular)
                                }
                            }
                        }
                        VStack{
                            ForEach(friendsGroups, id: \.self){ group in
                                HStack{
                                    Text(group.label)
                                        .font(.custom("Golos Text VF", size: 16))
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text(group.group.longDash())
                                        .font(.custom("Golos Text VF", size: 16))
                                        .fontWeight(.regular)
                                        .opacity(0.7)
                                    if isEditingFriendsGroups {
                                        Button{
                                            friendsGroups.remove(at: friendsGroups.firstIndex(of: group)!)
                                            UserDefaults.standard.set(try? PropertyListEncoder().encode(friendsGroups), forKey: "friendsGroups")
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(Color.red)
                                        }
                                    }
                                    
                                }
                                
                                    
                                Divider()
                            }
                            if addingNewGroup {
                                HStack{
                                    if groupNumberTyped {
                                        TextField("tag", text: $newGroupLabel)
                                            .font(.custom("Golos Text VF", size: 16))
                                            .fontWeight(.medium)
                                            .focused($focusedField, equals: .friendGroupLabel)
                                            .onSubmit {
                                                friendsGroups.append(groupWithLabel(label: newGroupLabel, group: newGroup))
                                                UserDefaults.standard.set(try? PropertyListEncoder().encode(friendsGroups), forKey: "friendsGroups")
                                                newGroup.removeAll()
                                                newGroupLabel.removeAll()
                                                addingNewGroup.toggle()
                                                groupNumberTyped.toggle()
                                            }
                                        Spacer()
                                        Text(newGroup.longDash())
                                            .font(.custom("Golos Text VF", size: 16))
                                            .fontWeight(.regular)
                                            .opacity(0.7)
                                    } else {
                                        TextField("group", text: $newGroup)
                                            .font(.custom("Golos Text VF", size: 16))
                                            .fontWeight(.medium)
                                            .focused($focusedField, equals: .friendGroup)
                                            .onSubmit {
                                                groupNumberTyped.toggle()
                                                focusedField = .friendGroupLabel
                                            }
                                    }
                                }
                                
                                    
                            } else {
                                Button {
                                    addingNewGroup.toggle()
                                    focusedField = .friendGroup
                                } label: {
                                    HStack{
                                        Text("addNew")
                                        Spacer()
                                        Image(systemName: "plus")
                                    }
                                }
                            }
                            
                        }
                        .padding(12)
                        .background(Color(tm.getTheme().backgroundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        Text("friendsGroupsDescription")
                            .font(.custom("Golos Text VF", size: 13))
                            .foregroundColor(Color(tm.getTheme().foregroundColor).opacity(0.7))
                        
                        
                    }
                }
                .padding(18)
                .background(Color(tm.getTheme().foregroundColor).opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            }
            Spacer()
                .frame(height: 20)
            VStack{
                Text("Тема")
                    .font(.custom("Unbounded", size: 20))
                    .fontWeight(.medium)
                    .padding(.horizontal, 18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 18){
                    Text("themeDescription")
                        .font(.custom("Golos Text VF", size: 13))
                        .foregroundColor(Color(tm.getTheme().foregroundColor).opacity(0.7))
                    VStack(spacing: 4){
                        ClassView(ClassObject: ClassModel(name: "Физика", ordinal: 1, type: .lecture, location: "ГУК Б-261"))
                        ClassView(ClassObject: ClassModel(name: "Философия", ordinal: 2, type: .practical, location: "3-431"))
                    }
                    .padding(18)
                    .background(Color(tm.getTheme().backgroundColor))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, -18)
                    
                    
                    HStack{
                        VStack {
                            Button {
                                withAnimation {
                                    tm.setTheme(MinimalTheme())
                                }
                                tm.setTheme(MinimalTheme())
                            } label: {
                                Image("MinimalThemePreview")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                            Text("Монохромная")
                                .font(.custom("Unbounded", size: 12))
                        }
                        .frame(maxWidth: .infinity)
                        VStack {
                            Button {
                                withAnimation {
                                    tm.setTheme(CalmTheme())
                                }
                            } label: {
                                Image("CalmThemePreview")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                            Text("Спокойная")
                                .font(.custom("Unbounded", size: 12))
                        }
                        .frame(maxWidth: .infinity)
                        VStack {
                            Button {
                                withAnimation {
                                    tm.setTheme(SWAGTheme())
                                }
                            } label: {
                                Image("SWAGThemePreview")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                            Text("Яркая")
                                .font(.custom("Unbounded", size: 12))
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                }
                .padding(18)
                .background(Color(tm.getTheme().foregroundColor).opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            }
        }
        .foregroundColor(Color(tm.getTheme().foregroundColor))
    }
}

struct groupWithLabel : Hashable, Codable {
    var label: String
    var group: String
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension String {
    func longDash() -> String {
        return self.replacing("-", with: "–")
    }
}
