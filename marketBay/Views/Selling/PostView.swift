//
//  PostView.swift
//  marketBay
//
//  Created by EmJhey PB on 2/12/24.
//

import SwiftUI

struct PostView: View {
    @Environment(\.dismiss)  var dismiss
    @EnvironmentObject var dataAccess: DataAccess
    
    // MARK: Input Variables
    @State private var titleIn: String = ""
    @State private var descriptionIn: String = ""
    @State private var categoryIn: Category = .auto
    @State private var priceIn: String = ""
    
    // MARK: Output Variables
    @State private var showUpdateAlert: Bool = false
    @State private var showUpdateError: Bool = false
    @State private var errorMessage = ""
    @State private var showOffMarketAlert: Bool = false
    
    var listing: Listing
    
    var body: some View {
        BackMenuFragment()
        VStack {
            // MARK: Header
            PageHeadingFragment(pageTitle: listing.title, padding: 0)
            Text(listing.status.rawValue)
                .foregroundColor(listing.status == .available ? .green : .red)
            
            ScrollView {
                // Placeholder image
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                
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
                    
                    // Price
                    TextboxFragment(fieldName: "Price", placeholder: "Price", binding: $priceIn, keyboardType: .decimalPad, isMandatory: true)
                    
                    // Description
                    MultilineTextboxFragment(fieldName: "Description", placeholder: "Description", binding: $descriptionIn)
                    
                    
                    Spacer()
                    
                    // MARK: Update Button
                    Button {
                        // MARK: Validate form
                        showUpdateError = false
                        errorMessage = ""
                        
                        errorMessage += titleIn.isEmpty ? "\n• Title" : ""
                        errorMessage += priceIn.isEmpty || Double(priceIn) == nil ? "\n• Price" : ""
                        
                        // MARK: Success
                        if(!errorMessage.isEmpty) {
                            showUpdateError = true
                        }
                        
                        showUpdateAlert =  true
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
                                title: Text("There's no turning back!"),
                                message: Text("Are you sure you want to update this post?"),
                                primaryButton: .default(Text("Update")) {
                                    let listingToUpdate = Listing(title: titleIn, description: descriptionIn, category: categoryIn, price: Double(priceIn) ?? 0, seller: listing.seller, status: listing.status, favoriteCount: 0)
                                    dataAccess.savePosts(post: listingToUpdate, isUpdate: true)
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
                                var listingToUpdate = listing
                                listingToUpdate.status = .offTheMarket
                                dataAccess.savePosts(post: listingToUpdate, isUpdate: true)
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
                    
                    // Price
                    TextFragment(title: "Price", details: "$\(String(format: "%.2f", listing.price))", bottomPadding: 5, leadingPadding: 10)
                    
                    // Description
                    TextFragment(title: "Description", details: listing.description, bottomPadding: 5, leadingPadding: 10)
                    
                    Spacer()
                }
            }
            .onAppear() {
                titleIn = listing.title
                categoryIn = listing.category
                descriptionIn = listing.description
                priceIn = String(format: "%.2f", listing.price)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PostView(listing: Listing(title: "Unlock! A Noside Story", description: "Secret Adventures: Part 1", category: .toys, price: 25.0, seller: MiniUser(name: "MJ", email: "mb", phoneNumber: "123"), status: .available, favoriteCount: 0))
}
