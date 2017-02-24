////
////  PriceLableView.swift
////  KLineDemo
//  Created by min on 16/8/21.
//  Copyright © 2016年 min. All rights reserved.
//

import UIKit

class PortraitPriceLableView: UIView {
    
    var priceLabel1: UILabel!
    var priceLabel2: UILabel!
    var priceLabel3: UILabel!
    var priceLabel4: UILabel!
    var priceLabel5: UILabel!
    var textColor = UIColor(red: 83/255, green: 93/255, blue: 106/255, alpha: 1) // 默认文字颜色
    /** 价格标签数组 */
    var priceLabels: [UILabel] = [UILabel]()
    var font: UIFont = UIFont.systemFont(ofSize: 9)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        priceLabel1 = UILabel(frame: CGRect(x: 3, y: 0, width: width, height: 21))
        priceLabel1.font = font
        priceLabel1.textColor = textColor
        priceLabel1.backgroundColor = UIColor.clear
        priceLabel1.adjustsFontSizeToFitWidth = true
        priceLabel1.text = "----"
        self.addSubview(priceLabel1)
        
        priceLabel2 = UILabel(frame: CGRect(x: 3, y: height/4-21/2, width: width, height: 21))
        priceLabel2.font = font
        priceLabel2.textColor = textColor
        priceLabel2.backgroundColor = UIColor.clear
        priceLabel2.adjustsFontSizeToFitWidth = true
        priceLabel2.text = "----"
        self.addSubview(priceLabel2)
        
        priceLabel3 = UILabel(frame: CGRect(x: 3, y: height*2/4-21/2, width: width, height: 21))
        priceLabel3.font = font
        priceLabel3.textColor = textColor
        priceLabel3.backgroundColor = UIColor.clear
        priceLabel3.adjustsFontSizeToFitWidth = true
        priceLabel3.text = "----"
        self.addSubview(priceLabel3)
        
        priceLabel4 = UILabel(frame: CGRect(x: 3, y: height*3/4-21/2, width: width, height: 21))
        priceLabel4.font = font
        priceLabel4.textColor = textColor
        priceLabel4.backgroundColor = UIColor.clear
        priceLabel4.adjustsFontSizeToFitWidth = true
        priceLabel4.text = "----"
        self.addSubview(priceLabel4)
        
        priceLabel5 = UILabel(frame: CGRect(x: 3, y: height-21/2, width: width, height: 21))
        priceLabel5.font = font
        priceLabel5.textColor = textColor
        priceLabel5.backgroundColor = UIColor.clear
        
        
        
        priceLabel5.adjustsFontSizeToFitWidth = true
        priceLabel5.text = "----"
        self.addSubview(priceLabel5)
        
        self.priceLabels.append(priceLabel5)
        self.priceLabels.append(priceLabel4)
        self.priceLabels.append(priceLabel3)
        self.priceLabels.append(priceLabel2)
        self.priceLabels.append(priceLabel1) 
        
    }
}

class LandscapePriceLableView: UIView {
    
    var priceLabel1: UILabel!
    var priceLabel2: UILabel!
    var priceLabel3: UILabel!
    var priceLabel4: UILabel!
    var textColor = UIColor(red: 83/255, green: 93/255, blue: 106/255, alpha: 1) // 默认文字颜色
    /** 价格标签数组 */
    var priceLabels: [UILabel] = [UILabel]()
    var font: UIFont = UIFont.systemFont(ofSize: 9)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        priceLabel1 = UILabel(frame: CGRect(x: 3, y: -10+3, width: width, height: 21))
        priceLabel1.font = font
        priceLabel1.textColor = textColor
        priceLabel1.backgroundColor = UIColor.clear
        priceLabel1.adjustsFontSizeToFitWidth = true
        priceLabel1.text = "----"
        self.addSubview(priceLabel1)
        
        priceLabel2 = UILabel(frame: CGRect(x: 3, y: height/3-21/2, width: width, height: 21))
        priceLabel2.font = font
        priceLabel2.textColor = textColor
        priceLabel2.backgroundColor = UIColor.clear
        priceLabel2.adjustsFontSizeToFitWidth = true
        priceLabel2.text = "----"
        self.addSubview(priceLabel2)
        
        priceLabel3 = UILabel(frame: CGRect(x: 3, y: height*2/3-21/2, width: width, height: 21))
        priceLabel3.font = font
        priceLabel3.textColor = textColor
        priceLabel3.backgroundColor = UIColor.clear
        priceLabel3.adjustsFontSizeToFitWidth = true
        priceLabel3.text = "----"
        self.addSubview(priceLabel3)
        
        priceLabel4 = UILabel(frame: CGRect(x: 3, y: height-21/2, width: width, height: 21))
        priceLabel4.font = font
        priceLabel4.textColor = textColor
        priceLabel4.backgroundColor = UIColor.clear
        priceLabel4.adjustsFontSizeToFitWidth = true
        priceLabel4.text = "----"
        self.addSubview(priceLabel4)
        
        self.priceLabels.append(priceLabel4)
        self.priceLabels.append(priceLabel3)
        self.priceLabels.append(priceLabel2)
        self.priceLabels.append(priceLabel1)
        
    }
}
