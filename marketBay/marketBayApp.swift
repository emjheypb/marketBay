//
//  marketBayApp.swift
//  marketBay
//
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI

@main
struct marketBayApp: App {
    @StateObject private var appRootManager = AppRootManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .loginView:
                    LoginView()
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
            .environmentObject(appRootManager)
        }
    }
}
