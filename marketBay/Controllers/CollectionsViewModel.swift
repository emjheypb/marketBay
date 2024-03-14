//
//  CollectionsViewModel.swift
//  marketBay
//
//  Created by Cheung K on 13/3/2024.
//

import Foundation
import FirebaseFirestore

class CollectionsViewModel: ObservableObject {
    @Published var userCollections: [Collection] = []
    private let generalFireDBHelper: GeneralFireDBHelper

    init(generalFireDBHelper: GeneralFireDBHelper) {
        self.generalFireDBHelper = generalFireDBHelper
        fetchUserCollections()
    }

    func fetchUserCollections() {
        generalFireDBHelper.getLoggedInUserCollections { collections in
            DispatchQueue.main.async {
                self.userCollections = collections
            }
        }
    }

    func addCollection(_ name: String) {
        generalFireDBHelper.addCollection(name: name) { [weak self] collection, error in
            if let error = error {
                print("Error adding collection: \(error.localizedDescription)")
                // Handle error, perhaps show an alert
            } else if let collection = collection {
                DispatchQueue.main.async {
                    // Update userCollections with the new collection
                    self?.userCollections.append(collection)
                }
            }
        }
    }
}
