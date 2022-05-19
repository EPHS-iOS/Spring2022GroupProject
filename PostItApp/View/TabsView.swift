//
//  TabView.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import SwiftUI

struct TabsView: View {
    
    @StateObject var model = PhotoModel()
    @State var num = 0
    
    var body: some View {
        TabView {
            if model.username != ""{
            AllPhotosView().environmentObject(model)
                .tabItem() {
                    Image(systemName: "photo.on.rectangle")
                    Text("Photos")
                }
            
            LeaderboardView().environmentObject(model)
                .tabItem() {
                    Image(systemName: "flag.and.flag.filled.crossed")
                    Text("Leaderboard")
                }
            
            UserView().environmentObject(model)
                .tabItem() {
                    Image(systemName: "person")
                    Text("About Us")
                }
            }
        }
    }
    
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
