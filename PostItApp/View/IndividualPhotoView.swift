//
//  IndividualPhotoView.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import SwiftUI

struct IndividualPhotoView: View {
    var photo: Photo
    @EnvironmentObject var photoModel: PhotoModel
    @StateObject var model = PhotoModel()
    
    var body: some View {
        
        VStack {
            if let url = photo.image, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .frame(height: 300)
            }
        }.toolbar {
            ToolbarItemGroup {
                HStack {
                    Button {
                        photoModel.deleteItem(input: photo)
                    } label: {
                        Label {
                            Text("Delete")
                        } icon: {
                            Image(systemName: "trash")
                        }
                        
                    }
                    
                }
            }
        }
    }
}
