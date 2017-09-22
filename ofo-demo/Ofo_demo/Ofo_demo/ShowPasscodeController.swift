//
//  ShowPasscodeController.swift
//  Ofo_demo
//
//  Created by 王伟奇 on 17/5/17.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
import SwiftyTimer
import SwiftySound

class ShowPasscodeController: UIViewController {
    @IBOutlet weak var label1st: MyPreviewLabel!
    @IBOutlet weak var label2rd: UILabel!
    @IBOutlet weak var label3rd: UILabel!
    @IBOutlet weak var label4th: UILabel!
    
    
    var code = ""
    
    //加了大括号代表属性监视器
    var passArray: [String] = []
    
    //本地数据库中的配置文件  提取本地数据库
    let defaults = UserDefaults.standard
    
    
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBAction func reportBtnTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var torchBtn: UIButton!
    
    var isTorchOn = false
    @IBAction func torchBtnTap(_ sender: UIButton) {
        turnTorch()
        
        if isTorchOn {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch"), for: .normal)
        } else {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch"), for: .normal)
        }
        
        isTorchOn = !isTorchOn
    }
    
    var remindTimeSecond = 120
    
    var isVoiceOn = true
    
    @IBOutlet weak var voiceBtn: UIButton!
    @IBAction func voiceBtnTap(_ sender: UIButton) {
        if isVoiceOn {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
            defaults.set(true, forKey: "isVoiceOn")
            
        } else {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
            defaults.set(false, forKey: "isVoiceOn")
        }
        isVoiceOn = !isVoiceOn
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.every(1) { (timer: Timer) in
            self.remindTimeSecond -= 1
            print(self.remindTimeSecond)
            
            //description 数值转字符串
            self.countDownLabel.text = self.remindTimeSecond.description
            
            //当倒计时到0 停止计时间
            if self.remindTimeSecond == 0{
                timer.invalidate()
            }
        }
        
        if defaults.bool(forKey: "isVoiceOn"){
            Sound.play(file: "骑行结束_LH.m4a")
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
        } else{
            
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
        }
        
        self.label1st.text = passArray[0]
        self.label2rd.text = passArray[1]
        self.label3rd.text = passArray[2]
        self.label4th.text = passArray[3]
        
        

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
