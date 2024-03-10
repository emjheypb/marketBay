//
//  User.swift
//  marketBay
//
//  Created by Cheung K on 12/2/2024.
//

import Foundation

class User: Codable {
//    @DocumentID var id: String? = UUID().uuidString
    let id: Int
    var name: String
    var email: String // TODO: EMAIL to ID?
    var password: String // TODO: REMOVE
    var phoneNumber: String
    var listings: [Listing] //for seller to manage listings TODO: CHANGE TO [MiniListing] User_Listings - FirebaseConstants.swift
    var favorites: [Listing] //for favorites list TODO: CHANGE TO [MiniListing] User_Favorites - FirebaseConstants.swift
    var collections: [Collection] // Add collections property TODO: CHANGE TO User_Collections - FirebaseConstants.swift
    // TODO: ADD User_Chatrooms - FirebaseConstants.swift


    init(id: Int, name: String, email: String, password: String, phoneNumber: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.listings = []
        self.favorites = []
        self.collections = []
        
        // Load user's data from UserDefaults
        saveUserData()
        loadUserData()
    }

    //Function to update user details
    func updateProfile(_ name: String, _ password: String, _ phoneNumber: String){
        self.name = name
        self.password = password
        self.phoneNumber = phoneNumber
        saveUserData()
    }
    
    // Function to add a new listing
    func addListing(_ listing: Listing) {
        listings.append(listing)
        saveUserData()
    }
    
    // Function to remove a listing
    func removeListing(_ listing: Listing) {
        if let index = listings.firstIndex(where: { $0.id == listing.id }) {
            listings.remove(at: index)
            saveUserData()
        }
    }

    // Function to add a listing to favorites
    func addToFavorites(_ listing: Listing) {
        favorites.append(listing)
        saveUserData()
    }
    
    // Function to remove a listing from favorites
   func removeFromFavorites(_ listing: Listing) {
       if let index = favorites.firstIndex(where: { $0.id == listing.id }) {
           favorites.remove(at: index)
           saveUserData()
       }
   }
    
    // Function to manage collections
    func addCollection(_ collection: Collection) {
           collections.append(collection)
       }
       
    func removeCollection(at index: Int) {
           collections.remove(at: index)
       }
    
    // Function to save user data to UserDefaults
     func saveUserData() {
        var allUsersData = UserDefaults.standard.array(forKey: "allUsersData") as? [[String: Any]] ?? []

           let userData: [String: Any] = [
               "id": id,
               "name": name,
               "email": email,
               "password": password,
               "phoneNumber": phoneNumber,
               "listings": listings.map { $0.id }, // Save only listing IDs
               "favorites": favorites.map { $0.id } // Save only favorite listing IDs
           ]

        // Remove existing user data with the same ID, if any
        allUsersData.removeAll { ($0["id"] as? Int) == id }
        
        // Append updated user data
        allUsersData.append(userData)
        
        // Save all users' data
        UserDefaults.standard.set(allUsersData, forKey: "allUsersData")
    }

    // Function to load user data from UserDefaults
     func loadUserData() {
        guard let allUsersData = UserDefaults.standard.array(forKey: "allUsersData") as? [[String: Any]] else {
                   return
        }
        
        // Find user data matching current user's ID
        if let userData = allUsersData.first(where: { ($0["id"] as? Int) == id }) {
            // Initialize user with loaded data
            self.name = userData["name"] as? String ?? ""
            self.email = userData["email"] as? String ?? ""
            self.password = userData["password"] as? String ?? ""
            self.phoneNumber = userData["phoneNumber"] as? String ?? ""
            
            // Function to retrieve listings of the user
            if let listingsIDs = userData["listings"] as? [Int] {
                // Load listings from IDs
                self.listings = listingsIDs.compactMap { id in
                    // Fetch listing from data source using ID
                    //  let listing = Listing(id: id, title: "Listing Title", description: "Listing Description", price: 0.0, sellerID: 1)
                    //        return listing
                    return nil // Placeholder for demo, replace with actual logic
                }
            }
            
            // Function to retrieve favorites of the user
            if let favoritesIDs = userData["favorites"] as? [Int] {
                // Load favorites from IDs
                self.favorites = favoritesIDs.compactMap { id in
                    // Fetch listing from data source using ID
                    // let listing = Listing(id: id, title: "Listing Title", description: "Listing Description", price: 0.0, sellerID: 1)
                    // return listing
                    return nil // Placeholder for demo, replace with actual logic
                }
            }
        }
    }
}
