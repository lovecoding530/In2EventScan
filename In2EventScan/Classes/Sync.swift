//
//  Sync.swift
//  In2EventScan
//
//  Created by Admin on 3/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Sync {
    func syncCachedBarcodes() {
        let cachedBarcodes = AppUserDefaults.queuedBarcodes
        for barcode in cachedBarcodes {
            
            let headers = [
                "X-ACCESS-TOKEN": AppUserDefaults.accessToken
            ]
            
            let parameters = [
                "barcode": barcode
            ]
            
            request(Contents.Api.barcodes,
                    method: .post,
                    parameters: parameters,
                    encoding: URLEncoding.default,
                    headers: headers)
                .validate()
                .responseJSON { (response) in
                    
                    if let index = AppUserDefaults.queuedBarcodes.index(of: barcode) {
                        AppUserDefaults.queuedBarcodes.remove(at: index)
                    }

                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("Sync JSON: \(json)")
                    case .failure(let error):
                        print("Sync Error:", error.localizedDescription)
                    }
            }
        }
    }
}
