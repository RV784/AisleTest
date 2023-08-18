//
//  NotesRouter.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import UIKit

protocol NotesRouterProtocol: AnyObject {
    
}

final class NotesRouter: NotesRouterProtocol {
    weak var view: NotesViewController?
    
    static func createModule() -> NotesViewController? {
        let storyBoard = UIStoryboard(name: "NotesViewController", bundle: nil)
        if let vc = storyBoard.instantiateInitialViewController() as? NotesViewController {
            let router = NotesRouter()
            router.view = vc
            let interactor = NotesInteractor()
            let presenter = NotesPresenter(view: vc, interactor: interactor, router: router)
            
            vc.presenter = presenter
            interactor.presenter = presenter
            
            return vc
        }
        
        return nil
    }
}
