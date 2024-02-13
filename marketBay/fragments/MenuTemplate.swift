//
//  Menu.swift
//  marketBay
//  Menu fragment for root views - redirect user to login screen is not logged in
//
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI

struct MenuTemplate: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject var dataAccess: DataAccess
    
    var body: some View {
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
                if(!dataAccess.isLoggedIn) {
                    NavigationLink(destination: LoginView().environmentObject(dataAccess).environmentObject(appRootManager)) {
                        Text("Login")
                        Image(systemName: "lock.fill")
                    }
                }
                
                // MARK: Root Screens Menu Items
                let rootScreens = appRootManager.rootScreens
                ForEach(rootScreens.indices) { index in
                    if (appRootManager.currentRoot != rootScreens[index].1) {
                        if(dataAccess.isLoggedIn) {
                            // change Root View
                            Button {
                                appRootManager.currentRoot = rootScreens[index].1
                            } label: {
                                Text(rootScreens[index].0)
                                Image(systemName: rootScreens[index].2)
                            }
                        } else {
                            // navigate to LoginView
                            NavigationLink(destination: LoginView(selectedPage: rootScreens[index].1).environmentObject(dataAccess).environmentObject(appRootManager)) {
                                Text(rootScreens[index].0)
                                Image(systemName: rootScreens[index].2)
                            }
                        }
                    }
                }
                
                // MARK: Logout Menu Item
                if(dataAccess.isLoggedIn) {
                    Button (role:.destructive) {
                        dataAccess.logout()
                        appRootManager.currentRoot = appRootManager.homePage
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
    }
}
