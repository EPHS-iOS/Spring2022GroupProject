//
//  UserView.swift
//  PostItApp
//
//  Created by 90305906 on 4/22/22.
//

import SwiftUI

struct UserView: View {
    
    @StateObject var model = PhotoModel()
    @EnvironmentObject var scoreModel: PhotoModel
    
    var body: some View {
        HStack {
            TextField("Enter Name", text: $scoreModel.username)
            Button {
                scoreModel.changeUsername(newName: scoreModel.username)
            } label: {
                Label("Save", systemImage: "square.and.arrow.down")
                    .labelStyle(IconOnlyLabelStyle())
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
