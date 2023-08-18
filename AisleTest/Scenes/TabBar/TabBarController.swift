//
//  TabBarController.swift
//  AisleTest
//
//  Created by Rajat Verma on 18/08/23.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    enum MyTabs: Int {
        case discover,
             notes,
             matches,
             profile
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        configureTabBar()
    }
    
    init(selectedTab: MyTabs) {
        super.init(nibName: nil, bundle: nil)
        self.selectedIndex = selectedTab.rawValue
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureTabBar() {
        tabBar.backgroundColor = .clear
        self.delegate = self
        
        tabBar.selectedItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.init(name: "medium", size: 10) as Any], for: .selected)
        tabBar.selectedItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.init(name: "medium", size: 10) as Any], for: .normal)
        tabBar.unselectedItemTintColor = .gray
        tabBar.tintColor = .black

        let storyBoard = UIStoryboard(name: "DummyTabBarScreen", bundle: nil)
        if let discoverSreen = storyBoard.instantiateInitialViewController() {
            let vc = UINavigationController(rootViewController: discoverSreen)
            vc.tabBarItem.image = UIImage(named: "discover_icon")
            vc.tabBarItem.title = "Discover"
            vc.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: 1)
            viewControllers = [vc]
        }
        
        if let notesVC = NotesRouter.createModule() {
            let vc = UINavigationController(rootViewController: notesVC)
            vc.tabBarItem.image = UIImage(named: "notes_icon")
            vc.tabBarItem.title = "Notes"
            vc.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: 1)
            viewControllers?.append(vc)
        }
        
        if let discoverSreen = storyBoard.instantiateInitialViewController() {
            let vc = UINavigationController(rootViewController: discoverSreen)
            vc.tabBarItem.image = UIImage(named: "match_icon")
            vc.tabBarItem.title = "Matches"
            vc.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: 1)
            viewControllers?.append(vc)
        }
        
        if let discoverSreen = storyBoard.instantiateInitialViewController() {
            let vc = UINavigationController(rootViewController: discoverSreen)
            vc.tabBarItem.image = UIImage(named: "profile_icon")
            vc.tabBarItem.title = "Profile"
            vc.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: 1)
            viewControllers?.append(vc)
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
