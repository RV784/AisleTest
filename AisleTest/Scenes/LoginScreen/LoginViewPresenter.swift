//
//  LoginViewPresenter.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import Foundation

protocol LoginViewPresenterProtocol: AnyObject {
    func checkForError(code: String?, number: String?)
    func showLoading()
    func hideLoading()
    func showGenericAlert()
    func gotoOTPScreen()
}

final class LoginViewPresenter: LoginViewPresenterProtocol {
    weak var view: LoginViewProtocol?
    var router: LoginViewRouterProtocol?
    var interactor: LoginViewInteractorProtocol?
    
    init(
        view: LoginViewProtocol,
        interactor: LoginViewInteractorProtocol,
        router: LoginViewRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func checkForError(code: String?, number: String?) {
        guard let code = code,
              let number = number,
              !code.isEmpty,
              !number.isEmpty else {
            view?.showAlert(with: "Country code and Phone number cannot be empty")
            return
        }
        
        if number.count < 10 || number.count > 12 {
            view?.showAlert(with: "Please enter a valid phone numer")
            return
        }
        
        addNumberToLocalStorage(number: number, code: code)
        interactor?.sendPhoneRequest()
    }
    
    func showLoading() {
        view?.showLoading()
    }
    
    func hideLoading() {
        view?.hideLoading()
    }
    
    func showGenericAlert() {
        view?.showGenericAlert()
    }
    
    func gotoOTPScreen() {
        router?.presentOTPScreen()
    }
    
    private func addNumberToLocalStorage(number: String, code: String) {
        LocalStorage.shared.userNumber = number
        LocalStorage.shared.countryCode = code
    }
}
