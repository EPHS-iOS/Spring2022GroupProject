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
    
    @State var showing: Bool = false
    
    @State var offset: Int = -400
    var body: some View {
        ZStack{
           
                RoundedRectangle(cornerRadius: 12).frame(width: 300, height: 400, alignment: .center)
                .foregroundColor(model.isFailed ? .red : .green)
                    .transition(.slide)
                    
                    .overlay{
                        VStack {
                            Image(model.isFailed ? "sadFace" : "happyFace")
                            Text(  model.imageFound ? "Image Found Already" : model.isFailed ? "Sorry, no match was found." : "Congrats, the image was a match")
                                .font(.title2)
                        }
                        
                    }
                    .animation(.easeInOut(duration: 1), value: offset)
                    .offset(x: CGFloat(offset))
            }
        .onAppear {
           offset = 0
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                offset = 400
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                isPresented = false
//                model.isFailed = false
//                }
//
//
//            }
        }
        .onTapGesture {
            offset = 400
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isPresented = false
            model.isFailed = false
            
            model.imageFound = false
            print("MODEL IS FOUND \(model.imageFound)")
            }
        }
        
        }
       
    
}

struct isWrongModalView_Previews: PreviewProvider {
    static var previews: some View {
        isWrongModalView(isPresented: Binding.constant(true))
    }
}
