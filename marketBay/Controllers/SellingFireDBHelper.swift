//
//  SellingFireDBHelper.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation
import FirebaseFirestore

class SellingFireDBHelper: ObservableObject {
    @Published var listings = [Listing]()
    
    private var listener: ListenerRegistration? = nil
    
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
    
    func insert(newData : Listing){
        do {
            try self.db
                .collection(FirebaseConstants.COLLECTION_LISTINGS.rawValue)
                .addDocument(from: newData)
        } catch let err as NSError {
            print(#function, "ERROR: \(err)")
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
    
    func removeListener() {
        listener?.remove()
    }
}
