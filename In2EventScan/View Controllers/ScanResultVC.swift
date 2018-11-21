//
//  ScanResultVC.swift
//  In2EventScan
//
//  Created by Admin on 3/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class ScanResultVC: UIViewController {

    var barcode: JSON?
    var response: String!
    var message: String!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch self.response {
        case "SUCCESS":
            bgImageView.image = #imageLiteral(resourceName: "bg_success")
            resultImageView.image = #imageLiteral(resourceName: "success")
            break
        case "WARNING":
            bgImageView.image = #imageLiteral(resourceName: "bg_warning")
            resultImageView.image = #imageLiteral(resourceName: "warning")
            break
        case "ERROR":
            bgImageView.image = #imageLiteral(resourceName: "bg_failed")
            resultImageView.image = #imageLiteral(resourceName: "failed")
            break
        default:
            break
        }

        messageLabel.text = message

        if let barcode = self.barcode {
            customerLabel.text = barcode[Contents.Barcode.customer].stringValue
            productLabel.text = barcode[Contents.Barcode.product].stringValue
        }
    }

    @IBAction func onContinue(_ sender: Any) {
        performSegueToReturnBack()
    }
}
