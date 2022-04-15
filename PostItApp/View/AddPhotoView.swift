//
//  ImagePickerView.swift
//  PostItApp
//
//  Created by Jennifer Nelson on 4/14/22.
//

import SwiftUI



struct AddPhotoView: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject var aPM = AddPhotoModel()
    
    var body: some View {
        
        NavigationView {
            
            
            Button {
                aPM.useCamera = true
                aPM.changeProfileImage = true
                aPM.openCameraRoll = true
                
            } label: {
                if aPM.changeProfileImage {
                    Image(uiImage: aPM.imageSelected)
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
            }.sheet(isPresented: $aPM.openCameraRoll) {
                ImagePicker(selectedImage: $aPM.imageSelected, sourceType: .camera)
            }
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        photoModel.addItem(image: aPM.imageSelected)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            self.photoModel.fetchItems()
                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                    }.disabled(!aPM.changeProfileImage)
                }
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotoView()
    }
}