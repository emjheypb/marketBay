//
//  DashboardView.swift
//  marketBay
//  Have access points to ProfileView, FavoritesView, MyPostsView, 
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject var dataAccess: DataAccess
    @State private var numberOfPostings = 0
    @State private var numberOfFavorites = 0
    
    var body: some View {
        NavigationStack {
            VStack {
            //MenuTemplate().environmentObject(dataAccess)
                // Title "You"
                Text("Dashboard")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Profile Info
                HStack {
                    Image(systemName: "person.circle") // Placeholder avatar
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading) {
                        
                        if let currentUser = dataAccess.loggedInUser {
                            
                            Text(currentUser.name)
                                .font(.headline)
                        }
                        
                        Button {
                            appRootManager.currentRoot = .profileView
                        } label: {
                            Text("Edit Profile")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                // ListView Layout
                VStack {
                    NavigationLink(destination: FavoritesView().environmentObject(dataAccess)) {
                           DashboardItemView(icon: "star.fill", title: "Favorites")
                       }
                       .onTapGesture {
                           appRootManager.currentRoot = .favoritesView
                       }
                       
                       NavigationLink(destination: MyPostsView().environmentObject(dataAccess)) {
                           DashboardItemView(icon: "doc.plaintext.fill", title: "Current Listings")
                       }
                       .onTapGesture {
                           appRootManager.currentRoot = .myPostsView
                       }
                       
                       NavigationLink(destination: CreatePostView().environmentObject(dataAccess)) {
                           DashboardItemView(icon: "plus.circle.fill", title: "Add a Listing")
                       }
                   
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}

struct DashboardItemView: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.headline)
            
            Spacer()
        }
        .padding(.vertical)
    }
}


#Preview {
    DashboardView()
}
