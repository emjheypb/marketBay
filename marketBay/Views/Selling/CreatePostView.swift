//
//  AddPostsView.swift
//  marketBay
//
//  Created by Cheung K on 12/2/2024.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation

struct CreatePostView: View {
    @Environment(\.dismiss)  var dismiss
    @EnvironmentObject var sellingFireDBHelper : SellingFireDBHelper
    @EnvironmentObject var authFireDBHelper : AuthenticationFireDBHelper
    
    // MARK: Input Variables
    @State private var titleIn: String = ""
    @State private var descriptionIn: String = ""
    @State private var categoryIn: Category = .auto
    @State private var priceIn: String = ""
    @State private var conditionIn: Condition = .brandNew // Gordon: New input field for condition
    @State private var addressIn: String = "" // Gordon: New input field for address
    @State private var listingImage : UIImage?
    
    // MARK: Output Variables
    @State private var showAlert: Bool = false
    @State private var errorMessage = ""
    
    private let locationHelper = LocationHelper()
    
    var body: some View {
        CustomBackFragment()
        VStack {
            PageHeadingFragment(pageTitle: "New Post")
            
            // MARK: Post Details
            ScrollView {
                // MARK: Product Details
                // Title
                TextboxFragment(fieldName: "Title", placeholder: "Title", binding: $titleIn, isMandatory: true)
                
                Text("Product Details")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.top,.bottom], 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Category
                HStack {
                    Text("*")
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                    Text("Category")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Picker("Category", selection: $categoryIn) {
                    ForEach(Category.allCases.filter({$0 != .all}), id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                //Gordon: Condition Picker
                HStack {
                    Text("*")
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                    Text("Condition")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Picker("Condition", selection: $conditionIn) {
                    ForEach(Condition.allCases, id: \.self) { condition in
                        Text(condition.rawValue).tag(condition)
                    }
                }
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Price
                TextboxFragment(fieldName: "Price", placeholder: "Price", binding: $priceIn, keyboardType: .decimalPad, isMandatory: true)
                
                //Gordon: Address
                TextboxFragment(fieldName: "Address", placeholder: "Address", binding: $addressIn, isMandatory: true)
                    .textInputAutocapitalization(.words)
                
                // Description
                MultilineTextboxFragment(fieldName: "Description", placeholder: "Description", binding: $descriptionIn)
                
                // Listing Image
                UploadPhotoSubview(listingImage: $listingImage, imageURL: "")
            }
            
            Spacer()
            
            Button {
                locationHelper.convertAddressToCoordinates(address: addressIn) { result, latitude, longitude in
                    // MARK: Validate form
                    errorMessage = ""
                    
                    errorMessage += titleIn.isEmpty ? "\n• Title" : ""
                    errorMessage += priceIn.isEmpty || Double(priceIn) == nil ? "\n• Price" : ""
                    errorMessage += listingImage == nil ? "\n• Image" : ""
                    errorMessage += !result ? "\n• Address" : ""
                    
                    // MARK: Submit Listing
                    if(!errorMessage.isEmpty) {
                        showAlert = true
                    } else {
                        if let currentUser = authFireDBHelper.user {
                            
                            let newMiniUser = MiniUser(name: currentUser.name, email: currentUser.id!, phoneNumber: currentUser.phoneNumber)
                            let newListing = Listing(
                                title: titleIn,
                                description: descriptionIn,
                                category: categoryIn,
                                price: Double(priceIn) ?? 0,
                                seller: newMiniUser,
                                status: .available,
                                favoriteCount: 0,
                                condition: conditionIn,
                                location: GeoPoint(latitude: latitude, longitude: longitude)) // Gordon: Use latitudeIn and longitudeIn to create GeoPoint
                            
                            // insert to COLLECTION_LISTING
                            sellingFireDBHelper.insert(newData: newListing) { listingID, err in
                                if let currID = listingID {
                                    var newMiniListing = MiniListing(id: currID, title: newListing.title, status: newListing.status.rawValue, price: newListing.price)
                                    // upload to firebase storage
                                    sellingFireDBHelper.uploadImage(userEmail: currentUser.id!, newImage: listingImage!, fileName: currID) { imageURL, err in
                                        if let currImageURL = imageURL {
                                            newMiniListing.image = currImageURL
                                        }
                                        // insert to user listings
                                        authFireDBHelper.insertListing(newData: newMiniListing, user: currentUser.id!, listingID: currID)
                                    }
                                    dismiss()
                                } else {
                                    errorMessage += "Error Adding Posting. Try Again."
                                    showAlert = true
                                }
                            }
                        }
                    }
                }
            }label: {
                Text("P O S T")
                    .frame(maxWidth: .infinity)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Inputs"),
                    message: Text(errorMessage)
                )
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
