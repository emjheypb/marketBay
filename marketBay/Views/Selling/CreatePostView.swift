//
//  AddPostsView.swift
//  marketBay
//
//  Created by Cheung K on 12/2/2024.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss)  var dismiss
    @EnvironmentObject var dataAccess: DataAccess
    @EnvironmentObject var fireDBHelper : SellingFireDBHelper
    
    // MARK: Input Variables
    @State private var titleIn: String = ""
    @State private var descriptionIn: String = ""
    @State private var categoryIn: Category = .auto
    @State private var priceIn: String = ""
    
    // MARK: Output Variables
    @State private var showAlert: Bool = false
    @State private var errorMessage = ""
    
    var body: some View {
        BackMenuFragment().environmentObject(dataAccess)
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
                
                // Price
                TextboxFragment(fieldName: "Price", placeholder: "Price", binding: $priceIn, keyboardType: .decimalPad, isMandatory: true)
                
                // Description
                MultilineTextboxFragment(fieldName: "Description", placeholder: "Description", binding: $descriptionIn)
                
                // Placeholder image
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
            }
            Spacer()
            
            Button {
                // MARK: Validate form
                errorMessage = ""
                
                errorMessage += titleIn.isEmpty ? "\n• Title" : ""
                errorMessage += priceIn.isEmpty || Double(priceIn) == nil ? "\n• Price" : ""
                
                // MARK: Success
                if(!errorMessage.isEmpty) {
                    showAlert = true
                } else {
                    let currentUser = dataAccess.loggedInUser!
                    let newMiniUser = MiniUser(name: currentUser.name, email: currentUser.id!, phoneNumber: currentUser.phoneNumber)
                    let currentListing = Listing(title: titleIn, description: descriptionIn, category: categoryIn, price: Double(priceIn) ?? 0, seller: newMiniUser, status: .available, favoriteCount: 0)
                    
                    fireDBHelper.insert(newData: currentListing)
//                    dataAccess.savePosts(post: currentListing)
                    dismiss()
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
    
    func resetFields() {
        titleIn = ""
        descriptionIn = ""
        categoryIn = .auto
        priceIn = ""
    }
}

#Preview {
    CreatePostView()
}
