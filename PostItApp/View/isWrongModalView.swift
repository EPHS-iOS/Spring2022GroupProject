//
//  isWrongModalView.swift
//  PostItApp
//
//  Created by 90310148 on 5/10/22.
//

import SwiftUI

struct isWrongModalView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var model: PhotoModel
    var body: some View {
        ZStack{
            if isPresented{
                RoundedRectangle(cornerRadius: 12).frame(width: 300, height: 300, alignment: .center)
                    .foregroundColor(Color.gray)
                    .animation(.easeInOut, value: isPresented)
                    .transition(.slide)
                    .overlay{
                       
                        Text(model.isFailed ? "Sorry there was no match" : "Congrats, the image was a match")
                    }
            }
        
        }
        .onChange(of: isPresented) { V in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isPresented = false
                model.isFailed = false
            }
        }
    }
}

struct isWrongModalView_Previews: PreviewProvider {
    static var previews: some View {
        isWrongModalView(isPresented: Binding.constant(true))
    }
}
