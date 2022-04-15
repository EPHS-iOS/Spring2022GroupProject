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
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    
    init() {
        fetchItems()
    }
    
    
    func saveItem(record: CKRecord) {
        privateDB.save(record) { [weak self] returnedRecord, returnedError in
            print(returnedRecord)
            print(returnedError)
            DispatchQueue.main.async {
                self?.fetchItems()
            }
            
        }
    }
    
    
    func addItem(image: UIImage?) {
        let newPhoto = CKRecord(recordType: "Photos")
        
        guard
            let image = image,
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("tempimage\(UUID().uuidString).jpg"),
            let data = image.jpegData(compressionQuality: 0.5) else { return }

        do {
            try data.write(to: url)
            let asset = CKAsset(fileURL: url)
            newPhoto["Photo"] = asset
            saveItem(record: newPhoto)
        } catch let error {
            print(error)
        }
    }
    
    
    func fetchItems() {
        
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
        addOperation(operation: queryOperation)
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        privateDB.add(operation)
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
    
}
