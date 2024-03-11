//
//  AddPostsView.swift
//  marketBay
//
//  Created by Cheung K on 12/2/2024.
//

import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @Environment(\.dismiss)  var dismiss
    @EnvironmentObject var sellingFireDBHelper : SellingFireDBHelper
    @EnvironmentObject var authFireDBHelper : AuthenticationFireDBHelper
    
    // MARK: Input Variables
    @State private var titleIn: String = ""
    @State private var descriptionIn: String = ""
    @State private var categoryIn: Category = .auto
    @State private var priceIn: String = ""
    @State private var listingImage : UIImage?
    
    // MARK: Output Variables
    @State private var showAlert: Bool = false
    @State private var showSheet: Bool = false
    @State private var permissionGranted: Bool = false
    @State private var showPicker : Bool = false
    @State private var isUsingCamera : Bool = false
    @State private var errorMessage = ""
    
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
                
                // Price
                TextboxFragment(fieldName: "Price", placeholder: "Price", binding: $priceIn, keyboardType: .decimalPad, isMandatory: true)
                
                // Description
                MultilineTextboxFragment(fieldName: "Description", placeholder: "Description", binding: $descriptionIn)
                
                // Placeholder image
                Button {
                    if(self.permissionGranted) {
                        self.showSheet = true
                    } else {
                        self.checkPermission()
                    }
                } label: {
                    Image(uiImage: listingImage ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                }
                .actionSheet(isPresented: self.$showSheet){
                    ActionSheet(title: Text("Select Photo"),
                                message: Text("Choose profile picture to upload"),
                                buttons: [
                                    .default(Text("Choose photo from library")){
                                        //show library picture picker
                                        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                                            print(#function, "No Library Access")
                                            return
                                        }
                                        
                                        self.isUsingCamera = false
                                        self.showPicker = true
                                    },
                                    .default(Text("Take a new pic from Camera")){
                                        //open camera
                                        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                                            print(#function, "No Camera Access")
                                            return
                                        }
                                        
                                        self.isUsingCamera = true
                                        self.showPicker = true
                                    },
                                    .cancel()
                                ])
                }
            }
            .fullScreenCover(isPresented: self.$showPicker){
                if (isUsingCamera){
                    //open camera Picker
                    CameraPicker(selectedImage: self.$listingImage)
                }else{
                    //open library picker
                    PhotoLibraryPicker(selectedImage: self.$listingImage)
                }
            }
            
            Spacer()
            
            Button {
                // MARK: Validate form
                errorMessage = ""
                
                errorMessage += titleIn.isEmpty ? "\n• Title" : ""
                errorMessage += priceIn.isEmpty || Double(priceIn) == nil ? "\n• Price" : ""
                errorMessage += listingImage == nil ? "\n• Image" : ""
                
                // MARK: Submit Listing
                if(!errorMessage.isEmpty) {
                    showAlert = true
                } else {
                    if let currentUser = authFireDBHelper.user {
                        let newMiniUser = MiniUser(name: currentUser.name, email: currentUser.id!, phoneNumber: currentUser.phoneNumber)
                        let newListing = Listing(title: titleIn, description: descriptionIn, category: categoryIn, price: Double(priceIn) ?? 0, seller: newMiniUser, status: .available, favoriteCount: 0)
                        
                        sellingFireDBHelper.insert(newData: newListing) { listingID, err in
                            if let currID = listingID {
                                var newMiniListing = MiniListing(id: currID, title: newListing.title, status: newListing.status.rawValue, price: newListing.price)
                                sellingFireDBHelper.uploadImage(userEmail: currentUser.id!, newImage: listingImage!, fileName: currID) { imageURL, err in
                                    if let currImageURL = imageURL {
                                        newMiniListing.image = currImageURL
                                    }
                                    authFireDBHelper.insertListing(newData: newMiniListing)
                                }
                                dismiss()
                            } else {
                                errorMessage += "Error Adding Posting. Try Again."
                                showAlert = true
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
    
    private func checkPermission(){
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .denied:
            self.permissionGranted = false
            requestPermission()
        case .authorized:
            self.permissionGranted = true
        case .limited, .restricted:
            // inform user
            break
        @unknown default:
            return
        }
    }
    
    private func requestPermission(){
        PHPhotoLibrary.requestAuthorization { status in
            switch(status) {
            case .notDetermined, .denied:
                self.permissionGranted = false
            case .authorized:
                self.permissionGranted = true
            case .limited, .restricted:
                // inform user
                break
            @unknown default:
                return
            }
        }
    }
}

#Preview {
    CreatePostView()
}
