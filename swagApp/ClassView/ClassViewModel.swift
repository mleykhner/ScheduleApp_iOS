//
//  ClassViewModel.swift
//  swagApp
//
//  Created by Максим Лейхнер on 18.02.2023.
//

import Foundation

class ClassViewModel : ObservableObject {
    func reloadView(){
        objectWillChange.send()
    }
}
