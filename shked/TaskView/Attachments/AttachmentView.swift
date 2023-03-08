//
//  AttachmentView.swift
//  shked
//
//  Created by Максим Лейхнер on 08.03.2023.
//

import SwiftUI

struct AttachmentView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .frame(width: 84, height: 112)
    }
}

struct AttachmentView_Previews: PreviewProvider {
    static var previews: some View {
        AttachmentView()
    }
}
