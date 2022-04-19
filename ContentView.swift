//
//  ContentView.swift
//  ScavengeItAnimations
//
//  Created by Lucas Wagner on 4/18/22.
//

import SwiftUI
import Lottie

struct ContentView: View {
    
    @State var opacity : Double = 0
    
    var body: some View {
        HStack {
   
        OnboardingScreen()
                .padding(.trailing, -75)
            Image("ScavengeItLogo")
                .resizable()
                .frame(width: 200, height: 75, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .opacity(opacity)
                .animation(Animation.easeIn(duration: 2), value: opacity)
             
                                              
        } .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                           opacity = 1
                print(opacity)
                        }
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
