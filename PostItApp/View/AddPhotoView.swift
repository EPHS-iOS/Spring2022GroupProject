//
//  ImagePickerView.swift
//  PostItApp
//
//  Created by Jennifer Nelson on 4/14/22.
//

import SwiftUI



struct AddPhotoView: View {
    
    @EnvironmentObject var model: PhotoModel
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
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .background(Color.gray)
                } else {
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
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
                        model.checkAndAdd(image: aPM.imageSelected, name: model.username)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            self.model.fetchPhotos()
                            self.model.fetchAllScores()
                            self.model.fetchSingleScore()
                            print(UserDefaults.standard.synchronize())
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                            self.model.fetchPhotos()
                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                    }.disabled(!aPM.changeProfileImage)
                }
            }
            .navigationTitle("Add Photo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotoView()
    }
}
