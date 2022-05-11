//
//  TabView.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import SwiftUI

struct TabsView: View {
    
    @EnvironmentObject var model: PhotoModel
    
    @State var isShowingScreen: Bool = false
    var body: some View {
        TabView {
            
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
                    Text("Users")
                }
        }.onAppear {
            if model.username == ""{
                isShowingScreen = true
            }
        }
        .sheet(isPresented: $isShowingScreen) {
            enterName(isShowing: $isShowingScreen)
        }
    }
    
    
}


struct enterName: View{
    
    @State var text: String = ""
    
    
    @Binding var isShowing: Bool
    @EnvironmentObject var model: PhotoModel
    
    var body: some View{
        TextField("Enter Name", text: $text).onSubmit {
            isShowing = false
            model.username = text
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
