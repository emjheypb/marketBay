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
    
    var body: some View {
        PageHeadingFragment(pageTitle: "My Posts")
        
        VStack {
            List {
                if(authFireDBHelper.userListings.isEmpty) {
                    Text("No Posts Available")
                } else {
                    if(!authFireDBHelper.userListings.filter{$0.status == PostStatus.available.rawValue}.isEmpty) {
                        Section(header: Text("Available")){
                            ForEach(authFireDBHelper.userListings.filter{$0.status == PostStatus.available.rawValue}) { listing in
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
                    if(!authFireDBHelper.userListings.filter{$0.status == PostStatus.offTheMarket.rawValue}.isEmpty) {
                        Section(header: Text("Off the Market")){
                            ForEach(authFireDBHelper.userListings.filter{$0.status == PostStatus.offTheMarket.rawValue}) { listing in
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
}

#Preview {
    MyPostsView()
}
