//
//  GeneralFireDBHelper.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class GeneralFireDBHelper: ObservableObject {
    @Published var categories: [Category] = []
    
    var listener: ListenerRegistration? = nil

    
    private var categoriesCollectionRef: CollectionReference {
        return db.collection("Categories")
    }
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let authFireDBHelper = AuthenticationFireDBHelper.getInstance()

    
    // Singleton instance
    private static var shared: GeneralFireDBHelper?
       
       static func getInstance() -> GeneralFireDBHelper {
           if shared == nil {
               shared = GeneralFireDBHelper()
           }
           return shared!
       }
    
    private init() {}
    
    // Function to add a listing to a collection
    func addListingToCollection(_ listing: Listing, collection: Collection, completion: @escaping (Error?) -> Void) {
        guard let user = authFireDBHelper.user else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            completion(error)
            return
        }
        
        guard let userID = user.id else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is nil"])
            completion(error)
            return
        }
        
        let collectionID = collection.id.uuidString // Convert UUID to String
        
        let listingsRef = db.collection("Users").document(userID).collection("collections").document(collectionID).collection("listings")
        
        // Add the listing to the collection
        guard let listingID = listing.id else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "Listing ID is nil"])
            completion(error)
            return
        }
        
        let data = ["id": listingID, "title": listing.title, "price": listing.price] as [String : Any] // Add more fields as needed
        listingsRef.addDocument(data: data) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    // Function to remove a listing from a collection
    func removeListingFromCollection(_ listing: Listing, collection: Collection, completion: @escaping (Error?) -> Void) {
        guard let user = authFireDBHelper.user else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            completion(error)
            return
        }
        
        guard let userID = user.id else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is nil"])
            completion(error)
            return
        }
        
        let collectionID = collection.id.uuidString // Convert UUID to String
        
        let listingsRef = db.collection("Users").document(userID).collection("collections").document(collectionID).collection("listings")
        
        // Remove the listing from the collection
        guard let listingID = listing.id else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "Listing ID is nil"])
            completion(error)
            return
        }
        
        listingsRef.whereField("id", isEqualTo: listingID).getDocuments { snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "No documents found"])
                completion(error)
                return
            }
            
            // Delete all documents matching the listing ID (in case of duplicates)
            for document in documents {
                document.reference.delete()
            }
            
            completion(nil)
        }
    }

    
    // Function to add a collection
    func addCollection(name: String, completion: @escaping (Collection?, Error?) -> Void) {
        // Get the current user
        guard let user = authFireDBHelper.user else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            completion(nil, error)
            return
        }
        
        // Unwrap the user ID safely
        guard let userID = user.id else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is nil"])
            completion(nil, error)
            return
        }
        
        // Implement logic to add the collection to Firestore
        let collectionRef = db.collection("Users").document(userID).collection("collections")
        let data = ["name": name] // Add more fields as needed
        collectionRef.addDocument(data: data) { error in
            if let error = error {
                completion(nil, error)
            } else {
                // Collection added successfully, create the Collection object
                let newCollection = Collection(name: name, ownerID: userID)
                completion(newCollection, nil)
            }
        }
    }

    
    // Function to delete a collection
        func deleteCollection(_ collection: Collection, completion: @escaping (Error?) -> Void) {
            // Get the current user
            guard let user = authFireDBHelper.user else {
                let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
                completion(error)
                return
            }
            
            // Unwrap the user ID safely
            guard let userID = user.id else {
                let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is nil"])
                completion(error)
                return
            }
            
            // Implement logic to delete the collection from Firestore
            let collectionRef = db.collection("Users").document(userID).collection("collections")
            let collectionID = collection.id.uuidString // Convert UUID to String
            collectionRef.document(collectionID).delete { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    
    // Function to show all collections for the logged-in user
        func getLoggedInUserCollections(completion: @escaping ([Collection]) -> Void) {
            guard let user = authFireDBHelper.user else {
                completion([])
                return
            }
            let userID = user.id ?? ""
            let collectionsRef = db.collection("Users").document(userID).collection("collections")
            collectionsRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting user's collections: \(error.localizedDescription)")
                    completion([])
                    return
                }
                var collections: [Collection] = []
                if let documents = snapshot?.documents {
                    for document in documents {
                        if let collection = try? document.data(as: Collection.self) {
                            collections.append(collection)
                        }
                    }
                }
                completion(collections)
            }
        }
    
    // Function to show all listings of a specific collection for the logged-in user
        func showListingsOfCollection(collection: Collection, completion: @escaping ([Listing]) -> Void) {
            guard let user = authFireDBHelper.user else {
                completion([])
                return
            }
            let userID = user.id ?? ""
            let collectionID = collection.id.uuidString // Convert UUID to String
            let listingsRef = db.collection("Users").document(userID).collection("collections").document(collectionID).collection("listings")
            listingsRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting listings of collection: \(error.localizedDescription)")
                    completion([])
                    return
                }
                var listings: [Listing] = []
                if let documents = snapshot?.documents {
                    for document in documents {
                        if let listing = try? document.data(as: Listing.self) {
                            listings.append(listing)
                        }
                    }
                }
                completion(listings)
            }
        }
    
    // Get All Favorites listing of a user
    func getLoggedInUserFavorites(completion: @escaping ([Listing]) -> Void) {
        guard let user = authFireDBHelper.user else {
            completion([])
            return
        }

        let userID = user.id ?? ""
        let userFavoritesRef = db.collection("Users").document(userID).collection("favorites")

        userFavoritesRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting user's favorites: \(error.localizedDescription)")
                completion([])
                return
            }

            var favorites: [Listing] = []
            if let documents = snapshot?.documents {
                for document in documents {
                    do {
                        if let listingData = try? document.data(as: Listing.self) {
                            favorites.append(listingData)
                        }
                    }
                }
            }
            completion(favorites)
        }
    }

    
    // Function to add a listing to the user's favorites
    func addToFavorites(_ listing: Listing, completion: @escaping (Error?) -> Void) {
        // Get the current user
        guard let user = authFireDBHelper.user else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            completion(error)
            return
        }
        
        // Unwrap the user ID safely
        guard let userID = user.id else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is nil"])
            completion(error)
            return
        }

        // Unwrap the listing ID safely
        guard let listingID = listing.id else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "Listing ID is nil"])
            completion(error)
            return
        }

        // Reference to the user's favorites collection
        let userFavoritesRef = Firestore.firestore().collection("Users").document(userID).collection("favorites").document(listingID)
        
        // Add the listing to the favorites collection
        userFavoritesRef.setData(["id": listingID, "title": listing.title, "price": listing.price]) { error in
            if let error = error {
                // Error occurred while adding listing to favorites
                completion(error)
            } else {
                // Listing added to favorites successfully
                completion(nil)
            }
        }
    }


    // Function to check if the user has favorited a listing
    func isListingFavorited(_ listing: Listing, completion: @escaping (Bool) -> Void) {
        guard let user = authFireDBHelper.user else {
            completion(false)
            return
        }
        
        // Unwrap the user ID safely
        guard let userID = user.id else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is nil"])
            completion(error as! Bool)
            return
        }

        // Unwrap the listing ID safely
        guard let listingID = listing.id else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "Listing ID is nil"])
            completion(error as! Bool)
            return
        }

        // Reference to the user's favorites collection
        let userFavoritesRef = Firestore.firestore().collection("Users").document(userID).collection("favorites").document(listingID)
        userFavoritesRef.getDocument { document, error in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    // Function to remove a listing from the user's favorites
    func removeFromFavorites(_ listing: Listing, completion: @escaping (Bool) -> Void) {
        guard let user = authFireDBHelper.user else {
            print("Error: No logged-in user found")
            completion(false)
            return
        }
        
        // Unwrap the user ID safely
        guard let userID = user.id else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is nil"])
            completion(error as! Bool)
            return
        }

        // Unwrap the listing ID safely
        guard let listingID = listing.id else {
            let error = NSError(domain: "GeneralFireDBHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "Listing ID is nil"])
            completion(error as! Bool)
            return
        }

        // Reference to the user's favorites collection
        let userFavoritesRef = Firestore.firestore().collection("Users").document(userID).collection("favorites").document(listingID)
        // Delete the document representing the listing from the user's favorites collection
        userFavoritesRef.delete { error in
            if let error = error {
                print("Error removing listing from favorites: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    
    // Fetch category image URLs from Firestore Storage
    func fetchCategoryImageURLs(completion: @escaping ([String: URL]) -> Void) {
        var imageURLs: [String: URL] = [:]
        
        categoriesCollectionRef.getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error)")
                completion(imageURLs)
                return
            }
            
            for document in documents {
                let data = document.data()
                guard let systemImageName = data["systemImageName"] as? String else {
                    continue
                }
                
                // Assuming images are stored in the "General" folder
                let imageRef = self.storage.reference().child("General/\(systemImageName).png")
                
                imageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error downloading image: \(error)")
                        return
                    }
                    
                    if let url = url {
                        imageURLs[systemImageName] = url
                    }
                    
                    // Check if this is the last image to download
                    if imageURLs.count == documents.count {
                        completion(imageURLs)
                    }
                }
            }
        }
    }
    
    // Create Categories collection if it does not exist
    func createCategoriesCollectionIfNeeded() {
        categoriesCollectionRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot, snapshot.isEmpty else {
                print("Categories collection already exists or failed to check for existence:", error ?? "")
                return
            }
            
            // Create the collection with predefined categories
            for category in Category.allCases {
                self.categoriesCollectionRef.addDocument(data: ["name": category.rawValue, "systemImageName": category.systemImageName, "imageURL": category.imageURL]) { error in
                    if let error = error {
                        print("Error creating category document:", error)
                    } else {
                        print("Category document created successfully for \(category.rawValue)")
                    }
                }
            }
        }
    }
}
