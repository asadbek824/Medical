//
//  RegisterContentView.swift
//  Register
//
//  Created by Asadbek Yoldoshev on 11/14/24.
//

import SwiftUI
import Core

public struct RegisterContentView: View {
    
    @StateObject var vm = RegisterViewModel()
    
    public init() { }
    
    public var body: some View {
        contentView()
            .padding()
            .background(Color.customPalePink) // Основной фон
            .edgesIgnoringSafeArea(.all)
    }
}

extension RegisterContentView {
    
    @ViewBuilder
    func contentView() -> some View {
        VStack {
            Spacer()
            WelcomeView(
                title: vm.userLogin ? "Welcome Back!" : "Welcome!" ,
                description: vm.userLogin ? "Sign in to your account to continue" : "Create an account to continue"
            )
            Spacer()
            VStack(spacing: 30.dpHeight()) {
                if vm.userLogin {
                    VStack(spacing: 30.dpHeight()) {
                        PrimeryTextField(
                            textFiledText: $vm.userEmailTText,
                            keyboardType: .constant(.emailAddress),
                            placeholderText: "E-mail"
                        )
                        
                        SecureTextField(
                            text: $vm.userPasswordText,
                            placeholder: "Password",
                            keyboardType: .default
                        )
                    }
                } else {
                    VStack(spacing: 30.dpHeight()) {
                        if !vm.codeViewPresented {
                            PrimeryTextField(
                                textFiledText: $vm.userFullNameText,
                                keyboardType: .constant(.default1),
                                placeholderText: "Full Name"
                            )
                            
                            PrimeryTextField(
                                textFiledText: $vm.userEmailTText,
                                keyboardType: .constant(.default1),
                                placeholderText: "E-mail"
                            )
                            
                            SecureTextField(
                                text: $vm.userPasswordText,
                                placeholder: "Password",
                                keyboardType: .default
                            )
                        } else {
                            PrimeryTextField(
                                textFiledText: $vm.verifacationCode,
                                keyboardType: .constant(.numberPad),
                                placeholderText: "Code"
                            )
                        }
                    }
                }
                
                ElementaryButton(
                    elementaryButtonText: vm.userLogin ? "Sign In" : "Sign Up",
                    disabled: vm.buttonDesable)
                {
                    if vm.userLogin {
                        vm.signIn()
                    } else {
                        if vm.codeViewPresented {
                            vm.checkCode()
                        } else {
                            vm.codeViewPresented = true
                            vm.sendInfoForBac()
                        }
                    }
                }
                
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        vm.clearAll()
                        vm.userLogin.toggle()
                    }
                } label: {
                    Text(vm.userLogin ? "Create new account" : "Already have an account")
                        .font(.sabFont(600, size: 14))
                        .foregroundColor(.customNavy) // Цвет текста ссылки
                }
            }
            Spacer()
        }
    }
}
