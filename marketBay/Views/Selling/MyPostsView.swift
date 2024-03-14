//
//  MyPostsView.swift
//  marketBay
//  For View and Edit listing purpose
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI

struct MyPostsView: View {
    @EnvironmentObject var sellingFireDBHelper : SellingFireDBHelper
    @EnvironmentObject var authFireDBHelper: AuthenticationFireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    
    @State private var searchString : String = ""
    @State private var displayAvailable: Bool = true
    @State private var displayOffMarket: Bool = true
    
    var body: some View {
        PageHeadingFragment(pageTitle: "My Posts")
        
        VStack {
            // MARK: Search Query Filter
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 15, height: 15)
                TextField("Enter post ID or title", text: $searchString)
                    .textInputAutocapitalization(.never)
            }
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal)
            
            // MARK: Status Filter
            HStack {
                Button {
                    displayAvailable = !displayAvailable
                } label: {
                    Image(systemName: displayAvailable ? "checkmark.square" : "square")
                    Text("Available")
                        .foregroundStyle(.black)
                }
                Button {
                    displayOffMarket = !displayOffMarket
                } label: {
                    Image(systemName: displayOffMarket ? "checkmark.square" : "square")
                    Text("Off Market")
                        .foregroundStyle(.black)
                }
            }
            
            // MARK: Posts List
            List {
                if(authFireDBHelper.userListings.isEmpty) {
                    Text("No Posts Available")
                } else {
                    if(displayAvailable) {
                        Section(header: Text("Available")){
                            ForEach(filterPosts(status: .available, searchString: self.searchString)) { listing in
                                NavigationLink{
                                    if let listingDetails = sellingFireDBHelper.getListingDetails(id: listing.id!) {
                                        PostView(listing: listingDetails)
                                            .environmentObject(sellingFireDBHelper)
                                            .environmentObject(authFireDBHelper)
                                    }
                                }label:{
                                    MyPostsRow(listing: listing)
                                }
                            }
                        }
                    }
                    
                    if(displayOffMarket) {
                        Section(header: Text("Off the Market")){
                            ForEach(filterPosts(status: .offTheMarket, searchString: self.searchString)) { listing in
                                NavigationLink{
                                    if let listingDetails = sellingFireDBHelper.getListingDetails(id: listing.id!) {
                                        PostView(listing: listingDetails)
                                    }
                                }label:{
                                    MyPostsRow(listing: listing)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        NavigationLink(destination: CreatePostView().environmentObject(sellingFireDBHelper).environmentObject(authFireDBHelper)) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
        .padding()
        .onAppear() {
            authFireDBHelper.removeListener()
            if let currUser = fireAuthHelper.user {
                authFireDBHelper.getUser(email: currUser.email!)
                authFireDBHelper.getUserListings(email: currUser.email!)
            }
        }
        .onDisappear() {
            authFireDBHelper.removeListener()
        }
    }
    
    private func filterPosts(status: PostStatus, searchString: String) -> [MiniListing] {
        let currListings = authFireDBHelper.userListings.filter{$0.status == status.rawValue}
        if(searchString.isEmpty) {
            return currListings
        }
        
        var result: [MiniListing] = []
        for listing in currListings {
            if(listing.title.lowercased().contains(searchString.lowercased()) || listing.id!.lowercased().contains(searchString.lowercased())) {
                result.append(listing)
            }
        }
        
        return result
    }
}

#Preview {
    MyPostsView()
}
