//
//  UserView.swift
//  PostItApp
//
//  Created by 90305906 on 4/22/22.
//

import SwiftUI

struct UserView: View {
    
    @StateObject var model = PhotoModel()
    
    var body: some View {
        HStack {
            TextField("Enter Name", text: $model.username)
            Button {
                model.changeUsername(newName: model.username)
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
