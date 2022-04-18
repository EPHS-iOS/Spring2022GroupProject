//
//  Model.swift
//  PostItApp
//
//  Created by 90305906 on 4/15/22.
//

import Foundation
import UIKit
import CloudKit
import SwiftUI

class PhotoModel : ObservableObject {
    
    @Published var photos = [Photo]()
    @Published var showingAddPhoto = false
    
    @Published var leaderboard = [Leaderboard]()
    @Published var username: String = ""
    @Published var currentScore: Int = 0
    
    let privateDB = CKContainer.default().privateCloudDatabase
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    init() {
        
        fetchRecordID()
        fetchPhotos()
    }
    
    
    func saveItemPriv(record: CKRecord) {
        privateDB.save(record) { [weak self] returnedRecord, returnedError in
            print(returnedRecord)
            print(returnedError)
            DispatchQueue.main.async {
                self?.fetchPhotos()
            }
            
        }
    }
    
    func saveItemPub(record: CKRecord) {
        publicDB.save(record) { [weak self] returnedRecord, returnedError in
            print(returnedRecord)
            print(returnedError)
            DispatchQueue.main.async {
                self?.fetchSingleScore(name: self!.username)
                self?.fetchAllScores()
            }

        }
    }
    
    func checkAndAdd(image: UIImage?, name: username) {
        if /* matches picture */ {
            addPhoto(image: image)
            addPoints()
        } else {
            // feedback saying "doesnt match"
        }
    }
    
    func addPhoto(image: UIImage?) {
        let newPhoto = CKRecord(recordType: "Photos")
        
        guard
            let image = image,
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("tempimage\(UUID().uuidString).jpg"),
            let data = image.jpegData(compressionQuality: 0.5) else { return }

        do {
            try data.write(to: url)
            let asset = CKAsset(fileURL: url)
            newPhoto["Photo"] = asset
            saveItemPriv(record: newPhoto)
        } catch let error {
            print(error)
        }
    }
    
    
    func fetchPhotos() {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Photos", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedPhotos = [Photo]()
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard
                    let imageAsset = record["Photo"] as? CKAsset,
                    let imageURL = imageAsset.fileURL
                else { return }
                returnedPhotos.append(Photo(image: imageURL, record: record))
                
            case .failure(let error):
                print(error)
            }
        }
        
        queryOperation.queryResultBlock = { [weak self] returnedResult in
            print("Returned Result: \(returnedResult)")
            DispatchQueue.main.async {
                self?.photos = returnedPhotos
            }
            
        }
        addOperationPriv(operation: queryOperation)
    }
    
    func addOperationPriv(operation: CKDatabaseOperation) {
        privateDB.add(operation)
    }
    
    func addOperationPub(operation: CKDatabaseOperation) {
        publicDB.add(operation)
    }
    
    func deleteItem(input: Photo) {
        guard let photo = photos.first(where: {$0.id == input.id}) else { return }
        let index = photos.firstIndex(of: photo)
        let record = input.record
            
        privateDB.delete(withRecordID: record.recordID) { [weak self] returnedRecordID, returnedError in
            DispatchQueue.main.async {
                self?.photos.remove(at: index!)
            }
        }
    }
    
    func fetchSingleScore(name: String){
        let predicate = NSPredicate(format: "name = %@", argumentArray: [name])
        let query = CKQuery(recordType: "Scores", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedScore = 0
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard
                    let score = record["Score"] as? Int
                else { return }
                returnedScore = score
                
            case .failure(let error):
                print(error)
            }
        }
        
        queryOperation.queryResultBlock = { [weak self] returnedResult in
            print("Returned Result: \(returnedResult)")
            DispatchQueue.main.async {
                self?.currentScore = returnedScore
            }
        }
        addOperationPub(operation: queryOperation)
    }
    
    
    
    func fetchAllScores() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Scores", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedScores = [Leaderboard]()
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard
                    let score = record["Score"] as? Int,
                    let name = record["Name"] as? String
                else { return }
                returnedScores.append(Leaderboard(score: score, name: name, record: record))
                
            case .failure(let error):
                print(error)
            }
        }
        
        queryOperation.queryResultBlock = { [weak self] returnedResult in
            print("Returned Result: \(returnedResult)")
            DispatchQueue.main.async {
                self?.leaderboard = returnedScores
            }
            
        }
        addOperationPub(operation: queryOperation)
    }
    
    func fetchScore() {
        
    }
    
    func addPoints(name: String) {
        fetchSingleScore(name: name)
        if currentScore == 0 {
            let newScore = CKRecord(recordType: "Scores")
            newScore["Score"] = 500
            newScore["Name"] = name
            saveItemPriv(record: newScore)
        } else {
            guard let score = leaderboard.first(where: {$0.name == name}) else { return }
            let index = leaderboard.firstIndex(of: score)
            
        }
        
        
        
        
    }
    
    func fetchUserData(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedID, returnedError in
            DispatchQueue.main.async {
                if let name = returnedID?.nameComponents?.givenName {
                    self?.username = name
                }
            }
        }
    }
    
    func fetchRecordID() {
        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID {
                self?.fetchUserData(id: id)
            }
        }
    }
    
    
    
}
