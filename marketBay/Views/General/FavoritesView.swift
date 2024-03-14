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
    @State private var favorites: [Listing] = []
    @State private var collections: [Collection] = []
    @State private var newCollectionName = ""
    @State private var selectedCollections: [Collection] = []
    @State private var selectedListing: Listing?
    
    @EnvironmentObject var authFireDBHelper: AuthenticationFireDBHelper
    @EnvironmentObject var generalFireDBHelper: GeneralFireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    
    var body: some View {
        NavigationStack {
            VStack {
                // Menu Bar
                //MenuTemplate().environmentObject(fireAuthHelper)
                // Title
                Spacer()
                Text("Favorites")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Buttons: All Items and Collections
//                HStack {
//                    Button(action: {
//                        showAllItems = true
//                    }) {
//                        Text("Items")
//                            .padding(.horizontal, 20)
//                            .padding(.vertical, 10)
//                            .foregroundColor(showAllItems ? .white : .blue)
//                            .background(showAllItems ? Color.blue : Color.white)
//                            .cornerRadius(20)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 20)
//                                    .stroke(Color.blue, lineWidth: 1)
//                            )
//                    }
//                    
//                    Button(action: {
//                        showAllItems = false
//                    }) {
//                        Text("Collections")
//                            .padding(.horizontal, 20)
//                            .padding(.vertical, 10)
//                            .foregroundColor(!showAllItems ? .white : .blue)
//                            .background(!showAllItems ? Color.blue : Color.white)
//                            .cornerRadius(20)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 20)
//                                    .stroke(Color.blue, lineWidth: 1)
//                            )
//                    }
//                }
//                .padding()
                
                // Favorites List or Collections Grid
//                if showAllItems {
                    // List of all items
                    FavoritesListView(showAddToList: $showAddToList, selectedListing: $selectedListing).environmentObject(authFireDBHelper)
                        .environmentObject(generalFireDBHelper)
                        .environmentObject(fireAuthHelper)
//                } else {
                    // Grid of collections
//                    CollectionsGridView().environmentObject(authFireDBHelper)
//                        .environmentObject(generalFireDBHelper)
//                        .environmentObject(fireAuthHelper)
//                }
                
                // Create Collection Button
//                Button(action: {
//                    showCreateCollection = true
//                }) {
//                    Text("Create a Collection")
//                        .padding()
//                        .foregroundColor(.blue)
//                }
//                .sheet(isPresented: $showCreateCollection) {
//                    CreateCollectionView(isPresented: $showCreateCollection, collectionName: $newCollectionName)
//                }
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showAddToList) {
//                AddToListView(selectedCollections: $selectedCollections, selectedListing: $selectedListing, showAddToList: $showAddToList)
            }
            .onAppear{
                fireAuthHelper.listenToAuthState()

                if let currUser = fireAuthHelper.user {
                    authFireDBHelper.getUser(email: currUser.email!)
                    // Fetch user-specific collections when the view appears
//                    generalFireDBHelper.getLoggedInUserCollections{ collections in
//                        self.collections = collections
//                    }
                    //
                    // Fetch favorite listings for the logged-in user when the view appears
                    generalFireDBHelper.getLoggedInUserFavorites { favorites in
                        self.favorites = favorites
                    }
                    generalFireDBHelper.listenToUserFavorites()

                }
            }
        }
    }
}


struct FavoritesListView: View {
    @Binding var showAddToList: Bool
    @Binding var selectedListing: Listing?
    @State private var favorites: [Listing] = []

    @EnvironmentObject var authFireDBHelper: AuthenticationFireDBHelper
    @EnvironmentObject var generalFireDBHelper: GeneralFireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper

    var body: some View {
        ScrollView {
            VStack {
                ForEach(favorites, id: \.id) { listing in
                    FavoriteListItemView(listing: listing, showAddToList: $showAddToList, selectedListing: $selectedListing)
                        .padding(.vertical, 8)
                }
            }
            .padding()
        }
        .onReceive(generalFireDBHelper.favoritesDidChange) { favorites in
                    // Update the @State variable to trigger view update
                    self.favorites = favorites
                }
        .onAppear{
            if let currUser = fireAuthHelper.user {
                authFireDBHelper.getUser(email: currUser.email!)
                // Fetch favorite listings for the logged-in user when the view appears
                generalFireDBHelper.getLoggedInUserFavorites { favorites in
                    self.favorites = favorites
                }
            }
        }
    }
}


struct FavoriteListItemView: View {
    let listing: Listing
    @Binding var showAddToList: Bool
    @Binding var selectedListing: Listing?
    
    @EnvironmentObject var authFireDBHelper: AuthenticationFireDBHelper
    @EnvironmentObject var sellingFireDBHelper: SellingFireDBHelper
    @EnvironmentObject var generalFireDBHelper: GeneralFireDBHelper
    
    var body: some View {
        HStack {
            // Image, Title, Price
            AsyncImage(url: URL(string: listing.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading) {
                Text(listing.title) // Display actual listing title
                Text("$\(String(format: "%.2f", listing.price))") // Display actual price
            }
            Spacer()
            
            // Add and Remove Icon Buttons
//            Button(action: {
//                // Action to add item to collection
//                selectedListing = listing
//                showAddToList = true
//            }) {
//                Image(systemName: "plus.circle")
//            }
            Button(action: {
                generalFireDBHelper.removeFromFavorites(listing) { success in
                        if success {
                            // Successfully removed from favorites
                            print("\(listing) removed from favorites")
                        } else {
                            // Failed to remove from favorites
                            print("Failed to remove \(listing) from favorites")
                        }
                    }
            }) {
                Image(systemName: "minus.circle")
            }
        }
    }
}

//struct AddToListView: View {
//    @Binding var selectedCollections: [Collection]
//    @Binding var selectedListing: Listing?
//    @Binding var showAddToList: Bool
//    @State private var selectedCollectionIndex = 0
//    
//    @EnvironmentObject var authFireDBHelper: AuthenticationFireDBHelper
//    @EnvironmentObject var sellingFireDBHelper: SellingFireDBHelper
//    @EnvironmentObject var generalFireDBHelper: GeneralFireDBHelper
//    
//    @State private var loggedInUserCollections: [Collection] = []
//    
//    var body: some View {
//        VStack {
//            Picker("Select Collection", selection: $selectedCollectionIndex) {
//                ForEach(loggedInUserCollections.indices, id: \.self) { index in
//                    Text(loggedInUserCollections[index].name)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//            
//            Button("Add to Collection") {
//                if let listing = selectedListing {
//                    if selectedCollectionIndex < loggedInUserCollections.count {
//                        let selectedCollection = loggedInUserCollections[selectedCollectionIndex]
//                        generalFireDBHelper.addListingToCollection(listing, collection: selectedCollection) { error in
//                            if let error = error {
//                                                            // Handle error
//                                                            print("Error adding listing to collection: \(error.localizedDescription)")
//                                                        } else {
//                                                            // Successfully added to collection
//                                                            print("Listing added to collection")
//                                                            showAddToList = false
//                                                        }
//                                                    }
//                                                } else {
//                                                    // Handle invalid index scenario here
//                                                    print("Invalid collection index")
//                                                }
//                                            }
//                                        }
//            .padding()
//            .disabled(selectedListing == nil)
//        }
//        .padding()
//        .onAppear {
//                    // Fetch collections when the view appears
//                    generalFireDBHelper.getLoggedInUserCollections { collections in
//                    }
//                    self.loggedInUserCollections = generalFireDBHelper.userCollections
//                }
//    }
//}
//
//struct CollectionsGridView: View {
//    @EnvironmentObject var authFireDBHelper: AuthenticationFireDBHelper
//    @EnvironmentObject var generalFireDBHelper: GeneralFireDBHelper
//    @EnvironmentObject var fireAuthHelper: FireAuthHelper
//
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
//                ForEach(generalFireDBHelper.userCollections) { collection in
//                    // Example of a grid item in the collections grid view
//                    CollectionGridViewItem(collection: collection)
//                }
//            }
//            .padding()
//        }
//        .onAppear {
//            if let currUser = fireAuthHelper.user {
//                authFireDBHelper.getUser(email: currUser.email!)
//                // Fetch collections when the view appears
//                generalFireDBHelper.getLoggedInUserCollections { collections in
//                    // Collections data is updated in generalFireDBHelper.userCollections
//                }
//            }
//        }
//    }
//}
//
//struct CollectionGridViewItem: View {
//    @State private var isShowingListings = false
//    let collection: Collection
//    
//    var body: some View {
//        VStack {
//            // Collection Image
//            Image(systemName: "folder")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 50, height: 50)
//            
//            // Collection Title
//            Text(collection.name)
//        }
//        .onTapGesture {
//            isShowingListings.toggle()
//        }
//        .sheet(isPresented: $isShowingListings) {
//            // Sheet displaying listings included in this collection
//            CollectionListingsView(collection: collection)
//        }
//    }
//}
//struct CollectionListingsView: View {
//    let collection: Collection
//    @EnvironmentObject var generalFireDBHelper: GeneralFireDBHelper
//    @State private var listings: [Listing] = []
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(listings) { listing in
//                    NavigationLink(destination: ListingView(listing: listing)) {
//                        Text(listing.title)
//                    }
//                }
//                .onDelete(perform: deleteListing)
//            }
//            .navigationBarTitle(Text("Listings in \(collection.name)"))
//            .onAppear {
//                generalFireDBHelper.showListingsOfCollection(collection: collection) { fetchedListings in
//                    self.listings = fetchedListings
//                }
//            }
//        }
//    }
//    func deleteListing(at offsets: IndexSet) {
//            for index in offsets {
//                let listing = listings[index]
//                generalFireDBHelper.removeListingFromCollection(listing, collection: collection) { success in
//                    if (success != nil) {
//                        // Successfully removed listing from collection
//                        listings.remove(at: index)
//                    } else {
//                        // Failed to remove listing from collection
//                    }
//                }
//            }
//        }
//    }
//
//
//struct CreateCollectionView: View {
//    @Binding var isPresented: Bool
//    @Binding var collectionName: String
//    
//    @EnvironmentObject var generalFireDBHelper: GeneralFireDBHelper
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack {
//                    Button(action: {
//                        isPresented = false
//                    }) {
//                        Text("Cancel")
//                    }
//                    
//                    Spacer()
//                    
//                    Text("New Collection")
//                        .font(.headline)
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                                           // Call the addCollection method
//                                           generalFireDBHelper.addCollection(name: collectionName) { collection, error in
//                                               if let error = error {
//                                                   // Handle error
//                                                   print("Error creating collection: \(error.localizedDescription)")
//                                               } else if let collection = collection {
//                                                   // Collection created successfully
//                                                   print("Collection created successfully with ID: \(collection.id)")
//                                                   isPresented = false
//                                               }
//                                           }
//                                       }) {
//                                           Text("Create")
//                                       }
//                                   }
//                                   .padding()
//                
//                TextField("Enter Collection Name", text: $collectionName)
//                    .padding()
//                
//                Spacer()
//            }
//        }
//    }
// }
