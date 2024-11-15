//
//  TabBarView.swift
//  Medical
//
//  Created by Asadbek Yoldoshev on 11/14/24.
//

import SwiftUI
import Home
import Core
import AIChat
import DoctorChat

struct TabBarView: View {
    
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home
        case aichat
        case settings
    }
    
    var body: some View {
        contentView()
    }
}

extension TabBarView {
    
    @ViewBuilder
    func contentView() -> some View {
        TabView(selection: $selectedTab) {
            HomeContentView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            AIChatContentView()
                .tabItem {
                    Label("AI Chat", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(Tab.aichat)
            
            DoctorChatContentView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
        .accentColor(Color.customDarkBlue) // Icon color
        .background(Color.customPalePink.edgesIgnoringSafeArea(.all)) // Background color
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
            .foregroundColor(Color.customNavy)
            .background(Color.customLightBlue)
            .edgesIgnoringSafeArea(.all)
    }
}
