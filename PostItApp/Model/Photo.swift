//
//  Photo.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import Foundation
import UIKit
import CloudKit

struct Photo : Identifiable, Hashable {
    
    var id = UUID()
    var image : URL?
    var record : CKRecord
}
