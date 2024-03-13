//
//  ListingView.swift
//  marketBay
//  Subsequent View when click listings on Home Screen (MarketplaceView), show details of the listing
//  display all item details and a contact button to initiate communication with seller
//  Created by Cheung K on 12/2/2024.
//

import SwiftUI

struct ListingView: View {
    @EnvironmentObject var dataAccess: DataAccess
    @EnvironmentObject var sellingFireDBHelper: SellingFireDBHelper
    @EnvironmentObject var authFireDBHelper: AuthenticationFireDBHelper
    @EnvironmentObject var generalFireDBHelper: GeneralFireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper



    
    @State private var isFavorite: Bool = false
    @State private var showAlert = false
    @State var listing: Listing
    @State private var showingContactOptions = false
    
    var body: some View {
            ScrollView {
                VStack {
                    Spacer()
                    Spacer()
                    if(listing.image.isEmpty) {
                        Image(systemName: "photo") // Placeholder image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                    } else {
                        AsyncImage(url: URL(string: listing.image)) {
                            image in
                            image.image?.resizable()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                    }
                    
                    // Image Shortcut Gallery (if applicable)
                    // Add your implementation here
                    
                    // Title with Condition Label
                       HStack {
                           Text(listing.title)
                               .font(.title)
                               .fontWeight(.bold)
                               .multilineTextAlignment(.center)
                               .padding(.vertical)
                           // Condition Label
                           Text(listing.condition.rawValue)
                               .foregroundColor(.white)
                               .padding(.horizontal, 8)
                               .background(getBackgroundColor(for: listing.condition))
                               .cornerRadius(4)
                       }
                    
                    // Description
                    Text(listing.description) // Display actual listing description
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Seller Info
                    HStack {
                        Image(systemName: "person.circle") // Placeholder avatar
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text(listing.seller.name) // Display actual seller name
                                .font(.headline)
                            // Add more seller info (e.g., rating, location) if applicable
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingContactOptions = true
                        }) {
                            Text("Message")
                        }
                        .sheet(isPresented: $showingContactOptions) {
                            ContactOptionsView(listing: listing)
                        }
                        // Add to Favorites Button
                        if authFireDBHelper.user != nil {
                            Button(action: {
                                toggleFavorite()
                            }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .padding()
                                    .foregroundColor(.blue)
                                    .font(.title)
                            }
                        } else {
                            // Show an alert if no user is logged in
                            Button(action: {
                                showAlert = true
                            }) {
                                // Favourite Icon = Alerts to SignIn/Register
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .padding()
                                    .foregroundColor(.blue)
                                    .font(.title)
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Reminder"), message: Text("Please login or register to use the favorite function."), dismissButton: .default(Text("OK")))
                            }
                        }

                    }
                    .padding()
                    
                    // Price Info
                    Text("Price: $\(String(format: "%.2f", listing.price))") // Display actual price
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.vertical)
                    
                    // Share Button
                    Button(action: {
                        shareListing()
                    }) {
                        Text("Share")
                    }
                    .padding()
                    
                    // MapView to display listing's location
                    MapView(latitude: listing.location.latitude, longitude: listing.location.longitude)
                       .frame(height: 200)
                       .cornerRadius(8)
                       .padding(.horizontal)
                    
                    // Buy Now Button (if applicable)
                    // Add your implementation here
                }
                .padding(.horizontal)
            }
            .onAppear{
                DispatchQueue.main.async {
                    fireAuthHelper.listenToAuthState()
                    // Check if the user is logged in and update favorite status
                    if let currUser = fireAuthHelper.user {
                        authFireDBHelper.getUser(email: currUser.email!)
                        
                        generalFireDBHelper.isListingFavorited(listing) { isFavorited in
                            self.isFavorite = isFavorited
                        }
                    } else {
                        isFavorite = false
                    }
                }
        }
            .onChange(of: isFavorite) { newValue in
                // Update favorite status
                if newValue {
                    // Add to favorites
                    addToFavorites { success in
                        if !success {
                            // Handle failure
                            print("Failed to add listing to favorites")
                        } else {
                            // Handle success
                            print("Listing added to favorites successfully")
                        }
                    }
                } else {
                    // Remove from favorites
                    removeFromFavorites { success in
                        if !success {
                            // Handle failure
                            print("Failed to remove listing from favorites")
                        } else {
                            // Handle success
                            print("Listing removed from favorites successfully")
                        }
                    }
                }
            }
    }
    
    // Function to get background color for condition label
    func getBackgroundColor(for condition: Condition) -> Color {
            switch condition {
            case .preOwned:
                return Color.red
            case .good:
                return Color.blue
            case .veryGood:
                return Color.green
            case .brandNew:
                return Color.orange
            }
        }
    
    func toggleFavorite() {
            if authFireDBHelper.user != nil {
                isFavorite.toggle()
            } else {
                showAlert = true
            }
        }
        
    func addToFavorites(completion: @escaping (Bool) -> Void) {
        // Check if the listing is already favorited
        generalFireDBHelper.isListingFavorited(listing) { isFavorited in
            if isFavorited {
                // Listing is already favorited, no need to add again
                completion(false)
            } else {
                // Add listing to favorites in Firestore
                generalFireDBHelper.addToFavorites(listing) { error in
                    if let error = error {
                        // Error occurred while adding listing to favorites
                        print("Error adding listing to favorites: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        // Listing added to favorites successfully
                        completion(true)
                    }
                }
            }
        }
    }


    func removeFromFavorites(completion: @escaping (Bool) -> Void) {
        // Remove listing from favorites in Firestore
        generalFireDBHelper.removeFromFavorites(listing) { success in
            completion(success)
        }
    }


    func shareListing() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let items: [Any] = ["Check out this listing: \(listing.title)\nDescription: \(listing.description)\nPrice: $\(String(format: "%.2f", listing.price))"]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        window.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    struct ContactOptionsView: View {
        let listing: Listing
        
        var body: some View {
            VStack {
                Text("Contact Options")
                    .font(.title)
                    .padding()
                
                Button(action: {
                    // Action to call seller
                    if let phoneURL = URL(string: "tel://\(listing.seller.phoneNumber)") {
                                       UIApplication.shared.open(phoneURL)
                                   }
                }) {
                    Text("Call \(listing.seller.name)")
                        .padding()
                }
                
                Button(action: {
                    // Action to email seller
                    if let emailURL = URL(string: "mailto:\(listing.seller.email)") {
                                       UIApplication.shared.open(emailURL)
                                   }
                }) {
                    Text("Email \(listing.seller.name)")
                        .padding()
                }
                
                Spacer()
            }
        }
    }
}


