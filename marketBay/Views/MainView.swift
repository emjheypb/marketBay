//
//  MainView.swift
//  marketBay
//
//  Created by EmJhey PB on 3/11/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var appRootManager = AppRootManager()
    @StateObject private var fireAuthHelper = FireAuthHelper()
    
    private let sellingFireDBHelper = SellingFireDBHelper.getInstance()
    private let authFireDBHelper = AuthenticationFireDBHelper.getInstance()
    
    var body: some View {
        NavigationStack {
            // MARK: Menu
            HStack {
                // MARK: Logo
                Image(.marketBay)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125)
                
                Spacer()
                
                Menu {
                    // MARK: Login Menu Item
                    // show if user is not logged in
                    if(fireAuthHelper.user == nil) {
                        NavigationLink(destination: LoginView().environmentObject(authFireDBHelper).environmentObject(fireAuthHelper).environmentObject(appRootManager)) {
                            Text("Login")
                            Image(systemName: "lock.fill")
                        }
                        .onAppear() {
                            fireAuthHelper.listenToAuthState()
                        }
                        .onDisappear() {
                            fireAuthHelper.removeAuthStateListener()
                        }
                    }
                    
                    // MARK: Root Screens Menu Items
                    let rootScreens = appRootManager.rootScreens
                    ForEach(rootScreens.indices) { index in
                        if (appRootManager.currentRoot != rootScreens[index].1) {
                            if(fireAuthHelper.user != nil) {
                                // change Root View
                                Button {
                                    appRootManager.currentRoot = rootScreens[index].1
                                } label: {
                                    Text(rootScreens[index].0)
                                    Image(systemName: rootScreens[index].2)
                                }
                            } else {
                                // navigate to LoginView
                                NavigationLink(destination: LoginView(selectedPage: rootScreens[index].1).environmentObject(authFireDBHelper).environmentObject(fireAuthHelper).environmentObject(appRootManager)) {
                                    Text(rootScreens[index].0)
                                    Image(systemName: rootScreens[index].2)
                                }
                            }
                        }
                    }
                    
                    // MARK: Logout Menu Item
                    if(fireAuthHelper.user != nil) {
                        Button (role:.destructive) {
                            authFireDBHelper.removeListener()
                            fireAuthHelper.signOut()
                        } label:{
                            Text("Logout")
                            Image(systemName: "power")
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                }
            }
            .padding([.top, .leading, .trailing])
            .onAppear() {
                sellingFireDBHelper.getAll()
            }
            
            // MARK: Root Screens
            switch appRootManager.currentRoot {
            case .favoritesView:
                FavoritesView()
            case .registrationView:
                RegistrationView()
            case .myPostsView:
                MyPostsView()
                    .environmentObject(sellingFireDBHelper)
                    .environmentObject(authFireDBHelper)
            case .profileView:
                ProfileView()
            case .marketplaceView:
                MarketplaceView()
                    .environmentObject(sellingFireDBHelper)
            default:
                DashboardView()
            }
        }
    }
}
