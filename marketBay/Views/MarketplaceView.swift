//
//  MarketplaceView.swift
//  marketBay
//  Home Screen of App for browsing listings
//  Have access points to DashboardView and ListingView,
//  Created by Cheung K on 12/2/2024.
//

import SwiftUI

struct MarketplaceView: View {
    @EnvironmentObject var dataAccess: DataAccess
    
    var body: some View {
        NavigationStack {
            MenuTemplate().environmentObject(dataAccess)
            Text("MARKETPLACE")
            Spacer()
        }
        .padding()
        .onAppear() {
            loadDummyData()
            dataAccess.isLoggedIn = dataAccess.getLoggedInUser() != nil
        }
    }
    
    func loadDummyData() {
        let posts = dataAccess.getPosts(idFilter: nil)
        
        if(posts.isEmpty) {
            // MARK: Dummy Users
            let users = [
                User(id: 1, name: "MJ", email: "mb", password: "mb", phoneNumber: "123"),
                User(id: 2, name: "Dayeeta", email: "dg", password: "dg", phoneNumber: "456"),
                User(id: 3, name: "Gordon", email: "kc", password: "kc", phoneNumber: "789"),
            ]
            
            // MARK: Dummy Seller Posts
            let posts = [
                Listing(id: 1, title: "Unlock! A Noside Story", description: "Secret Adventures: Part 1", price: 25.0, sellerID: 1),
                Listing(id: 2, title: "Unlock! Tombstone Express", description: "Secret Adventures: Part 2", price: 25.0, sellerID: 2),
                Listing(id: 3, title: "Unlock! The Adventures of Oz", description: "Secret Adventures: Part 3", price: 25.0, sellerID: 3),
            ]
            
            users[0].addListing(posts[0])
            users[1].addListing(posts[1])
            users[2].addListing(posts[2])
        }
    }
}

#Preview {
    MarketplaceView()
}
