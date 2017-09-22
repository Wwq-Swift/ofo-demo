//
//  InputController.swift
//  Ofo_demo
//
//  Created by 王伟奇 on 17/5/16.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
import APNumberPad

class InputController: UIViewController,APNumberPadDelegate,UITextFieldDelegate {
    var isFlashON = false
    var isVoiceOn = true
    //本地数据库中的配置文件  提取本地数据库
    let defaults = UserDefaults.standard
    
    
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var voiceBtn: UIButton!
    @IBAction func goBtnTap(_ sender: UIButton) {
        checkPass()
    }
    
    
    @IBAction func flashBtnTap(_ sender: Any) {
        isFlashON = !isFlashON
        
        if isFlashON {
            flashBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch"), for: .normal)
        } else {
            flashBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch"), for: .normal)
        }
    }
    @IBAction func voiceBtnTap(_ sender: Any) {
        isVoiceOn = !isVoiceOn
        
        if isVoiceOn {
            
            defaults.set(true, forKey: "isVoiceOn")
            
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
        } else {
            defaults.set(false, forKey: "isVoiceOn")
            
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        goBtn.isEnabled = false
        //设置navigationbar的标题
        title = "车辆解锁"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫码用车", style: .plain, target: self, action: #selector(backToScan))
        
        //设置inputTextField的运行时的layer属性   边框 和颜色
        inputTextField.layer.borderWidth = 2
        inputTextField.layer.borderColor = UIColor(red: 247/255, green: 215/255, blue: 80/255, alpha: 1).cgColor
        

        // Do any additional setup after loading the view.
        
        //设置自定义键盘 并和inputtextfield进行绑定，   用到第三方库apnumberPad
        let numberPad = APNumberPad(delegate: self)
        numberPad.leftFunctionButton.setTitle("确定", for: .normal)
        inputTextField.inputView = numberPad
        inputTextField.delegate = self
        
        voiceBtnStatus(voiceBtn: voiceBtn)
        
                
    }
    
    // 自定义键盘   左边按键的代理
    func numberPad(_ numberPad: APNumberPad, functionButtonAction functionButton: UIButton, textInput: UIResponder) {
        checkPass()
        
        
    }
    
    //为text设置代理  range表示被替换删除的字符串   string 是要替换的字符串   从而进行规定文本框只允许输入8个字符
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let newLength = text.characters.count + string.characters.count - range.length
        
        if newLength > 0 {
            goBtn.setImage(#imageLiteral(resourceName: "nextArrow_enable"), for: .normal)
            goBtn.backgroundColor = UIColor.ofo
            
            //当文本框有值的时候才可 点击gobtn按键
            goBtn.isEnabled = true
        } else {
            
            
            goBtn.setImage(#imageLiteral(resourceName: "nextArrow_unenable"), for: .normal)
            goBtn.backgroundColor = UIColor.groupTableViewBackground
            
            goBtn.isEnabled = false
        }
        return newLength <= 8
        
    }
    
    
    func backToScan() {
        //当前页面弹出栈 用pop   压入栈 用push
        navigationController!.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var passArray: [String] = []
    
    func checkPass(){
        
        if !inputTextField.text!.isEmpty {
            
            let code = inputTextField.text!
            
            NetWorkHelper.getPass(code: code, completion: { (pass) in
                if let pass = pass{
                    //这边map  把字符串中的每个字符提出
                    self.passArray = pass.characters.map{
                        
                    return $0.description
                    }
                    
                    //页面的跳转  用到performSefue
                    self.performSegue(withIdentifier: "showPasscode", sender: self)
                    
                    
                } else{
                    self.performSegue(withIdentifier: "showErrorView", sender: self)
                }
            })
            
            //          NetWorkHelper.getPass(code: <#T##Int#>, completion: <#T##(String) -> Void#>)
            
            
            
        }

    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPasscode" {
            let destVc = segue.destination as! ShowPasscodeController
//            let code = inputTextField.text!
            destVc.passArray = self.passArray
      //      destVc.code = code
            
          
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
