//
//  ListingView.swift
//  marketBay
//  Subsequent View when click listings on Home Screen (MarketplaceView), show details of the listing
//  display all item details and a contact button to initiate communication with seller
//  Created by Cheung K on 12/2/2024.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation

struct ListingView: View {
    @Environment(\.dismiss)  var dismiss
    @EnvironmentObject var dataAccess: DataAccess
    @EnvironmentObject var sellingFireDBHelper: SellingFireDBHelper
    @EnvironmentObject var authFireDBHelper: AuthenticationFireDBHelper
    @EnvironmentObject var generalFireDBHelper: GeneralFireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    
    @State private var isFavorite: Bool = false
    @State private var showAlert = false
    @State var listing: Listing
    @State private var showingContactOptions = false
    @State private var address: String = "" // Add state variable to hold the address
    @State private var errorMessage: String = ""
    
    
    var body: some View {
        HStack {
            // MARK: Custom Back Button
            // includes logo to compansate for removal of back swipe gesture
            Button {
                dismiss()
            } label:{
                Image(systemName: "chevron.backward")
                    .imageScale(.large)
                    .foregroundColor(.blue)
                
                // MARK: Logo
                Image(.marketBay)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125)
            }
            
            Spacer()
            
            // Add to Favorites Button
            if authFireDBHelper.user != nil {
                Button(action: {
                    toggleFavorite()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
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
                        .foregroundColor(.blue)
                        .font(.title)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Reminder"), message: Text("Please login or register to use the favorite function."), dismissButton: .default(Text("OK")))
                }
            }
            
            // Share Button
            Button(action: {
                shareListing()
            }) {
                Image(systemName: "square.and.arrow.up")
                    .padding()
                    .font(.title) // Adjust the size of the button
            }
        }
        .padding([.top, .leading, .trailing])
        
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack {
                    if(listing.image.isEmpty) {
                        Image(systemName: "photo") // Placeholder image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    } else {
                        AsyncImage(url: URL(string: listing.image)) {
                            image in
                            image.image?.resizable()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                    }
                    
                    // Image Shortcut Gallery (if applicable)
                    // Add your implementation here
                    
                    // Title with Condition Label
                    //                    HStack {
                    Text(listing.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    // Condition Label
                    Text(listing.condition.rawValue)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .background(getBackgroundColor(for: listing.condition))
                        .cornerRadius(4)
                    //                    }
                    
                    // Description
                    Text(listing.description) // Display actual listing description
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Seller Info
                    HStack {
                        Image(systemName: "person.circle") // Placeholder avatar
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text("Seller: \(listing.seller.name)") // Display actual seller name
                                .font(.headline)
                            // Add more seller info (e.g., rating, location) if applicable
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            //                            showingContactOptions = true
                            // Action to email seller
                            if let emailURL = URL(string: "mailto:\(listing.seller.email)") {
                                UIApplication.shared.open(emailURL)
                            }
                        }) {
                            Image(systemName: "envelope")
                                .padding([.leading])
                                .foregroundColor(.blue)
                                .font(.title)
                        }
                        .sheet(isPresented: $showingContactOptions) {
                            ContactOptionsView(listing: listing)
                        }
                        
                        Button(action: {
                            //                            showingContactOptions = true
                            // Action to call seller
                            if let phoneURL = URL(string: "tel://\(listing.seller.phoneNumber)") {
                                UIApplication.shared.open(phoneURL)
                            }
                        }) {
                            Image(systemName: "phone")
                                .padding([.leading])
                                .foregroundColor(.blue)
                                .font(.title)
                        }
                        .sheet(isPresented: $showingContactOptions) {
                            ContactOptionsView(listing: listing)
                        }
                        
                        // Add to Favorites Button
                        //                        if authFireDBHelper.user != nil {
                        //                            Button(action: {
                        //                                toggleFavorite()
                        //                            }) {
                        //                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                        //                                    .padding()
                        //                                    .foregroundColor(.blue)
                        //                                    .font(.title)
                        //                            }
                        //                        } else {
                        //                            // Show an alert if no user is logged in
                        //                            Button(action: {
                        //                                showAlert = true
                        //                            }) {
                        //                                // Favourite Icon = Alerts to SignIn/Register
                        //                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                        //                                    .padding()
                        //                                    .foregroundColor(.blue)
                        //                                    .font(.title)
                        //                            }
                        //                            .alert(isPresented: $showAlert) {
                        //                                Alert(title: Text("Reminder"), message: Text("Please login or register to use the favorite function."), dismissButton: .default(Text("OK")))
                        //                            }
                        //                        }
                        
                    }
                    .padding()
                    
                    // Price Info
                    Text("Price: $\(String(format: "%.2f", listing.price))") // Display actual price
                        .font(.system(size: 40, weight: .bold)) // Adjust the font size here (change 40 to your desired size)
                        .foregroundColor(.green)
                        .padding(.vertical)
                    
                    // MapView to display listing's location
                    MapView(latitude: listing.location.latitude, longitude: listing.location.longitude, address: address)
                        .frame(height: 200)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    // Buy Now Button (if applicable)
                    // Add your implementation here
                }
                .padding(.horizontal)
            }
            
            // Share Button
            //            HStack {
            //                Spacer()
            //                Button(action: {
            //                    shareListing()
            //                }) {
            //                    Image(systemName: "square.and.arrow.up")
            //                        .padding()
            //                        .font(.title) // Adjust the size of the button
            //                }
            //            }
            //            .padding()
        }
        .onAppear{
            DispatchQueue.main.async {
                // Perform reverse geocoding to get the address
                convertCoordinatesToAddress()
                
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
        .navigationBarBackButtonHidden()
    }
    
    private func convertCoordinatesToAddress() {
        let location = CLLocation(latitude: listing.location.latitude, longitude: listing.location.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                if let error = error {
                    errorMessage = "Reverse geocoding error: \(error.localizedDescription)"
                } else {
                    errorMessage = "Unknown error occurred during reverse geocoding."
                }
                return
            }
            
            // Construct the address using available properties
            var addressComponents: [String] = []
            if let subThoroughfare = placemark.subThoroughfare {
                addressComponents.append(subThoroughfare)
            }
            if let thoroughfare = placemark.thoroughfare {
                addressComponents.append(thoroughfare)
            }
            if let locality = placemark.locality {
                addressComponents.append(locality)
            }
            if let administrativeArea = placemark.administrativeArea {
                addressComponents.append(administrativeArea)
            }
            if let postalCode = placemark.postalCode {
                addressComponents.append(postalCode)
            }
            if let country = placemark.country {
                addressComponents.append(country)
            }
            
            // Combine address components into a single string
            let formattedAddress = addressComponents.joined(separator: ", ")
            
            // Update the address state variable
            address = formattedAddress
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


