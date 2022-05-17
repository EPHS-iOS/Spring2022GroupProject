//
//  UserView.swift
//  PostItApp
//
//  Created by 90305906 on 4/22/22.
//

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var model : PhotoModel
    
    var body: some View {
        ScrollView {
            VStack {
      
            Image("postItArts")
              Text("AP CSP creates these installations as a class project.")
                    .padding()
                    .frame(maxWidth: 400, alignment: .center)
                    .multilineTextAlignment(.center)
              Text("iOS App Dev created this app.")
                    .padding()
                    .frame(maxWidth: 400, alignment: .center)
                    
                Text("AP CSP is the first CS course at Eden Prairie High School. We focus on:")
                    .frame(maxWidth: 400, alignment: .center)
                    .multilineTextAlignment(.leading)
                    .padding()
                
           
                Text("- Making connections between concepts in computing")
                        .frame(maxWidth: 400, alignment: .leading)
                Text("- Designing a program to solve a problem or complete a task")
                        .frame(maxWidth: 400, alignment: .leading)
                       // .multilineTextAlignment(.center)
                Text("- Applying abstractions in computation and modeling")
                        .frame(maxWidth: 400, alignment: .leading)
                Text("- Analyzing computational work")
                        .frame(maxWidth: 400, alignment: .leading)
                Text("- Communicating ideas about technology and computation")
                    .frame(maxWidth: 400, alignment: .leading)
               Text("- Working collaboratively to solve problems")
                    .frame(maxWidth: 400, alignment: .leading)
                    
                    .frame(maxWidth: 400, alignment: .leading)
                
                
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}

