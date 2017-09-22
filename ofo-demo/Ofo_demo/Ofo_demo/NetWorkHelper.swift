//
//  NetWorkHelper.swift
//  Ofo_demo
//
//  Created by 王伟奇 on 17/5/23.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import AVOSCloud


struct NetWorkHelper {
    
}

extension NetWorkHelper{
    static func getPass(code: String , completion: @escaping (String?) -> Void){
        let query = AVQuery(className: "Code")
        
        query.whereKey("code", equalTo: code)
        
        query.getFirstObjectInBackground { (code, e) in
            if let error = e{
                print("出错",error.localizedDescription)
                completion(nil)
            }
            
            if let code = code, let pass = code["pass"] as? String {
                completion(pass)
            }
        }
    }
}
