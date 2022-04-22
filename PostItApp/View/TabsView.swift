//
//  TabView.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import SwiftUI

struct TabsView: View {
    
    @StateObject var model = PhotoModel()
    
    var body: some View {
        TabView {
            
            AllPhotosView()
                .tabItem() {
                    Image(systemName: "photo.on.rectangle")
                    Text("Photos")
                }
            
            LeaderboardView()
                .tabItem() {
                    Image(systemName: "flag.and.flag.filled.crossed")
                    Text("Leaderboard")
                }
            
            UserView()
                .tabItem() {
                    Image(systemName: "person")
                    Text("Users")
                }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
