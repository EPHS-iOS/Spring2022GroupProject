//
//  AllPhotosView.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import SwiftUI

struct AllPhotosView: View {
    
    @StateObject var model = PhotoModel()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading){
                
                ScrollView {
                    
                    GeometryReader{ geo in
                        Spacer()
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 6 ){
                            ForEach(model.photos, id: \.self){ photo in
                                NavigationLink(destination: IndividualPhotoView(photo: photo), label: {
                                    if let url = photo.image, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: geo.size.width/3, height: geo.size.width/3)
                                            .background(Image(systemName: "photo")
                                                .foregroundColor(.white)
                                                .frame(width: geo.size.width/3, height: geo.size.width/3)
                                                .background(Color.gray))
                                            .foregroundColor(.white)
                                    }
                                    
                                })
                            }
                        }
                    }
                    
                }.navigationTitle("\(model.username)   \(model.currentScore)")
                    .navigationBarTitleDisplayMode(.automatic)
                    .font(Font.system(size:46, weight: .bold))
                
            }.toolbar {
                ToolbarItemGroup {
                    Button  {
                        model.showingAddPhoto.toggle()
                    } label: {
                        Label {
                            Text("Add Item")
                        } icon: {
                            Image(systemName: "plus")
                        }
                    }.popover(isPresented: $model.showingAddPhoto) {
                        AddPhotoView()
                    }
                    
                }
            }
            
            
        }.navigationViewStyle(.stack)
            .environmentObject(model)
            .navigationBarHidden(true)
        
        
    }
}


struct AllPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        AllPhotosView()
    }
}
