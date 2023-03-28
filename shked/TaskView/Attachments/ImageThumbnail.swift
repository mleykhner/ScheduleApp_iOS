//
//  ImageThumbnail.swift
//  shked
//
//  Created by Максим Лейхнер on 13.03.2023.
//

import SwiftUI

struct ImageThumbnail: View {
    
    init(imageData: Data) {
        self.imageData = imageData
        self.image = Image(uiImage: UIImage(data: imageData)!)
    }
    
    let imageData: Data
    @State var image: Image
    @State var isPresented: Bool = false
    var body: some View {
        Image(uiImage: UIImage(data: imageData)!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 105, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .shadow(color: Color.black.opacity(0.1), radius: 2)
            .padding(2)
            .onTapGesture {
                isPresented.toggle()
            }
            .fullScreenCover(isPresented: $isPresented) {
                PinchZoomView(imageData: imageData)
                    .ignoresSafeArea()
                    .overlay(alignment: .topTrailing) {
                        Button {
                            isPresented.toggle()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .padding(10)
                                .background(Material.ultraThin)
                                .clipShape(Circle())
                                .padding(12)
                        }
                    }
            }
//            .fullScreenCover(isPresented: $isPresented) {
//                Image(uiImage: UIImage(data: imageData)!)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .pinchToZoom()
//                    .overlay(alignment: .topTrailing) {
//                        Button {
//                            isPresented.toggle()
//                        } label: {
//                            Image(systemName: "xmark")
//                                .font(.system(size: 20))
//                                .padding(10)
//                                .background(Material.ultraThin)
//                                .clipShape(Circle())
//                                .padding(12)
//                        }
//                    }
//            }
        
    }
}

struct ImageThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        //ImageThumbnail()
        Text("")
    }
}

//Button {
//    isPresented.toggle()
//} label: {
//    Image(systemName: "multiply")
//        .font(.system(size: 24))
//        .padding(8)
//        .background(Material.ultraThin)
//        .clipShape(Circle())
//        .padding(18)
//}
