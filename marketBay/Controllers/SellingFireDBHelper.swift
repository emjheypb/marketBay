//
//  SellingFireDBHelper.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class SellingFireDBHelper: ObservableObject {
    @Published var listings = [Listing]()
    
    var listener: ListenerRegistration? = nil
    
    private let db : Firestore
    init(db: Firestore) {
        self.db = db
    }
    
    //  singleton
    private static var shared: SellingFireDBHelper?
    static func getInstance() -> SellingFireDBHelper {
        if(shared == nil) {
            shared = SellingFireDBHelper(db: Firestore.firestore())
        }
        return shared!
    }
    
    func insert(newData: Listing, completionHandler: @escaping(String?, NSError?) -> Void) {
        do {
            let document = try self.db
                .collection(FirebaseConstants.COLLECTION_LISTINGS.rawValue)
                .addDocument(from: newData)
            completionHandler(document.documentID, nil)
        } catch let err as NSError {
            print(#function, "ERROR: \(err)")
            completionHandler(nil, err)
        }
    }
    
    func update(newData: Listing) {
        do {
            try self.db
            .collection(FirebaseConstants.COLLECTION_LISTINGS.rawValue)
            .document(newData.id!)
            .setData(from: newData)
        } catch let err as NSError {
            print(#function, "ERROR: \(err)")
        }
    }
    
    func updateImage(newData: Listing, newImage: UIImage, completionHandler: @escaping(String?, NSError?) -> Void) {
        uploadImage(userEmail: newData.seller.email, newImage: newImage, fileName: newData.id!) { imageURL, err in
            if let currImageURL = imageURL {
                var updatedData = newData
                updatedData.image = currImageURL
                self.update(newData: updatedData)
                completionHandler(currImageURL, nil)
            }
        }
    }
    
    func uploadImage(userEmail: String, newImage: UIImage, fileName: String, completionHandler: @escaping(String?, NSError?) -> Void) {
        let storageRef = Storage.storage().reference()
        
        let imageData = newImage.jpegData(compressionQuality: 0.8)
        let filePath = "\(userEmail)/\(fileName)"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let imageRef = storageRef.child(filePath)
        let upload = storageRef.child(filePath).putData(imageData!, metadata: metaData) { metadata, error in
            guard let metadata = metadata else {
                print(#function, "FAILED TO UPLOAD PHOTO: \(error)")
                completionHandler(nil, error as NSError?)
                return
            }
            
            imageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print(#function, "FAIALED TO GET DOWNLOAD URL: \(error)")
                    completionHandler(nil, error as NSError?)
                    return
                }
                
                self.db
                    .collection(FirebaseConstants.COLLECTION_LISTINGS.rawValue)
                    .document(fileName)
                    .updateData(["image" : downloadURL.absoluteString])
                
                completionHandler(downloadURL.absoluteString, nil)
                print(#function, downloadURL)
            }
        }
        
    }
    
    func getListingDetails(id: String) -> Listing? {
        return listings.filter({$0.id == id}).first
    }
    
    func getAll(){
        listener = self.db
            .collection(FirebaseConstants.COLLECTION_LISTINGS.rawValue)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print(#function, "FAILED TO RETRIEVE DATA: \(error)")
                    return
                }
                
                snapshot.documentChanges.forEach { documentChange in
                    do {
                        var listing : Listing = try documentChange.document.data(as: Listing.self)
                        listing.id = documentChange.document.documentID
                        
                        let matchedIndex = self.listings.firstIndex(where: {($0.id?.elementsEqual(documentChange.document.documentID))!})
                        
                        switch(documentChange.type){
                        case .added:
                            self.listings.append(listing)
                        case .modified:
                            if(matchedIndex != nil) {
                                self.listings[matchedIndex!] = listing
                            }
                        case .removed:
                            if(matchedIndex != nil) {
                                self.listings.remove(at: matchedIndex!)
                            }
                        }
                    } catch let err as NSError {
                        print(#function, "UNABLE TO CONVERT DATA: \(err)")
                    }
                }
            }
    }
}
