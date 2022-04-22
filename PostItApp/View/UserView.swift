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
        
        TextField("Enter Name", text: $model.username)
        Button {
        
        } label: {
            Label("Save", systemImage: "paperplane")
                .labelStyle(IconOnlyLabelStyle())
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
