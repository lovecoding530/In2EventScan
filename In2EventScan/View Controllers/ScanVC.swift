//
//  ScanVC.swift
//  In2EventScan
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON

class ScanVC: UIViewController {

    let baseVCHelper = BaseVCHelper()
    @IBOutlet weak var videoPreview: UIView!

    var codescan: CodeScan!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        baseVCHelper.setupNavigationBar(viewController: self)
        
        codescan = CodeScan(videoPreview: videoPreview)
        codescan.delegate = self
        codescan.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        codescan.start()
    }
}

extension ScanVC: CodeScanDelegate {
    func foundCode(content: String) {
        print(content)

        codescan.stop()
        
        //sample log in code : 42c3bf79f97a9862fc414e1ed5e43132e21ba6c3b24d71740f23c945328ea884

        let headers = [
            "X-ACCESS-TOKEN": AppUserDefaults.accessToken
        ]
        
        let parameters = [
            "barcode": content
        ]
        
        if Connectivity.isConnectedToInternet {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "Please Wait"
            
            request(Contents.Api.barcodes,
                    method: .post,
                    parameters: parameters,
                    encoding: URLEncoding.default,
                    headers: headers)
                .validate()
                .responseJSON { (response) in
                    
                    hud.hide(animated: true)
                    
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("JSON: \(json)")
                        
                        let isSuccess = json[Contents.Barcode.success].boolValue
                        let message = json[Contents.Barcode.message].stringValue

                        Contents.scannedBarcodes.append(content)
                        self.gotoResultVC(isSeccess: isSuccess, message: message, barcodeJson: json)
                        
                    case .failure(let error):
                        print("Error:", error.localizedDescription)
                        
                        self.gotoResultVC(isSeccess: false, message: "An error happens", barcodeJson: nil)
                    }
            }
        }else{
            if Contents.scannedBarcodes.contains(content) {
                gotoResultVC(isSeccess: false, message: "Barcode already scanned", barcodeJson: nil)
            }else{
                let indexOfCache = Contents.cachedBarcodes.index(where: {$0[Contents.Barcode.barcode].stringValue == content})
                if indexOfCache != nil {
                    
                    let json = Contents.cachedBarcodes.remove(at: indexOfCache!)
                    AppUserDefaults.queuedBarcodes.append(content)
                    
                    gotoResultVC(isSeccess: true, message: "Successfully scanned", barcodeJson: json)
                }else{
                    gotoResultVC(isSeccess: false, message: "Barcode not found", barcodeJson: nil)
                }
            }
        }
    }
    
    func gotoResultVC(isSeccess: Bool, message: String, barcodeJson: JSON?) {
        let resultVC = STORYBOARD.instantiateViewController(withIdentifier: "ScanResultVC") as! ScanResultVC
        resultVC.isSuccess = isSeccess
        resultVC.message = message
        resultVC.barcode = barcodeJson
        self.navigationController?.show(resultVC, sender: self)
    }
    
    func notFoundCode() {
        
    }
}
