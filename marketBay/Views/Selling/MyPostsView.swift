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
    
    var body: some View {
        NavigationStack() {
            PageHeadingFragment(pageTitle: "My Posts")
            
            VStack {
                List {
                    if(authFireDBHelper.user!.listings.isEmpty) {
                        Text("No Posts Available")
                    } else {
                        if(!authFireDBHelper.user!.listings.filter{$0.status == PostStatus.available.rawValue}.isEmpty) {
                            Section(header: Text("Available")){
                                ForEach(authFireDBHelper.user!.listings.filter{$0.status == PostStatus.available.rawValue}) { listing in
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
                        if(!authFireDBHelper.user!.listings.filter{$0.status == PostStatus.offTheMarket.rawValue}.isEmpty) {
                            Section(header: Text("Off the Market")){
                                ForEach(authFireDBHelper.user!.listings.filter{$0.status == PostStatus.offTheMarket.rawValue}) { listing in
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
                }

                NavigationLink(destination: CreatePostView().environmentObject(sellingFireDBHelper)) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
        }
        .padding()
        .navigationBarTitle("My Posts")
    }
}

#Preview {
    MyPostsView()
}
