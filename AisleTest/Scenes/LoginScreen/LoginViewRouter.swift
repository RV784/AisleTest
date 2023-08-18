//
//  LoginViewRouter.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import UIKit

protocol LoginViewRouterProtocol: AnyObject {
    func presentOTPScreen()
}

final class LoginViewRouter: LoginViewRouterProtocol {
    weak var view: LoginViewController?
    
    static func createModule() -> LoginViewController? {
        let storyBoard = UIStoryboard(name: "LoginViewController", bundle: nil)
        if let vc = storyBoard.instantiateInitialViewController() as? LoginViewController {
            let router = LoginViewRouter()
            router.view = vc
            let interactor = LoginViewInteractor()
            let presenter = LoginViewPresenter(view: vc, interactor: interactor, router: router)
            interactor.presenter = presenter
            vc.presenter = presenter
            
            return vc
        }
        
        return nil
    }
    
    func presentOTPScreen() {
        if let vc = OTPRouter.createModule() {
            view?.navigationController?.present(vc, animated: true)
        }
    }
}
