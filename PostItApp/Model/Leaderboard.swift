//
//  Leaderboard.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import Foundation
import CloudKit

struct Leaderboard : Identifiable, Equatable {
    
    var id = UUID()
    var score : Int
    var name : String
    var record : CKRecord
    
}
