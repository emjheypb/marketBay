//
//  DataAccess.swift
//  marketBay
//
//  Created by EmJhey PB on 2/13/24.
//

import Foundation

final class DataAccess: ObservableObject {
    @Published var loggedInUser: User? = nil
    @Published var loggedInUserPostings: [Listing] = []
    @Published var loggedInUserFavorites: [Listing] = []
    @Published var loggedInUserCollections: [Collection] = []
    @Published var rememberUser: User? = nil
    
    let userFavoritesKeyPrefix = "LoggedInUserFavorites_"
    let userCollectionsKeyPrefix = "LoggedInUserCollections_"
    
    
    var listingsDictionary: [Int: Listing] = [:] // Mapping of listing ID to Listing object
    
    // MARK: User Management
    func login(user: User) {
        do {
            let encodedData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsEnum.loggedInUser.rawValue)
            loggedInUser = user
            //            loggedInUserPostings = getPosts(idFilter: user.id).sorted(by: { $0.id > $1.id })
            loggedInUserFavorites = getLoggedInUserFavorites(for: user) // Retrieve favorites for the logged-in user
            loggedInUserCollections = getLoggedInUserCollections(for: user) // Retrieve collections for the logged-in user
            // Debug print to check if user is logged in and data is retrieved properly
            print("User logged in: \(user)")
            print("User's postings: \(loggedInUserPostings)")
        } catch {
            print("Failed to encode User to Data")
        }
    }
    
    func getLoggedInUser() -> User? {
        if let savedData = UserDefaults.standard.object(forKey: UserDefaultsEnum.loggedInUser.rawValue) as? Data {
            do{
                let currentUser = try JSONDecoder().decode(User.self, from: savedData)
                //                loggedInUserPostings = getPosts(idFilter: currentUser.id).sorted(by: { $0.id > $1.id })
                return currentUser
            } catch {
                print("Failed to convert Data to User")
            }
        }
        
        return nil
    }
    
    // Retrieve loggedInUserFavorites for a specific user
    func getLoggedInUserFavorites(for user: User) -> [Listing] {
        if let savedData = UserDefaults.standard.object(forKey: userFavoritesKeyPrefix + "\(user.id)") as? Data {
            do {
                let favorites = try JSONDecoder().decode([Listing].self, from: savedData)
                return favorites
            } catch {
                print("Failed to decode loggedInUserFavorites for user \(user.id)")
            }
        }
        return []
    }
    
    // Save loggedInUserFavorites for a specific user
    func saveLoggedInUserFavorites(for user: User) {
        do {
            let encodedData = try JSONEncoder().encode(loggedInUserFavorites)
            UserDefaults.standard.set(encodedData, forKey: userFavoritesKeyPrefix + "\(user.id)")
        } catch {
            print("Failed to encode loggedInUserFavorites to Data")
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsEnum.loggedInUser.rawValue)
        loggedInUser = nil
        loggedInUserPostings = []
    }
    
    // MARK: Post/Listing Management
    func getPosts(idFilter: Int?) -> [Listing] {
        if let savedData = UserDefaults.standard.object(forKey: UserDefaultsEnum.posts.rawValue) as? Data {
            do{
                let currentListings = try JSONDecoder().decode([Listing].self, from: savedData)
                //                return idFilter == nil ? currentListings : currentListings.filter{$0.seller.id == idFilter}
            } catch {
                print("Failed to convert Data to Listing")
            }
            
        }
        
        return []
    }
    
    func savePosts(post: Listing, isUpdate: Bool = false) {
        do {
            var currentPost = post
            var savedPosts = getPosts(idFilter: nil)
            
            if(isUpdate) {
                savedPosts.remove(at: savedPosts.firstIndex(where: { $0.id == post.id })!)
            } else {
                //                currentPost.id = savedPosts.count + 1
            }
            
            savedPosts.append(currentPost)
            let encodedData = try JSONEncoder().encode(savedPosts)
            
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsEnum.posts.rawValue)
            //            loggedInUserPostings = getPosts(idFilter: currentPost.seller.id).sorted(by: { $0.id > $1.id })
        } catch {
            print("Failed to encode Listings to Data")
        }
    }
    
    // MARK: Toggle Favorite Listing
    func toggleFavorite(for listing: Listing, completion: @escaping (Bool) -> Void) {
        //        if let currentUser = self.loggedInUser {
        //            if currentUser.favorites.contains(where: { $0.id == listing.id }) {
        //                // Remove listing from favorites
        //                currentUser.removeFromFavorites(listing)
        //                decrementFavoriteCount(for: listing)
        //                completion(false)
        //            } else {
        //                // Add listing to favorites
        //                currentUser.addToFavorites(listing)
        //                incrementFavoriteCount(for: listing)
        //                completion(true)
        //            }
        //            // Update loggedInUserFavorites
        //            loggedInUserFavorites = currentUser.favorites
        //            // Save loggedInUserFavorites for the logged-in user
        //            saveLoggedInUserFavorites(for: currentUser)
        //            // Save user data immediately after toggling favorite status
        //            currentUser.saveUserData()
        //            saveUser(currentUser)
        //            // DEBUG
        //            print("User data saved after toggling favorites: \(currentUser)")
        //            print("Favorite listings stored: \(currentUser.favorites)") // Add this line
        //               } else {
        //                   print("Error: No logged-in user found")
        //               }
    }
    
    func incrementFavoriteCount(for listing: Listing) {
        //           guard var mutableListing = listingsDictionary[listing.id] else { return }
        //           mutableListing.favoriteCount += 1
        //           listingsDictionary[listing.id] = mutableListing
    }
    
    func decrementFavoriteCount(for listing: Listing) {
        //           guard var mutableListing = listingsDictionary[listing.id] else { return }
        //           mutableListing.favoriteCount -= 1
        //           listingsDictionary[listing.id] = mutableListing
    }
    
    // Function to create a new collection
    func createCollection(name: String) {
        //        guard let currentUser = self.loggedInUser else {
        //            print("Error: No logged-in user found")
        //            return
        //        }
        //        
        //        // Create a new collection
        //        let collection = Collection(id: UUID(), name: name, listings: [], ownerID: currentUser.id)
        //        
        //        // Add the collection to the user's collections
        //        currentUser.addCollection(collection)
        //        
        //        // Save user data immediately after creating the collection
        //        currentUser.saveUserData()
        //        
        //        // Update loggedInUserCollections
        //        loggedInUserCollections = currentUser.collections
    }
    
    // Function to add a listing to a collection
    func addToCollection(listing: Listing, collection: Collection) {
        if let index = loggedInUserCollections.firstIndex(where: { $0.id == collection.id }) {
            //            loggedInUserCollections[index].listings.append(listing)
            // Save the updated collections to UserDefaults
            saveLoggedInUserCollections(for: loggedInUser!)
        }
    }
    
    // Function to remove a listing from a collection
    func removeFromCollection(listing: Listing, collection: Collection) {
        if let index = loggedInUserCollections.firstIndex(where: { $0.id == collection.id }) {
            //                loggedInUserCollections[index].listings.removeAll(where: { $0.id == listing.id })
            saveLoggedInUserCollections(for: loggedInUser!)
        }
    }
    
    // Retrieve loggedInUserCollections for a specific user
    func getLoggedInUserCollections(for user: User) -> [Collection] {
        if let savedData = UserDefaults.standard.object(forKey: "\(userCollectionsKeyPrefix)\(user.id)") as? Data {
            do {
                let collections = try JSONDecoder().decode([Collection].self, from: savedData)
                return collections
            } catch {
                print("Failed to decode loggedInUserCollections for user \(user.id)")
            }
        }
        return []
    }
    
    // Function to save loggedInUserCollections for a specific user
    func saveLoggedInUserCollections(for user: User) {
        do {
            let encodedData = try JSONEncoder().encode(loggedInUserCollections)
            UserDefaults.standard.set(encodedData, forKey: "\(userCollectionsKeyPrefix)\(user.id)")
        } catch {
            print("Failed to encode loggedInUserCollections to Data")
        }
    }
    
    
    // MARK: Save User
    func saveUser(_ user: User) {
        //           do {
        //               let encodedData = try JSONEncoder().encode(user)
        //               UserDefaults.standard.set(encodedData, forKey: UserDefaultsEnum.loggedInUser.rawValue)
        //               loggedInUser = user
        //               loggedInUserFavorites = user.favorites // Update loggedInUserFavorites
        //               print("User data saved: \(user)")
        //                  } catch {
        //                      print("Failed to encode User to Data")
        //                  }
    }
    
    // MARK: Collection Management
    func addListingtoCollection(_ listing: Listing, toCollection collection: Collection) {
        if let index = loggedInUserCollections.firstIndex(where: { $0.id == collection.id }) {
            //                loggedInUserCollections[index].listings.append(listing)
        }
    }
    
    func removeListingtoCollection(_ listing: Listing, fromCollection collection: Collection) {
        if let index = loggedInUserCollections.firstIndex(where: { $0.id == collection.id }) {
            //                loggedInUserCollections[index].listings.removeAll(where: { $0.id == listing.id })
        }
    }
    
    func rememberUser(user: User) {
        do {
            let encodedData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsEnum.rememberUser.rawValue)
            rememberUser = user
        }
        catch {
            print("Failed to convert Data to User")
        }
    }
    
    func getRememberUser() -> User? {
        if let savedData = UserDefaults.standard.object(forKey: UserDefaultsEnum.rememberUser.rawValue) as? Data {
            do{
                let currentUser = try JSONDecoder().decode(User.self, from: savedData)
                return currentUser
            } catch {
                print("Failed to convert Data to User")
            }
        }
        return nil
    }
    
    func forgetUser() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsEnum.rememberUser.rawValue)
        rememberUser = nil
    }
}
