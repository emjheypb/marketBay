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
    private var listener: ListenerRegistration? = nil
    
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
    
    func insertListing(newData : MiniListing) {
        user?.listings.append(newData)
        do {
            try self.db
                .collection(FirebaseConstants.COLLECTION_USERS.rawValue)
                .document(user!.id!)
                .setData(from: user)
        } catch let err as NSError {
            print(#function, "ERROR: \(err)")
        }
    }
    
    func getUser(email: String){
        listener = self.db
            .collection(FirebaseConstants.COLLECTION_USERS.rawValue)
            .document(email)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print(#function, "FAILED TO RETRIEVE DATA: \(error)")
                    return
                }
                guard let data = document.data() else {
                    print(#function, "DOCUMENT IS EMPTY")
                    return
                }
                do {
                    self.user = try document.data(as: User.self)
                } catch let err as NSError {
                    print(#function, "UNABLE TO CONVERT DATA: \(err)")
                }
            }
    }
    
    func removeListener() {
        listener?.remove()
    }
}
