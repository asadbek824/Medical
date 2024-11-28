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
    
    @State var newDoctor: NewDoctor = NewDoctor(
        imageName: "doctor1",
        name: "Dr. Bellamy Nicholas",
        rating: 4.5,
        reviews: 135,
        specialty: "Virologist",
        aboutDoctor: "Dr. Bellamy Nicholas is a top specialist at London Bridge Hospital in London. He has achieved several awards and recognition for his contributions and service in the field of virology. He is available for private consultation."
    )
    
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
            TabBarView(newDoctor: newDoctor)
        } else {
            RegisterContentView()
        }
    }
}
