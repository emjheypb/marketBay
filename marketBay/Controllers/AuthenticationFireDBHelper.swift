//
//  AuthenticationFireDBHelper.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation
import FirebaseFirestore

class AuthenticationFireDBHelper: ObservableObject {
    @Published var user: User?
    @Published var userListings = [MiniListing]()
    
    var listener: ListenerRegistration? = nil
    
    private let db : Firestore
    init(db: Firestore) {
        self.db = db
    }
    
    //  singleton
    private static var shared: AuthenticationFireDBHelper?
    static func getInstance() -> AuthenticationFireDBHelper {
        if(shared == nil) {
            shared = AuthenticationFireDBHelper(db: Firestore.firestore())
        }
        return shared!
    }
    
    func insert(newData : User){
        do {
            try self.db
                .collection(FirebaseConstants.COLLECTION_USERS.rawValue)
                .document(newData.id!)
                .setData(from: newData)
            self.user = newData
        } catch let err as NSError {
            print(#function, "ERROR: \(err)")
        }
    }
    
    func update(newName : String, newPhone : String){
        self.db.collection(FirebaseConstants.COLLECTION_USERS.rawValue)
            .document(self.user!.id!)
            .updateData(["name": newName, "phoneNumber": newPhone]){error in
                if let err = error{
                    print(#function, "Unable to update document: \(err)")
                }
                else{
                    print(#function, "Successfully updated document")
                }
            }
    }
    
    func insertListing(newData : MiniListing, user : String, listingID: String) {
        do {
            try self.db
                .collection(FirebaseConstants.COLLECTION_USERS.rawValue)
                .document(user)
                .collection(FirebaseConstants.COLLECTION_LISTINGS.rawValue)
                .document(listingID)
                .setData(from: newData)
            self.userListings.append(newData)
        } catch let err as NSError {
            print(#function, "ERROR: \(err)")
        }
    }
    
    func updateMiniListing(newData: Listing) {
        do {
            try self.db
                .collection(FirebaseConstants.COLLECTION_USERS.rawValue)
                .document(newData.seller.email)
                .collection(FirebaseConstants.COLLECTION_LISTINGS.rawValue)
                .document(newData.id!)
                .setData(from: newData)
        } catch let err as NSError {
            print(#function, "ERROR: \(err)")
        }
    }
    
    func getUserListings(email: String) {
        listener = self.db
            .collection(FirebaseConstants.COLLECTION_USERS.rawValue)
            .document(email)
            .collection(FirebaseConstants.COLLECTION_LISTINGS.rawValue)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print(#function, "FAILED TO RETRIEVE DATA: \(error)")
                    return
                }
                
                self.userListings.removeAll()
                documents.forEach { snapshot in
                    do {
                        let listing : MiniListing = try snapshot.data(as: MiniListing.self)
                        self.userListings.append(listing)
                    } catch let err as NSError {
                        print(#function, "UNABLE TO CONVERT DATA: \(err)")
                    }
                }
                
                print(#function, self.userListings.count, self.userListings)
            }
    }
    
    func getUser(email: String){
        self.db
            .collection(FirebaseConstants.COLLECTION_USERS.rawValue)
            .document(email)
            .getDocument { user, error in
            guard let currUser = user else {
                print(#function, "FAILED TO RETRIEVE DATA: \(error)")
                return
            }
            do {
                self.user = try currUser.data(as: User.self)
            } catch let err as NSError {
                print(#function, "UNABLE TO CONVERT DATA: \(err)")
            }
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
}
