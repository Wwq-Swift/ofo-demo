//
//  UIViewHelper.swift
//  Ofo_demo
//
//  Created by 王伟奇 on 17/5/17.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

//@加的   是特殊属性   这样的属性可以在storyboard 上显示使用   用到了IBInspectable  @IBDesignable用于可视化使用

extension UIView{
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    
}

@IBDesignable class MyPreviewLabel: UILabel{
    
}

import AVFoundation


//设置后置闪光灯的代码  后置闪光灯叫torch  前置闪光灯叫flash   手电筒开关的设置
func turnTorch() {
    //获取设备 
    guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
        return
    }
    
    if device.hasTorch && device.isTorchAvailable{
        
        //锁定设备
        try? device.lockForConfiguration()
        
        if device.torchMode == .off{
            device.torchMode = .on
        } else{
            device.torchMode = .off
        }
        
        //解锁设备
        device.unlockForConfiguration()
    }
    
    
}

func voiceBtnStatus(voiceBtn: UIButton) {
    //本地数据库中的配置文件  提取本地数据库
    let defaults = UserDefaults.standard
    
    if defaults.bool(forKey: "isVoiceOn"){
        voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
    } else{
        
        voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
    }

}








