//
//  LeaderboardView.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import SwiftUI

struct LeaderboardView: View {
    
    @EnvironmentObject var model : PhotoModel
    
    var body: some View {
        NavigationView {
            List(model.leaderboard.indices, id: \.self) { i in
                HStack {
                    Text("\(i+1)")
                    Spacer()
                    Text(model.leaderboard[i].name)
                    Text("\(model.leaderboard[i].score)")
                }
            }.refreshable {
                DispatchQueue.main.async {
                    model.fetchAllScores()
                    model.fetchPhotos()
                }
            }
            .navigationTitle("Leaderboard")
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
