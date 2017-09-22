//
//  WebViewController.swift
//  Ofo_demo
//
//  Created by 王伟奇 on 17/5/9.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //去除webview顶部的黑条部分代码
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        self.title = "热门活动"
        //网页加载
        let url = URL(string: "http://m.ofo.so/active.html")
        let requst = URLRequest(url: url!)
        webView.loadRequest(requst)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
