//
//  IndividualPhotoView.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import SwiftUI

struct IndividualPhotoView: View {
    var photo: Photo
    @EnvironmentObject var model: PhotoModel
    
    
    var body: some View {
        
        VStack {
            if let url = photo.image, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .frame(height: 300)
            }
        }
    }
}
