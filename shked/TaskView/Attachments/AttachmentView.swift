//
//  AttachmentView.swift
//  shked
//
//  Created by Максим Лейхнер on 08.03.2023.
//

import SwiftUI

struct AttachmentView: View {
    let attachment: Attachment
    var body: some View {
        ZStack (alignment: .bottomLeading){
            Image(uiImage: UIImage(data: attachment.thumbnail)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
            if attachment.type != .image {
                Text(attachment.type.preferredFilenameExtension?.uppercased() ?? "")
                    .font(.custom("Unbounded", size: 16))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2.8)
                    .foregroundColor(Color.white)
                    .background(
                        Color.blue.opacity(0.4)
                            .background(Material.ultraThin)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                    .padding(7)
                }
            }
            .frame(width: 105, height: 140)
            .clipShape(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 2)
            .padding(2)
    }
}

struct AttachmentView_Previews: PreviewProvider {
    static let test = Attachment(thumbnail: (UIImage(named: "Image")?.jpegData(compressionQuality: 0.5))!, type: .image)
    static var previews: some View {
        AttachmentView(attachment: test)
    }
}
