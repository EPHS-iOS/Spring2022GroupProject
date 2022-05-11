//
//  PostItAppApp.swift
//  PostItApp
//
//  Created by Jennifer Nelson on 4/14/22.
//

import SwiftUI

@main
struct PostItAppApp: App {
    
    
    
    @StateObject var photoModel = PhotoModel()
    
    
    var body: some Scene {
        WindowGroup {
            
            TabsView()
                .environmentObject(photoModel)
            
                
        }
    }
}
