//
//  ErrorViewController.swift
//  Ofo_demo
//
//  Created by 王伟奇 on 17/5/25.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
import MIBlurPopup

class ErrorViewController: UIViewController {
    @IBAction func gesturetap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    @IBAction func closeBtnTap(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBOutlet weak var myPopupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

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

extension ErrorViewController: MIBlurPopupDelegate{
    var popupView: UIView{
        return myPopupView
    }
    
    var blurEffectStyle: UIBlurEffectStyle{
        return .dark
    }
    var initialScaleAmmount: CGFloat{
        return 0.2
    }
    var animationDuration: TimeInterval{
        return 0.5
    }
    
}










