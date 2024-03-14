//
//  PostView.swift
//  marketBay
//
//  Created by EmJhey PB on 2/12/24.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore
import Contacts

struct PostView: View {
    @Environment(\.dismiss)  var dismiss
    @EnvironmentObject var sellingFireDBHelper : SellingFireDBHelper
    @EnvironmentObject var authFireDBHelper : AuthenticationFireDBHelper
    
    // MARK: Input Variables
    @State private var titleIn: String = ""
    @State private var descriptionIn: String = ""
    @State private var categoryIn: Category = .auto
    @State private var conditionIn: Condition = .brandNew
    @State private var addressIn: String = ""
    @State private var priceIn: String = ""
    @State private var listingImage : UIImage?
    
    // MARK: Output Variables
    @State private var showUpdateAlert: Bool = false
    @State private var showUpdateError: Bool = false
    @State private var errorMessage = ""
    @State private var showOffMarketAlert: Bool = false
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    
    var listing: Listing
    let locationHelper = LocationHelper()
    
    var body: some View {
        CustomBackFragment()
        VStack {
            // MARK: Header
            PageHeadingFragment(pageTitle: listing.title, padding: 0)
            Text(listing.status.rawValue)
                .foregroundColor(listing.status == .available ? .green : .red)
            
            ScrollView {
                // Placeholder image
                UploadPhotoSubview(listingImage: $listingImage, imageURL: listing.image, isDisabled: listing.status == PostStatus.offTheMarket)
                
                Text("# \(listing.id!)")
                    .font(.title2)
                
                // MARK: Product Details
                if(listing.status == .available) {
                    // MARK: Available UI
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
                    
                    // Condition Picker
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
                    
                    // Address
                    TextboxFragment(fieldName: "Address", placeholder: "Address", binding: $addressIn, isMandatory: true)
                        .textInputAutocapitalization(.words)
                    
                    // Description
                    MultilineTextboxFragment(fieldName: "Description", placeholder: "Description", binding: $descriptionIn)
                    
                    Spacer()
                    
                    // MARK: Update Button
                    Button {
                        locationHelper.convertAddressToCoordinates(address: addressIn) { result, latitude, longitude in
                            // MARK: Validate form
                            showUpdateError = false
                            errorMessage = ""
                            
                            errorMessage += titleIn.isEmpty ? "\n• Title" : ""
                            errorMessage += priceIn.isEmpty || Double(priceIn) == nil ? "\n• Price" : ""
                            errorMessage += listingImage == nil && listing.image.isEmpty ? "\n• Image" : ""
                            errorMessage += !result ? "\n• Address" : ""
                            
                            if(!errorMessage.isEmpty) {
                                showUpdateError = true
                            }
                            
                            self.latitude = latitude
                            self.longitude = longitude
                            showUpdateAlert =  true
                        }
                    }label: {
                        Text("Update Post")
                            .frame(maxWidth: .infinity)
                    }
                    .alert(isPresented: $showUpdateAlert) {
                        if(showUpdateError) {
                            Alert(
                                title: Text("Invalid Inputs"),
                                message: Text(errorMessage)
                            )
                        } else {
                            Alert(
                                title: Text("Update Listing Details"),
                                message: Text("Are you sure you want to update?"),
                                primaryButton: .default(Text("Update")) {
                                    var updatedListing = Listing(
                                        id: listing.id!,
                                        title: titleIn,
                                        description: descriptionIn,
                                        category: categoryIn,
                                        price: Double(priceIn) ?? 0,
                                        seller: listing.seller,
                                        status: listing.status,
                                        favoriteCount: listing.favoriteCount,
                                        image: listing.image,
                                        condition: conditionIn,
                                        location: GeoPoint(latitude: latitude, longitude: longitude))
                                    if let image = listingImage {
                                        sellingFireDBHelper.updateImage(newData: updatedListing, newImage: image) { imageDownloadURL, error in
                                            if let imageURL = imageDownloadURL {
                                                updatedListing.image = imageURL
                                                authFireDBHelper.updateMiniListing(newData: updatedListing)
                                            }
                                        }
                                    } else {
                                        sellingFireDBHelper.update(newData: updatedListing)
                                        authFireDBHelper.updateMiniListing(newData: updatedListing)
                                    }
                                    
                                    dismiss()
                                },
                                secondaryButton: .destructive(Text("Cancel"))
                            )
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // MARK: Take Off the Market Button
                    Button {
                        showOffMarketAlert = true
                    }label: {
                        Text("Take Off the Market")
                            .frame(maxWidth: .infinity)
                    }
                    .alert(isPresented: $showOffMarketAlert) {
                        Alert(
                            title: Text("There's no turning back!"),
                            message: Text("Are you sure you want to take this off the market?"),
                            primaryButton: .destructive(Text("Take Off the Market")) {
                                let updatedListing = Listing(
                                    id: listing.id!,
                                    title: listing.title,
                                    description: listing.description,
                                    category: listing.category,
                                    price: listing.price,
                                    seller: listing.seller,
                                    status: PostStatus.offTheMarket,
                                    favoriteCount: listing.favoriteCount,
                                    image: listing.image,
                                    condition: listing.condition,
                                    location: listing.location)
                                sellingFireDBHelper.update(newData: updatedListing)
                                authFireDBHelper.updateMiniListing(newData: updatedListing)
                                dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else {
                    // MARK: Off the Market UI
                    // Category
                    TextFragment(title: "Category", details: listing.category.rawValue, bottomPadding: 5, leadingPadding: 10)
                    
                    // Condition
                    TextFragment(title: "Condition", details: listing.condition.rawValue, bottomPadding: 5, leadingPadding: 10)
                    
                    // Price
                    TextFragment(title: "Price", details: "$\(String(format: "%.2f", listing.price))", bottomPadding: 5, leadingPadding: 10)
                    
                    // Address
                    TextFragment(title: "Address", details: addressIn, bottomPadding: 5, leadingPadding: 10)
                    
                    // Description
                    TextFragment(title: "Description", details: listing.description, bottomPadding: 5, leadingPadding: 10)
                    
                    Spacer()
                }
            }
            .onAppear() {
                locationHelper.convertCoordinatesToAddress(latitude: listing.location.latitude, longitude: listing.location.longitude) { address in
                    addressIn = address
                }
                titleIn = listing.title
                categoryIn = listing.category
                descriptionIn = listing.description
                priceIn = String(format: "%.2f", listing.price)
                conditionIn = listing.condition
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

