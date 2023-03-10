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
            friendsGroups = try! PropertyListDecoder().decode(Array<GroupWithLabel>.self, from: data)
        } else {
            friendsGroups = []
        }
    }
    
    let generator = UINotificationFeedbackGenerator()
    
    @StateObject var tm = ThemeManager.shared
    @StateObject var vm = SettingsViewModel()
    
    @State var preferredGroup: String = UserDefaults().string(forKey: "preferredGroup") ?? ""
    @State var friendsGroups: [GroupWithLabel]
    
    @State var newGroup: String = ""
    @State var newGroupLabel: String = ""
    
    @State var addingNewGroup: Bool = false
    @State var groupNumberTyped: Bool = false
    @State var isEditingFriendsGroups: Bool = false
    @State var isEditingMyGroup: Bool = false
    @State var showInvalidGroupNameAlert: Bool = false
    
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
                        HStack{
                            TextField("group", text: $preferredGroup)
                                .font(.custom("PT Root UI VF", size: 16))
                                .fontWeight(.medium)
                                .monospacedDigit()
                                .disabled(!isEditingMyGroup) //Активировать с кнопки
                                .focused($focusedField, equals: .myGroup)
                                .onSubmit {
                                    isEditingMyGroup.toggle()
                                    Task {
                                        if let responce = await vm.checkGroupName(preferredGroup) {
                                            if responce.isValid {
                                                generator.notificationOccurred(.success)
                                                preferredGroup = responce.formattedGroup ?? preferredGroup
                                                UserDefaults.standard.set(preferredGroup, forKey: "preferredGroup")
                                            }
                                            else {
                                                //!!!
                                                showInvalidGroupNameAlert.toggle()
                                                generator.notificationOccurred(.error)
                                                preferredGroup = UserDefaults.standard.string(forKey: "preferredGroup") ?? ""
                                            }

                                        }
                                        else {
                                            generator.notificationOccurred(.error)
                                            preferredGroup = UserDefaults.standard.string(forKey: "preferredGroup") ?? ""
                                        }
                                    }
                                    
                                    
                                    
                                }
                            Spacer()
                            if vm.isCheckingGroupValidity {
                                ProgressView()
                            }
                        }
                        .padding(12)
                        .background(Color(tm.getTheme().backgroundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .alert("Неизвестная группа", isPresented: $showInvalidGroupNameAlert) {
                            Button{
                                showInvalidGroupNameAlert.toggle()
                            } label: {
                                Text("ok")
                            }
                        } message: {
                            Text("Ты педик блять пиши группу блять нормальную сука")
                        }

                        
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
                                        .font(.custom("PT Root UI VF", size: 16))
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text(group.group.longDash())
                                        .font(.custom("PT Root UI VF", size: 16))
                                        .fontWeight(.regular)
                                        .monospacedDigit()
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
                                            .font(.custom("PT Root UI VF", size: 16))
                                            .fontWeight(.medium)
                                            .monospacedDigit()
                                            .focused($focusedField, equals: .friendGroupLabel)
                                            .onSubmit {
                                                friendsGroups.append(GroupWithLabel(label: newGroupLabel, group: newGroup))
                                                UserDefaults.standard.set(try? PropertyListEncoder().encode(friendsGroups), forKey: "friendsGroups")
                                                newGroup.removeAll()
                                                newGroupLabel.removeAll()
                                                addingNewGroup.toggle()
                                                groupNumberTyped.toggle()
                                            }
                                        Spacer()
                                        Text(newGroup.longDash())
                                            .font(.custom("PT Root UI VF", size: 16))
                                            .fontWeight(.regular)
                                            .opacity(0.7)
                                    } else {
                                        TextField("group", text: $newGroup)
                                            .font(.custom("PT Root UI VF", size: 16))
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
                            .font(.custom("PT Root UI VF", size: 13))
                            .fontWeight(.semibold)
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
                        .font(.custom("PT Root UI VF", size: 13))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(tm.getTheme().foregroundColor).opacity(0.7))
                    VStack(spacing: 4){
                        ClassView(classObject: ClassModel(name: "Физика", ordinal: 1, type: .lecture, location: "ГУК Б-261")).disabled(true)
                        ClassView(classObject: ClassModel(name: "Философия", ordinal: 2, type: .practical, location: "3-431")).disabled(true)
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

struct GroupWithLabel : Hashable, Codable {
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
