//
//  MyPostsView.swift
//  marketBay
//  For View and Edit listing purpose
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI

struct MyPostsView: View {
    @EnvironmentObject var dataAccess: DataAccess
    private let fireDBHelper = SellingFireDBHelper.getInstance()
    
    var body: some View {
        NavigationStack() {
            MenuTemplate().environmentObject(dataAccess)
            PageHeadingFragment(pageTitle: "My Posts")
            
            VStack {
                List {
                    if(dataAccess.loggedInUserPostings.isEmpty) {
                        Text("No Posts Available")
                    } else {
                        if(!dataAccess.loggedInUserPostings.filter{$0.status == .available}.isEmpty) {
                            Section(header: Text("Available")){
                                ForEach(dataAccess.loggedInUserPostings.filter{$0.status == .available}) { listing in
                                    NavigationLink{
                                        PostView(listing: listing).environmentObject(dataAccess)
                                    }label:{
                                        MyPostsRow(listing: listing)
                                    }
                                }
                            }
                        }
                        if(!dataAccess.loggedInUserPostings.filter{$0.status == .offTheMarket}.isEmpty) {
                            Section(header: Text("Off the Market")){
                                ForEach(dataAccess.loggedInUserPostings.filter{$0.status == .offTheMarket}) { listing in
                                    NavigationLink{
                                        PostView(listing: listing)
                                    }label:{
                                        MyPostsRow(listing: listing)
                                    }
                                }
                            }
                        }
                    }
                }

                NavigationLink(destination: CreatePostView().environmentObject(dataAccess).environmentObject(fireDBHelper)) {
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
