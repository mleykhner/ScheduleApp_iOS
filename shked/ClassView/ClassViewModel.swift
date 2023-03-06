//
//  ClassViewModel.swift
//  shked
//
//  Created by Максим Лейхнер on 18.02.2023.
//

import Foundation

class ClassViewModel : ObservableObject {
    
    func reloadView(){
        objectWillChange.send()
    }
    
    func getColorIndexForClass(_ name: String) -> UInt {
        let colorIndex = UserDefaults.standard.integer(forKey: name)
        
        if colorIndex != 0{
            return colorIndex.magnitude - 1
        }
        
        return name.hash.magnitude
    }
    
    func saveColorIndexForClass(name: String, index: UInt){
        UserDefaults.standard.set(index + 1, forKey: name)
    }
    
}
