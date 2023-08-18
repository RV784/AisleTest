//
//  LaunchScreenViewController.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import UIKit

class LaunchScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        
        // Here check if token is there in userDefaults
        // if yes, go directly to tab bar else go to login screen flow
        if let token = LocalStorage.shared.authToken,
           !token.isEmpty {
            keyWindow?.rootViewController = TabBarController(selectedTab: .notes)
        } else if let vc = LoginViewRouter.createModule() {
            keyWindow?.rootViewController = UINavigationController(rootViewController: vc)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
