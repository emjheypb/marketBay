//
//  marketBayApp.swift
//  marketBay
//
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@main
struct marketBayApp: App {
    @StateObject private var appRootManager = AppRootManager()
    @StateObject private var dataAccess = DataAccess()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .favoritesView:
                    FavoritesView()
                case .registrationView:
                    RegistrationView()
                case .myPostsView:
                    MyPostsView()
                case .profileView:
                    ProfileView()
                case .marketplaceView:
                    MarketplaceView()
                default:
                    DashboardView()
                }
            }
            .environmentObject(appRootManager).environmentObject(dataAccess)
        }
    }
}
