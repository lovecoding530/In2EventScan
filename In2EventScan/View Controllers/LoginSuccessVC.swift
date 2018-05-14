//
//  LoginSuccessVC.swift
//  In2EventScan
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class LoginSuccessVC: UIViewController {

    @IBOutlet weak var eventLogoImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventCityDatesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        eventLogoImageView.makeCircularView()
        
        let url = URL(string: AppUserDefaults.eventLogo)
        eventLogoImageView.downloadedFrom(url: url!)
        
        eventNameLabel.text = AppUserDefaults.eventName
        eventCityDatesLabel.text = "\(AppUserDefaults.eventCity) - \(AppUserDefaults.eventDates)"
    }
    
    @IBAction func onStartScan(_ sender: Any) {
        let scanVC = STORYBOARD.instantiateViewController(withIdentifier: "ScanVC") as! ScanVC
        
    }
    
}
