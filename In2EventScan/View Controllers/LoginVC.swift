//
//  LoginVC.swift
//  In2EventScan
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import MBProgressHUD
import SwiftyJSON

class LoginVC: UIViewController {

    @IBOutlet weak var videoPreview: UIView!
    var codescan: CodeScan!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        codescan = CodeScan(videoPreview: videoPreview)
        codescan.delegate = self
        codescan.start()
    }
}

extension LoginVC: CodeScanDelegate {
    func notFoundCode() {
        
    }
    
    func foundCode(content: String){
        codescan.stop()
        print(content)
        
        AppUserDefaults.loginCode = content
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Please Wait"
        
        //sample log in code : 42c3bf79f97a9862fc414e1ed5e43132e21ba6c3b24d71740f23c945328ea884
        
        let lang = Locale.current.languageCode!

        let headers = [
            "X-ACCESS-TOKEN": content,
            "LANG": lang
        ]
        
        let parameters = [
            "access_token": content
        ]
        request(Contents.Api.authorize,
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
                    AppUserDefaults.isLoggedin = true
                    AppUserDefaults.accessToken = json["token"].stringValue

                    AppUserDefaults.eventName = json["event_name"].stringValue
                    AppUserDefaults.eventLogo = json["event_logo"].stringValue
                    AppUserDefaults.eventDates = json["event_dates"].stringValue
                    AppUserDefaults.eventCity = json["event_city"].stringValue

                    self.performSegue(withIdentifier: "success", sender: self)
                case .failure(_):
                    self.performSegue(withIdentifier: "failed", sender: self)
                }
        }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 5 * 60, repeats: true) { (timer) in
            request(Contents.Api.barcodes,
                    method: .get,
                    parameters: nil,
                    encoding: URLEncoding.default,
                    headers: headers)
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("JSON: \(json)")
                        Contents.cachedBarcodes = json.arrayValue
                    case .failure(let error):
                        print("failed: ", error.localizedDescription)
                    }
            }
        }
        timer.fire()
    }
}
