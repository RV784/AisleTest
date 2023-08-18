//
//  OTPRouter.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import UIKit

protocol OTPRouterProtocol: AnyObject {
    func gotoTabBar()
    func popViewController()
}

final class OTPRouter {
    weak var view: OTPViewController?
    
    static func createModule(isRenewFlow: Bool = false) -> OTPViewController? {
        let storyBoard = UIStoryboard(name: "OTPViewController", bundle: nil)
        if let vc = storyBoard.instantiateInitialViewController() as? OTPViewController {
            let interactor = OTPInteractor(isRenewFlow: isRenewFlow)
            let router = OTPRouter()
            router.view = vc
            let presenter = OTPPresenter(view: vc, interactor: interactor, router: router)
            vc.presenter = presenter
            interactor.presenter = presenter
            
            return vc
        }
        
        return nil
    }
}

// MARK: OTPRouterProtocol
extension OTPRouter: OTPRouterProtocol {
    func gotoTabBar() {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        keyWindow?.rootViewController = TabBarController(selectedTab: .notes)
    }
    
    func popViewController() {
        view?.navigationController?.popViewController(animated: true)
    }
}


