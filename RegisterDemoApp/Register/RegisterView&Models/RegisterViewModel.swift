//
//  RegisterViewModel.swift
//  Register
//
//  Created by Asadbek Yoldoshev on 11/14/24.
//

import SwiftUI
import Combine
import NetworkManager

final class RegisterViewModel: ObservableObject {
    
    @Published var userFullNameText: String = ""
    @Published var userEmailTText: String = ""
    @Published var userPasswordText: String = ""
    @Published var userLogin: Bool = true
    @Published var buttonDesable: Bool = false
    @Published var codeViewPresented: Bool = false
    @Published var userVerificateCode: Int = -1
    @Published var verifacationCode: String = ""
    @Published var errorMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupButtonDisableBinding()
    }
    
    func sendInfoForBac() {
        let urlString = "https://med-app-w95x.onrender.com/api/auth/signup"
        let body = [
            "fullName": userFullNameText,
            "email": userEmailTText,
            "password": userPasswordText
        ]
        Task.detached {
            do {
                let model = try await NetworkService.shared.request(
                    url: urlString,
                    decode: UserModel.self,
                    method: .post,
                    body: body
                )
                
                await MainActor.run { [weak self] in
                    self?.userVerificateCode = model.confirmationCode
                    UserDefaults.standard.setValue(model.user?._id, forKey: "userId")
                    UserDefaults.standard.setValue(model.user?.isDoctor, forKey: "isDoctor")
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self?.codeViewPresented = true
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func checkCode() {
        let urlString = "https://med-app-w95x.onrender.com/api/auth/verify-code"
        let body: [String : Any] = [
            "email": userEmailTText,
            "enteredCode": Int(verifacationCode) ?? 0,
            "expectedCode": userVerificateCode
        ]
        Task.detached {
            do {
                let _ = try await NetworkService.shared.request(
                    url: urlString,
                    decode: VerificationCodeModel.self,
                    method: .post,
                    body: body
                )
                
                await MainActor.run {
                    UserDefaults.standard.setValue(true, forKey: "isRegistreted")
                }
            } catch {
                await MainActor.run {
                    print(error)
                }
            }
        }
    }
    
    func signIn() {
        let urlString = "https://med-app-w95x.onrender.com/api/auth/signin"
        let body = [
            "email": userEmailTText,
            "password": userPasswordText
        ]
        Task.detached {
            do {
                let model = try await NetworkService.shared.request(
                    url: urlString,
                    decode: VerificationCodeModel.self,
                    method: .post,
                    body: body
                )
                
                await MainActor.run {
                    UserDefaults.standard.setValue(model.user?._id, forKey: "userId")
                    UserDefaults.standard.setValue(model.user?.isDoctor, forKey: "isDoctor")
                    UserDefaults.standard.setValue(true, forKey: "isRegistreted")
                }
            } catch {
                
            }
        }
    }
    
    private func setupButtonDisableBinding() {
        Publishers.CombineLatest3($userFullNameText, $userEmailTText, $userPasswordText)
            .map { [weak self] fullName, email, password in
                guard let self = self else { return true }
                if self.userLogin {
                    return email.isEmpty || password.isEmpty
                } else {
                    return fullName.isEmpty || email.isEmpty || password.isEmpty
                }
            }
            .assign(to: &$buttonDesable)
    }
    
    func clearAll() {
        userFullNameText = ""
        userEmailTText = ""
        userPasswordText = ""
    }
}
