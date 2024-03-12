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
