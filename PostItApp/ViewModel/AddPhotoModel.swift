//
//  AddLostItemModel.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import Foundation
import UIKit

class AddPhotoModel: ObservableObject {
    
    @Published var useCamera = true
    @Published var changeProfileImage = false
    @Published var openCameraRoll = false
    @Published var imageSelected = UIImage()
    
}
