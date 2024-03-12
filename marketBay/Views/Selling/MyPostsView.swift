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
                if let currUser = authFireDBHelper.user {
                    if(currUser.listings.isEmpty) {
                        Text("No Posts Available")
                    } else {
                        if(!currUser.listings.filter{$0.status == PostStatus.available.rawValue}.isEmpty) {
                            Section(header: Text("Available")){
                                ForEach(currUser.listings.filter{$0.status == PostStatus.available.rawValue}) { listing in
                                    NavigationLink{
                                        if let listingDetails = sellingFireDBHelper.getListingDetails(id: listing.id) {
                                            PostView(listing: listingDetails).environmentObject(sellingFireDBHelper).environmentObject(authFireDBHelper)
                                        }
                                    }label:{
                                        MyPostsRow(listing: listing)
                                    }
                                }
                            }
                        }
                        if(!currUser.listings.filter{$0.status == PostStatus.offTheMarket.rawValue}.isEmpty) {
                            Section(header: Text("Off the Market")){
                                ForEach(currUser.listings.filter{$0.status == PostStatus.offTheMarket.rawValue}) { listing in
                                    NavigationLink{
                                        if let listingDetails = sellingFireDBHelper.getListingDetails(id: listing.id) {
                                            PostView(listing: listingDetails)
                                        }
                                    }label:{
                                        MyPostsRow(listing: listing)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Text("No Posts Available")
                }
            }
            
            NavigationLink(destination: CreatePostView().environmentObject(sellingFireDBHelper).environmentObject(authFireDBHelper)) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
        }
        .padding()
        .onAppear() {
            if let currUser = fireAuthHelper.user {
                authFireDBHelper.getUser(email: currUser.email!)
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
