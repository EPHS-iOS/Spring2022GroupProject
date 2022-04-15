//
//  TabView.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import SwiftUI

struct TabsView: View {
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
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
