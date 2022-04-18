//
//  LeaderboardView.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import SwiftUI

struct LeaderboardView: View {
    
    @StateObject var model = PhotoModel()
    
    var body: some View {
        NavigationView {
            List(model.leaderboard) { place in
                HStack {
                    Text(place.name)
                    Text("\(place.score)")
                }
            }
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
