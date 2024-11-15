//
//  ContentView.swift
//  Medical
//
//  Created by Asadbek Yoldoshev on 11/14/24.
//

import SwiftUI
import Register

struct ContentView: View {
    
    @AppStorage("isRegistreted") var isRegistreted: Bool = false
    
    var body: some View {
        contentView()
            .onAppear {
                if UserDefaults.standard.object(forKey: "isRegistreted") == nil {
                    UserDefaults.standard.set(false, forKey: "isRegistreted")
                }
            }
    }
}

extension ContentView {
    
    @ViewBuilder
    func contentView() -> some View {
        if isRegistreted {
            TabBarView()
        } else {
            RegisterContentView()
        }
    }
}
