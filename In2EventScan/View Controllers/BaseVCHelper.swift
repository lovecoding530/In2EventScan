//
//  BaseVC.swift
//  Spankrr
//
//  Created by Kangtle on 1/17/18.
//  Copyright © 2018 Kangtle. All rights reserved.
//

import UIKit
import SideMenu

class BaseVCHelper : NSObject {

    var menuButton: UIButton!
    var viewController: UIViewController!

    func setupNavigationBar(viewController: UIViewController) {
        self.viewController = viewController
//        self.viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.viewController.navigationController?.navigationBar.shadowImage = UIImage()
//        self.viewController.navigationController?.navigationBar.isTranslucent = true
        self.viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        self.viewController.navigationController?.navigationBar.barTintColor = BACKGROUND_COLOR_1
        
        menuButton = UIButton()
        menuButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        menuButton.imageView?.contentMode = .scaleAspectFit
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 10)
        menuButton.addTarget(self, action: #selector(onPressedMenuButton), for: .touchUpInside)
        
        let menuBarButtonItem = UIBarButtonItem(customView: menuButton)
        self.viewController.navigationItem.leftBarButtonItem = menuBarButtonItem
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Icon-Small"))
        
        let logoItem = UIBarButtonItem(customView: logoImageView)
        
        self.viewController.navigationItem.rightBarButtonItem = logoItem
    }

    @objc func onPressedMenuButton() {
        let sideMenu = SideMenuManager.default.menuLeftNavigationController
        self.viewController.present(sideMenu!, animated: true, completion: nil)
    }
}
