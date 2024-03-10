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
            //  you don’t need to create a subcollection
            //  you don’t need to ask user to sign up or sign in
            try self.db
                .collection(FirebaseConstants.COLLECTION_LISTINGS.rawValue)
                .addDocument(from: newData)
        } catch let err as NSError {
            print(#function, "ERROR: \(err)")
        }
    }
}
