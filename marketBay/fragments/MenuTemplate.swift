//
//  Menu.swift
//  marketBay
//
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI

struct MenuTemplate: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    
    var body: some View {
        HStack {
            // MARK: Logo
            Image(.marketBay)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 125)
            
            Spacer()
            
            Menu {
                // MARK: Root Screens Menu Items
                let rootScreens = appRootManager.rootScreens
                ForEach(rootScreens.indices) { index in
                    if(appRootManager.currentRoot != rootScreens[index].1) {
                        Button {
                            appRootManager.currentRoot = rootScreens[index].1
                        } label: {
                            Text(rootScreens[index].0)
                            Image(systemName: rootScreens[index].2)
                        }
                    }
                }
                
                // MARK: Logout Menu Item
                Button (role:.destructive) {
                    appRootManager.currentRoot = .dashboardView
                } label:{
                    Text("Logout")
                    Image(systemName: "power")
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
