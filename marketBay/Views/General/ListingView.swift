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
    
    @State private var isFavorite: Bool = false
    @State private var showAlert = false
    @State var listing: Listing
    @State private var showingContactOptions = false
    
    var body: some View {
            ScrollView {
                VStack {
                    Spacer()
                    Spacer()
                    // Image
                    Image(systemName: "photo") // Placeholder image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                    
                    // Image Shortcut Gallery (if applicable)
                    // Add your implementation here
                    
                    // Title
                    Text(listing.title) // Display actual listing title
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                    
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
                        if dataAccess.loggedInUser != nil {
                            Button(action: {
                                dataAccess.toggleFavorite(for: listing) { isFavoriteValue in
                                    self.isFavorite = isFavoriteValue
                                }
                            }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .padding()
                                    .foregroundColor(.blue)
                                    .font(.title)
                            }
                        }else{
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
                    
                    // Buy Now Button (if applicable)
                    // Add your implementation here
                }
                .padding(.horizontal)
            }
            .onAppear{
                DispatchQueue.main.async {
                    if dataAccess.loggedInUser != nil {
                               isFavorite = dataAccess.loggedInUserFavorites.contains(where: { $0.id == listing.id })
                           } else {
                            isFavorite = false
                        }
                    }
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListingView(listing: Listing(title: "Sample Listing", description: "This is a sample listing description.", category: .electronics, price: 99.99, seller: MiniUser(name: "John Doe", email: "john@example.com", phoneNumber: "123456789"), status: .available, favoriteCount: 0))
    }
}
