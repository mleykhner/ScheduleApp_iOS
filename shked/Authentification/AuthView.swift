//
//  AuthView.swift
//  shked
//
//  Created by Максим Лейхнер on 25.03.2023.
//

import SwiftUI

struct AuthView: View {
    var body: some View {
        VKIDButton()
            .frame(height: 50)
            .padding(12)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
