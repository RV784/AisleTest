//
//  OTPPresenter.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import Foundation

protocol OTPPresenterProtocol: AnyObject {
    func verifyOTP(otp: String?)
    func showLoading()
    func hideLoading()
    func showGenericAlert()
    func gotoTabBar()
    func popViewController()
}

final class OTPPresenter {
    weak var view: OTPViewProtocol?
    var interactor: OTPInteractorProtocol?
    var router: OTPRouterProtocol?
    
    init(
        view: OTPViewProtocol,
        interactor: OTPInteractorProtocol,
        router: OTPRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: OTPPresenterProtocol
extension OTPPresenter: OTPPresenterProtocol {
    
    func verifyOTP(otp: String?) {
        guard let otp = otp,
              !otp.isEmpty else {
            view?.showAlert(with: "Please enter OTP to continue")
            return
        }
        
        interactor?.verifyOTP(otp: otp)
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
    
    func gotoTabBar() {
        router?.gotoTabBar()
    }
    
    func popViewController() {
        router?.popViewController()
    }
}
