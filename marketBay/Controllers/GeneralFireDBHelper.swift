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
    
    // Singleton instance
    private static var shared: GeneralFireDBHelper?
       
       static func getInstance() -> GeneralFireDBHelper {
           if shared == nil {
               shared = GeneralFireDBHelper()
           }
           return shared!
       }
    
    private init() {}
    
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
                self.categoriesCollectionRef.addDocument(data: ["name": category.rawValue, "systemImageName": category.systemImageName]) { error in
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
