//
//  ScanViewController.swift
//  Ofo_demo
//
//  Created by 王伟奇 on 17/5/12.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
import swiftScan
import FTIndicator

class ScanViewController: LBXScanViewController {
    @IBOutlet weak var panelView: UIView!
    @IBAction func flashBtnTap(_ sender: UIButton) {
        isFlashOn = !isFlashOn
        
        //改变闪光灯状态  开启或者关闭
        scanObj?.changeTorch()
        
        //闪光灯按钮切换背景图片
        if isFlashOn {
            flashBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch_w"), for: .normal)
        } else {
            flashBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch_w"), for: .normal)
        }
    }
    @IBOutlet weak var flashBtn: UIButton!
    
    var isFlashOn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "扫码用车"
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
        //自定义扫描样式，   要去库源码里找  然后怎么使用
        var style = LBXScanViewStyle()
        style.anmiationStyle = .NetGrid
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net")
        
        scanStyle = style
        
               // Do any additional setup after loading the view.
    }
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        if let result = arrayResult.first{
            let msg = result.strScanned
            
            FTIndicator.setIndicatorStyle(.dark)
            FTIndicator.showToastMessage(msg)
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //把面板视图在视图展现完成之后 放到视图的最上层
        view.bringSubview(toFront: panelView)
        

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.black
        
        //使下一个页面的返回按钮的标题为空   在当前页面消失时候去除标题
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
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
