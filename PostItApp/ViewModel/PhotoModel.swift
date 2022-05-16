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
import Vision

class PhotoModel : ObservableObject {
    
    @Published var photos = [Photo]()
    @Published var showingAddPhoto = false
    
    @Published var leaderboard = [Leaderboard]()
    @Published var username: String = ""
    @Published var currentScore: Int = 0
    @Published var permissionStatus: Bool = false
    
    @Published var isFailed: Bool = true
    
    
    //Delete the group later
    @Published var group = DispatchGroup()
    @Published var modelPresented: Bool = false
    
    
    var personalRecord: CKRecord? = nil
    

    var ranking = [(contestantIndex: Int, featureprintDistance: Float)]()
    var contestantImageURLs = [URL]()
    
//    let privateDB = CKContainer.default().privateCloudDatabase
//    let publicDB = CKContainer.default().publicCloudDatabase

    //Saved to wrong database; default
    let privateDB = CKContainer.init(identifier: "iCloud.ephs2022.postit").privateCloudDatabase
    let publicDB = CKContainer.init(identifier: "iCloud.ephs2022.postit").publicCloudDatabase
    
    @Published var imageFound: Bool = false
    
    
    
    
    init() {
        fetchRecordID()
        
        
        fetchReferences()
        requestPermission()
        fetchPhotos()
        fetchAllScores{ x -> Void in
           
            if x == true{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self.getReturnScore()
                }
            }
            
        }
        
       //fetchSingleScore()
        
        
        
        //Mine
        
       
    }
    
    
    func saveItemPriv(record: CKRecord) {
        privateDB.save(record) { [weak self] returnedRecord, returnedError in
            print(returnedRecord as Any)
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
               
                self?.fetchAllScores{ x -> Void in
                    if x == true{
                        self?.getReturnScore()
                    }
                    
                }
                self?.getReturnScore()
            }

        }
    }
    
    func checkAndAdd(image: UIImage?, name: String) {

//        let filePath = Bundle.main.path(forResource: "flower", ofType: "jpg")!
//        let tempURL = URL(fileURLWithPath: filePath)
//        let filePath2 = Bundle.main.path(forResource: "rainbow", ofType: "jpg")!
//        let tempURL2 = URL(fileURLWithPath: filePath2)
//        let filePath3 = Bundle.main.path(forResource: "ship", ofType: "jpg")!
//        let tempURL3 = URL(fileURLWithPath: filePath3)
//        contestantImageURLs.append(tempURL)
//        contestantImageURLs.append(tempURL2)
//        contestantImageURLs.append(tempURL3)

        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TempImage.png") else {
            return
        }

        let pngData = image!.pngData();
        do {
            try pngData?.write(to: imageURL);
        } catch { }

        print(contestantImageURLs)
        if processImages(contestantImageURLs: contestantImageURLs, originalImageURL: imageURL) {
            addPhoto(image: image)
            addPoints(name: name)
        } else {
            isFailed = true
            
            print("Trueasdjfasdklfjaskldjf")
            
        }
    }
    
    func processImages(contestantImageURLs: [URL], originalImageURL: URL) -> Bool {
        let originalURL = originalImageURL
        // Make sure we can generate featureprint for original drawing.
        let originalFPO = featureprintObservationForImage(atURL: originalURL)!
        // Generate featureprints for copies and compute distances from original featureprint.
        for idx in contestantImageURLs.indices {
            let contestantImageURL = contestantImageURLs[idx]
            if let contestantFPO = featureprintObservationForImage(atURL: contestantImageURL) {
                do {
                    var distance = Float(0)
                    try contestantFPO.computeDistance(&distance, to: originalFPO)
                    ranking.append((contestantIndex: idx, featureprintDistance: distance))
                } catch {
                    print("Error computing distance between featureprints.")
                }
            }
        }
        // Sort results based on distance.
        ranking.sort { (result1, result2) -> Bool in
            return result1.featureprintDistance < result2.featureprintDistance
        }
        //(contestantIndex: Int, featureprintDistance: Float)
        let ranking1 = ranking[0]
        ranking.removeAll()
        ranking.append(ranking1)
        let ranking1url = contestantImageURLs[ranking1.contestantIndex]
        let userDefaults = UserDefaults.standard
            if self.ranking[0].featureprintDistance < 18 {

//                var urls: [URL] = userDefaults.object(forKey: "found") as? [URL] ?? []
//                let urls = [ranking1url]
//                userDefaults.set(urls, forKey: "found")
//                return true
//
//                if(!isPictureFound(testUrl: ranking1url)) {
//                    urls.append(ranking1url)
//                    userDefaults.set(urls, forKey: "found")
//                    return true
//                } else {
//                    return false
//                }
//
//                return true
                
                var urls: [String] = userDefaults.object(forKey: "found") as? [String] ?? []
                print("ahhh")
                print(urls.count)
                if urls.count != 0 {
                    if(!isPictureFound(testUrl: ranking1url)) {
                        print("ahhh4")
                        urls.append(ranking1url.relativeString)
                        userDefaults.setValue(urls, forKey: "found")
                        imageFound = true
                        return true
                    } else {
                        userDefaults.setValue(urls, forKey: "found")
                        print("ahhh2")
                        
                        return false
                    }
                } else {
                    let tempUrls = [ranking1url.relativeString]
                    userDefaults.setValue(tempUrls, forKey: "found")
                    imageFound = true
                    print("ahhh3")
                    return true
                }
            } else {
                
                return false
            }
    }
    
    func isPictureFound(testUrl: URL) -> Bool {
        let userDefaults = UserDefaults.standard
        let urls: [String] = userDefaults.object(forKey: "found") as? [String] ?? []
        for url in urls {
            if URL(string: url)!.pathComponents.last?.split(separator: ".").last == testUrl.pathComponents.last?.split(separator: ".").last {
                return true
            }
        }
        return false
    }
    
    func featureprintObservationForImage(atURL url: URL) -> VNFeaturePrintObservation? {
        let requestHandler = VNImageRequestHandler(url: url, options: [:])
        let request = VNGenerateImageFeaturePrintRequest()
        do {
            try requestHandler.perform([request])
            return request.results?.first as? VNFeaturePrintObservation
        } catch {
            print("Vision error: \(error)")
            return nil
        }
    }
    
    func checkAndAddDemo(image: UIImage?, name: String) {
        addPhoto(image: image)
        addPoints(name: name)
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
    
    
    func fetchReferences() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ReferencePhotos", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedPhotos = [URL]()
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard
                    let imageAsset = record["photo"] as? CKAsset,
                    let imageURL = imageAsset.fileURL
                else { return }
                returnedPhotos.append(imageURL)
                
            case .failure(let error):
                print(error)
            }
        }
        queryOperation.queryResultBlock = { [weak self] returnedResult in
            print("Returned Result: \(returnedResult)")
            DispatchQueue.main.async {
                self?.contestantImageURLs = returnedPhotos
            }
            
        }
        addOperationPub(operation: queryOperation)
        
    }
    
    func fetchPhotos() {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Photos", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
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
    
    func fetchSingleScore(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Score", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedScore = 0
        var returnedRecord: CKRecord? = nil
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard let score = record["Score"] as? Int else { return }
                returnedScore = score
                returnedRecord = record
            case .failure(let error):
                print(error)
            }
        }
        
        queryOperation.queryResultBlock = { [weak self] returnedResult in
            print("Returned Result: \(returnedResult)")
            DispatchQueue.main.async {
                self?.currentScore = returnedScore
                print("Current Score Var \(self!.currentScore)       Value: \(returnedScore) ")
               
                self?.personalRecord = returnedRecord
               
               
                
            }
        }
        addOperationPriv(operation: queryOperation)
    }
    
    
    //Mine function.
    func getReturnScore(){
        
        print(self.leaderboard.count)
        print(self.username)

            for x in self.leaderboard{
                
                if x.name == self.username{
                    self.currentScore = x.score
                }
            }
        
        
    }
    
    func fetchAllScores(hasFinished: @escaping (Bool)->Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Scores", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "Score", ascending: false)]
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
                print("FINIHEDASDASD")
                hasFinished(true)
                
            }
            
        }
        addOperationPub(operation: queryOperation)
    }
    
    func addPoints(name: String) {
        getReturnScore()
        if currentScore == 0 {
            let newScore = CKRecord(recordType: "Scores")
            newScore["Score"] = 100
            newScore["Name"] = name
            saveItemPub(record: newScore)
            
            let newScorePriv = CKRecord(recordType: "Score")
            newScorePriv["Score"] = 100
            saveItemPriv(record: newScorePriv)
        } else {
            guard let score = leaderboard.first(where: {$0.name == name}) else { return }
            let index = leaderboard.firstIndex(of: score)
            let record = leaderboard[index!].record
            record["Score"]! += 100
            saveItemPub(record: record)
            
            let privRecord = personalRecord
            privRecord!["Score"]! += 100
            saveItemPriv(record: privRecord!)
        }
    }
    
    func addPointsPriv() {
        let newScore = CKRecord(recordType: "Score")
        if currentScore == 0 {
            newScore["Score"] = 100
            saveItemPriv(record: newScore)
        } else {
            let newScore = CKRecord(recordType: "Score")
            newScore["Score"]! += 100
            saveItemPriv(record: newScore)
        }
    }
    
    func requestPermission() {
        //Still at defualt; I want to try and fix something
            //Save the default version
        
        /*
         CKContainer.default().requestApplicationPermission([.userDiscoverability]) { returnedStatus, returnedError in
             DispatchQueue.main.async {
                 if returnedStatus == .granted {
                     self.permissionStatus = true
                 }
             }
         }
         */
        CKContainer(identifier: "iCloud.ephs2022.postit").requestApplicationPermission([.userDiscoverability]) { returnedStatus, returnedError in
            DispatchQueue.main.async {
                if returnedStatus == .granted {
                    self.permissionStatus = true
                }
            }
        }
        
    }
    
    func fetchUserData(id: CKRecord.ID) {
        CKContainer(identifier: "iCloud.ephs2022.postit").discoverUserIdentity(withUserRecordID: id) { [weak self] returnedID, returnedError in
            DispatchQueue.main.async {
                if let firstName = returnedID?.nameComponents?.givenName, let lastName = returnedID?.nameComponents?.familyName {
                    self?.username = firstName + " " + lastName
                }
            }
        }
    }
    
    func fetchRecordID() {
        CKContainer(identifier: "iCloud.ephs2022.postit").fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID {
                self?.fetchUserData(id: id)
            }
        }
    }
    
    
    
}

