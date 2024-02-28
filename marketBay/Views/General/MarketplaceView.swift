//
//  MarketplaceView.swift
//  marketBay
//  Home Screen of App for browsing listings
//  Have access points to DashboardView and ListingView,
//  Created by Cheung K on 12/2/2024.
//

import SwiftUI

struct MarketplaceView: View {
    @State private var selectedCategory: Category = .all
    @EnvironmentObject var dataAccess: DataAccess
    @State private var listings: [Listing] = []   // Property to hold the listings
    
    let categories: [Category] = [.all, .auto, .furniture, .electronics, .womensClothing, .mensClothing, .toys, .homeAndGarden]

    var body: some View {
        NavigationStack {
            VStack {
                // Menu Bar
                MenuTemplate().environmentObject(dataAccess)
                
                // Horizontal Category Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                VStack {
                                    Image(systemName: "circle.fill") // Placeholder image
                                        .foregroundColor(category == selectedCategory ? .blue : .gray)
                                    Text(category.rawValue) // Access the rawValue
                                        .font(.caption)
                                        .foregroundColor(category == selectedCategory ? .blue : .black)
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                }
                .padding(.vertical)
                
                // Grid-like Display of Items
               ScrollView {
                   LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                       ForEach(listings.filter { $0.category == selectedCategory || selectedCategory == .all }) { listing in
                               ItemView(listing: listing)
                           }
                   }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .onAppear() {
            loadDummyData()
            loadListings()
        }
    }
    
    func loadListings() {
           listings = dataAccess.getPosts(idFilter: nil).filter { $0.status == .available }
           dataAccess.loggedInUser = dataAccess.getLoggedInUser()
       }
    
    func loadDummyData() {
        
        // Remove existing posts from UserDefaults
         //UserDefaults.standard.removeObject(forKey: UserDefaultsEnum.posts.rawValue)
        
        // DEBUG:
        print("Loading dummy data...")

        let posts = dataAccess.getPosts(idFilter: nil)
        // DEBUG:
        print("Retrieved listings from UserDefaults: \(posts)")

        if(posts.isEmpty) {
            // MARK: Dummy Users
            let users = [
                User(id: 0, name: "MJ", email: "mb@gmail.com", password: "mbmbmb", phoneNumber: "4371234123"),
                User(id: 1, name: "Dayeeta", email: "dg@gmail.com", password: "dgdgdg", phoneNumber: "4371233456"),
                User(id: 2, name: "Gordon", email: "kc@gmail.com", password: "kckckc", phoneNumber: "4371233789"),
            ]
            
            // MARK: Dummy Seller Posts
            let listings = [
                Listing(id: 1, title: "Laptop", description: "Brand new laptop for sale.", category: .electronics, price: 99.99, seller: users[0], email: users[0].email, phoneNumber: users[0].phoneNumber, status: .available, favoriteCount: 0),
                Listing(id: 2, title: "Garden Chair", description: "Comfortable garden chair perfect for relaxing outdoors.", category: .homeAndGarden, price: 49.99, seller: users[0], email: users[0].email, phoneNumber: users[0].phoneNumber, status: .available, favoriteCount: 0),
                Listing(id: 3, title: "Men's Shirt", description: "Stylish men's shirt available in various sizes and colors.", category: .mensClothing, price: 29.99, seller: users[0], email: users[0].email, phoneNumber: users[0].phoneNumber, status: .available, favoriteCount: 0),
                Listing(id: 4, title: "Toy Car", description: "Fun toy car for kids to play with.", category: .toys, price: 19.99, seller: users[0], email: users[0].email, phoneNumber: users[0].phoneNumber, status: .available, favoriteCount: 0),
                Listing(id: 5, title: "Smartphone", description: "High-performance smartphone with advanced features.", category: .electronics, price: 149.99, seller: users[1], email: users[1].email, phoneNumber: users[1].phoneNumber, status: .available, favoriteCount: 0),
                Listing(id: 6, title: "Sofa Set", description: "Elegant sofa set perfect for your living room.", category: .furniture, price: 199.99, seller: users[1], email: users[1].email, phoneNumber: users[1].phoneNumber, status: .available, favoriteCount: 0),
                Listing(id: 7, title: "Outdoor Table", description: "Durable outdoor table suitable for your garden or patio.", category: .homeAndGarden, price: 79.99, seller: users[1], email: users[1].email, phoneNumber: users[1].phoneNumber, status: .available, favoriteCount: 0),
                Listing(id: 8, title: "Camera", description: "Professional-grade camera for capturing stunning photos and videos.", category: .electronics, price: 249.99, seller: users[1], email: users[1].email, phoneNumber: users[1].phoneNumber, status: .available, favoriteCount: 0),
                Listing(id: 9, title: "Action Figure", description: "Collectible action figure for toy enthusiasts.", category: .toys, price: 9.99, seller: users[2], email: users[2].email, phoneNumber: users[2].phoneNumber, status: .available, favoriteCount: 0),
                Listing(id: 10, title: "Women's Dress", description: "Elegant dress for various occasions, available in different sizes.", category: .womensClothing, price: 39.99, seller: users[2], email: users[2].email, phoneNumber: users[2].phoneNumber, status: .available, favoriteCount: 0),
               Listing(id: 11, title: "Unlock! A Noside Story", description: "Secret Adventures: Part 1", category: .toys, price: 25.0, seller: users[0], email: users[0].email, phoneNumber: users[0].phoneNumber, status: .available, favoriteCount: 0),
               Listing(id: 12, title: "Unlock! Tombstone Express", description: "Secret Adventures: Part 2", category: .toys, price: 25.0, seller: users[1], email: users[1].email, phoneNumber: users[1].phoneNumber, status: .available, favoriteCount: 0),
               Listing(id: 13, title: "Unlock! The Adventures of Oz", description: "Secret Adventures: Part 3", category: .toys, price: 25.0, seller: users[2], email: users[2].email, phoneNumber: users[2].phoneNumber, status: .available, favoriteCount: 0),
                   ]
            
            // Assign listings to the listings array
            self.listings = listings.filter { $0.status == .available }

            for listing in listings {
                       dataAccess.savePosts(post: listing)
                   }
            
            for user in users {
                        for listing in listings {
                            user.addListing(listing)
                        }
                    }
        }else {
            // If there are existing posts retrieved from UserDefaults, assign them to self.listings
            self.listings = posts.filter { $0.status == .available }
        }
    }

}

struct ItemView: View {
    let listing: Listing // Add a property to hold the listing information

    var body: some View {
        NavigationLink(destination: ListingView(listing: listing)) {
            VStack {
                // Image and Title
                Image(systemName: "photo") // Placeholder image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                Text(listing.title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Price
                Text("$\(String(format:"%.2f", listing.price))")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(.vertical, 5)
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}


#Preview {
    let dataAccess = DataAccess() // Create a mock DataAccess object
    dataAccess.loggedInUser = User(id: 1, name: "John Doe", email: "john@example.com", password: "password", phoneNumber: "123456789")

    return MarketplaceView().environmentObject(dataAccess)
}
