//
//  FavoritesView.swift
//  marketBay
//  For View and Edit Favorite list
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI

struct FavoritesView: View {
    // Toggle between "All Items" and "Collections"
    @State private var showAllItems = true
    @State private var showCreateCollection = false
    @State private var showAddToList = false
    
    @State private var newCollectionName = ""
    @State private var loggedInUser: User?
    @State private var selectedCollections: [Collection] = []
    @State private var selectedListing: Listing?
    
    @EnvironmentObject var dataAccess: DataAccess
    
    var body: some View {
        NavigationStack {
            VStack {
                // Menu Bar
                MenuTemplate().environmentObject(dataAccess)
                // Title
                Spacer()
                Text("Favorites")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Buttons: All Items and Collections
                HStack {
                    Button(action: {
                        showAllItems = true
                    }) {
                        Text("All Items")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .foregroundColor(showAllItems ? .white : .blue)
                            .background(showAllItems ? Color.blue : Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        showAllItems = false
                    }) {
                        Text("Collections")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .foregroundColor(!showAllItems ? .white : .blue)
                            .background(!showAllItems ? Color.blue : Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                }
                .padding()
                
                // Favorites List or Collections Grid
                if showAllItems {
                    // List of all items
                    FavoritesListView(showAddToList: $showAddToList, selectedListing: $selectedListing).environmentObject(dataAccess)
                } else {
                    // Grid of collections
                    CollectionsGridView()
                }
                
                // Create Collection Button
                Button(action: {
                    showCreateCollection = true
                }) {
                    Text("Create a Collection")
                        .padding()
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showCreateCollection) {
                    CreateCollectionView(isPresented: $showCreateCollection, collectionName: $newCollectionName).environmentObject(dataAccess)
                }
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showAddToList) {
                AddToListView(selectedCollections: $selectedCollections, selectedListing: $selectedListing, showAddToList: $showAddToList).environmentObject(dataAccess)
            }
            .onAppear{
                // Fetch user-specific collections when the view appears
                if let user = dataAccess.loggedInUser {
                    dataAccess.getLoggedInUserCollections(for: user)
                }
                
                // Fetch favorite listings for the logged-in user when the view appears
                if let user = dataAccess.loggedInUser {
                    dataAccess.loggedInUserFavorites = dataAccess.getLoggedInUserFavorites(for: user)
                }
            }
        }
    }
}

struct FavoritesListView: View {
    @EnvironmentObject var dataAccess: DataAccess
    @Binding var showAddToList: Bool
    @Binding var selectedListing: Listing?
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(dataAccess.loggedInUserFavorites) { listing in
                    FavoriteListItemView(listing: listing, showAddToList: $showAddToList, selectedListing: $selectedListing).environmentObject(dataAccess)
                        .padding(.vertical, 8)
                }
            }
            .padding()
        }
    }
}

struct FavoriteListItemView: View {
    let listing: Listing
    @Binding var showAddToList: Bool
    @Binding var selectedListing: Listing?
    
    @EnvironmentObject var dataAccess: DataAccess
    
    var body: some View {
        HStack {
            // Image, Title, Price
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(listing.title) // Display actual listing title
                Text("$\(String(format: "%.2f", listing.price))") // Display actual price
            }
            Spacer()
            
            // Add and Remove Icon Buttons
            Button(action: {
                // Action to add item to collection
                selectedListing = listing
                showAddToList = true
            }) {
                Image(systemName: "plus.circle")
            }
            Button(action: {
                // Remove item from favorites
                dataAccess.toggleFavorite(for: listing) { success in
                    if success {
                        // Successfully removed from favorites
                        print("\(listing)removed from favorites")
                    } else {
                        // Failed to remove from favorites
                        print("Fail to remove listing from favorites")
                    }
                }
            }) {
                Image(systemName: "minus.circle")
            }
        }
    }
}

struct AddToListView: View {
    @EnvironmentObject var dataAccess: DataAccess
    @Binding var selectedCollections: [Collection]
    @Binding var selectedListing: Listing?
    @Binding var showAddToList: Bool
    @State private var selectedCollectionIndex = 0
    
    var body: some View {
        VStack {
            Picker("Select Collection", selection: $selectedCollectionIndex) {
                ForEach(dataAccess.loggedInUserCollections.indices, id: \.self) { index in
                    Text(dataAccess.loggedInUserCollections[index].name)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Button("Add to Collection") {
                if let listing = selectedListing {
                    if selectedCollectionIndex < dataAccess.loggedInUserCollections.count {
                        let selectedCollection = dataAccess.loggedInUserCollections[selectedCollectionIndex]
                        dataAccess.addToCollection(listing: listing, collection: selectedCollection)
                        showAddToList = false
                    } else {
                        // Handle invalid index scenario here
                        print("Invalid collection index")
                    }
                }
            }
            .padding()
            .disabled(selectedListing == nil)
        }
        .padding()
    }
}

struct CollectionsGridView: View {
    @EnvironmentObject var dataAccess: DataAccess
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(dataAccess.loggedInUserCollections) { index in
                    // Example of a grid item in the collections grid view
                    CollectionGridViewItem(collection: index)
                }
            }
            .padding()
        }
    }
}

struct CollectionGridViewItem: View {
    @State private var isShowingListings = false
    let collection: Collection
    
    var body: some View {
        VStack {
            // Collection Image
            Image(systemName: "folder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            // Collection Title
            Text(collection.name)
        }
        .onTapGesture {
            isShowingListings.toggle()
        }
        .sheet(isPresented: $isShowingListings) {
            // Sheet displaying listings included in this collection
            CollectionListingsView(collection: collection)
        }
    }
}

struct CollectionListingsView: View {
    let collection: Collection
    @EnvironmentObject var dataAccess: DataAccess

    var body: some View {
        NavigationView {
            List {
//                ForEach(collection.listings, id: \.id) { listing in
//                    NavigationLink(destination: ListingView(listing: listing)) {
//                        Text(listing.title)
//                    }
//                }
//                .onDelete(perform: deleteListing)
            }
            .navigationBarTitle(Text("Listings in \(collection.name)"))
        }
    }
    
    func deleteListing(at offsets: IndexSet) {
        for index in offsets {
            let listing = collection.listings[index]
//            dataAccess.removeFromCollection(listing: listing, collection: collection)
        }
    }
}


struct CreateCollectionView: View {
    @Binding var isPresented: Bool
    @Binding var collectionName: String
    
    @EnvironmentObject var dataAccess: DataAccess
    
    var body: some View {
        NavigationView {
            VStack {
                // Navigation Bar
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                    }
                    
                    Spacer()
                    
                    Text("New Collection")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        // Action to create collection
                        dataAccess.createCollection(name: collectionName)
                        dataAccess.saveLoggedInUserCollections(for: dataAccess.loggedInUser!)
                        isPresented = false
                    }) {
                        Text("Create")
                    }
                }
                .padding()
                
                // Collection Name TextField
                TextField("Enter Collection Name", text: $collectionName)
                    .padding()
                
                Spacer()
            }
        }
    }
}


#Preview {
    FavoritesView()
}

