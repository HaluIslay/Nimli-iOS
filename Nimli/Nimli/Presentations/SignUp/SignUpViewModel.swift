//
//  SignUpViewModel.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/03.
//
import Combine
import FirebaseAuth

class SignUpViewModel: ViewModelBase, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isEnableRegisterButton: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isErrorUpperCase: Bool = false
    @Published var isErrorLowerCase: Bool = false
    @Published var isErrorNumber: Bool = false
    @Published var isErrorLength: Bool = false
    let allowedPasswordMinLength = 6
    let registrationAccountUseCase: any RegisterAccountUseCaseProtocol
    init() {
        let repository = AccountRegistrationRepository()
        self.registrationAccountUseCase = RegisterAccountUseCase(repository: repository)
    }
    var isEmailValid: Bool {
        return email.isValidEmail()
    }
    var isPasswordValid: Bool {
        return !password.isEmpty && !isErrorUpperCase && !isErrorLowerCase && !isErrorNumber && !isErrorLength
    }
    func getErrorMessage() -> String {
        return ""
        // TODO: implement
    }
    func sendEmailAuthentucationCode() async {
        let repository = AccountRegistrationRepository()
        let xxxx  = RegisterAccountUseCase(repository: repository)
        do {
            _ = try await xxxx.execute(request: RegistrationAccount(email: email, password: password))
            return
        } catch {
            // TODO: handle errors
        }
    }
    func onEmailDidChange() {
        updateRegisterButtonAvailability()
    }
    func onPasswordDidChange() {
        updatePasswordAvailability(password)
        updateRegisterButtonAvailability()
    }
    private func updatePasswordAvailability(_ password: String) {
        isErrorUpperCase = !(password.contains(where: { $0.isUppercase }))
        isErrorLowerCase = !(password.contains(where: { $0.isLowercase }))
        isErrorNumber = !(password.contains(where: { $0.isNumber }))
        isErrorLength = password.count < allowedPasswordMinLength
    }
    private func updateRegisterButtonAvailability() {
        isEnableRegisterButton = isEmailValid && isPasswordValid
    }
}
