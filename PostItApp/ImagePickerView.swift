//
//  ImagePickerView.swift
//  PostItApp
//
//  Created by Jennifer Nelson on 4/14/22.
//

import SwiftUI

struct ImagePickerView: View {
    
    @State var useCamera = true
    @State var changeProfileImage = false
    @State var openCameraRoll = false
    @State var imageSelected = UIImage()
    
    var body: some View {
        Menu {
            Button {
                useCamera = true
                changeProfileImage = true
                openCameraRoll = true
            } label: {
                Label {
                    Text("Camera")
                } icon: {
                    Image(systemName: "camera")
                }
            }
            Button {
                useCamera = false
                changeProfileImage = true
                openCameraRoll = true
            } label: {
                Label {
                    Text("Photo Library")
                } icon: {
                    Image(systemName: "photo.on.rectangle")
                }
            }
        } label: {
            if changeProfileImage {
                Image(uiImage: imageSelected)
                    .resizable()
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    .frame(width: 300, height: 300)
                    .background(Color.gray)
            } else {
                HStack {
                    Spacer()
                    Image(systemName: "photo")
                        .frame(width: 300, height: 300)
                        .foregroundColor(.white)
                        .background(Color.gray)
                    Spacer()
                }
            }
        }
    }
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView()
    }
}
