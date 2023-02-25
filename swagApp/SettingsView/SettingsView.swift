//
//  SettingsView.swift
//  swagApp
//
//  Created by Максим Лейхнер on 24.02.2023.
//

import SwiftUI

struct SettingsView: View {
    
    init(){
        if let data = UserDefaults.standard.value(forKey: "friendsGroups") as? Data {
            friendsGroups = try! PropertyListDecoder().decode(Array<groupWithLabel>.self, from: data)
        } else {
            friendsGroups = []
        }
    }
    
    @StateObject var tm = ThemeManager.shared
    
    @State var preferredGroup: String = UserDefaults().string(forKey: "preferredGroup") ?? ""
//    @State var friendsGroups: [groupWithLabel] = PropertyListDecoder().decode(Array<groupWithLabel>.self, from: UserDefaults.standard.value(forKey: "friendsGroups") as! Data)
    
    @State var friendsGroups: [groupWithLabel]
    @State var newGroup: String = ""
    @State var newGroupLabel: String = ""
    @State var addingNewGroup: Bool = false
    @State var isEditingFriendsGroups: Bool = false
    
    var body: some View {
        //        NavigationView {
        //            List{
        //                Section("Моя группа") {
        //                    TextField("Группа", text: $preferredGroup)
        //                        .onChange(of: preferredGroup) { newValue in
        //                            UserDefaults().set(newValue, forKey: "preferredGroup")
        //                        }
        //                }
        //                Section("Группы друзей") {
        //                    if friendsGroups.isEmpty {
        //                        Text("Нет групп друзей")
        //                            .foregroundColor(Color.white.opacity(0.3))
        //                    }
        //                    ForEach(friendsGroups, id: \.self){ group in
        //                        Text(group)
        //                            .swipeActions {
        //                                Button {
        //                                    friendsGroups.remove(at: friendsGroups.firstIndex(of: group)!)
        //                                    UserDefaults().set(friendsGroups, forKey: "friendsGroups")
        //                                } label: {
        //                                    Label("Удалить", systemImage: "trash")
        //                                }
        //                            }
        //                            .transition(.opacity)
        //                    }
        //                    if addingNewGroup {
        //                        TextField("Группа", text: $newGroup)
        //                            .onSubmit {
        //                                friendsGroups.append(newGroup)
        //                                UserDefaults().set(friendsGroups, forKey: "friendsGroups")
        //                                newGroup.removeAll()
        //                                addingNewGroup.toggle()
        //                            }
        //                    } else {
        //                        Button{
        //                            withAnimation {
        //                                addingNewGroup.toggle()
        //                            }
        //                        } label: {
        //                            Label("Добавить новую", systemImage: "plus")
        //                        }
        //                    }
        //                }
        //            }
        //            .navigationTitle("Настройки")
        //       }
        ScrollView(.vertical) {
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
                            Button{
                                //Изменение группы
                            } label: {
                                Text("edit")
                                    .font(.custom("Unbounded", size: 12))
                                    .fontWeight(.regular)
                            }
                        }
                        TextField("group", text: $preferredGroup)
                            .font(.custom("Golos Text VF", size: 16))
                            .fontWeight(.medium)
                            .disabled(true) //Активировать с кнопки
                        //.focused() //Переключить фокус
                            .onSubmit {
                                UserDefaults().set(preferredGroup, forKey: "preferredGroup")
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
                                    TextField("Ярлык", text: $newGroupLabel)
                                        .font(.custom("Golos Text VF", size: 16))
                                        .fontWeight(.medium)
                                    Spacer()
                                    TextField("group", text: $newGroup)
                                        .font(.custom("Golos Text VF", size: 16))
                                        .fontWeight(.medium)
                                        .onSubmit {
                                            friendsGroups.append(groupWithLabel(label: newGroupLabel, group: newGroup))
                                            UserDefaults.standard.set(try? PropertyListEncoder().encode(friendsGroups), forKey: "friendsGroups")
                                            newGroup.removeAll()
                                            addingNewGroup.toggle()
                                        }
                                }
                                
                                    
                            } else {
                                Button {
                                    addingNewGroup.toggle()
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
                .background(Color.black.opacity(0.03))
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
