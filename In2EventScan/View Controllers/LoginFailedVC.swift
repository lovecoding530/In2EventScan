//
//  LoginFailedVC.swift
//  In2EventScan
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class LoginFailedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onTryAgain(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
