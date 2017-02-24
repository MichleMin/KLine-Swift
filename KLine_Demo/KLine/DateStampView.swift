

//
//  DateStampView.swift
//  KLineDemo
//
//  Created by min on 16/8/22.
//  Copyright © 2016年 min. All rights reserved.
//

import UIKit

class DateStampView: UIView {
    
    var dateLabel1: UILabel!
    var dateLabel2: UILabel!
    var dateLabel3: UILabel!
    var dateLabel4: UILabel!
    var dateLabel5: UILabel!
    var dateLabel6: UILabel!
    let dateWidth: CGFloat = 40
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let font = UIFont.systemFont(ofSize: 10)
        let fontColor = UIColor(red: 83/255, green: 93/255, blue: 106/255, alpha: 1)
        
        let width1 = self.frame.size.height
        let height = self.frame.size.height
        
        dateLabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: dateWidth, height: height))
        dateLabel1.font = font
        dateLabel1.textColor = fontColor
        dateLabel1.text = "--:--"
        self.addSubview(dateLabel1)
        
        dateLabel2 = UILabel(frame: CGRect(x: width1/5, y: 0, width: dateWidth, height: height))
        dateLabel2.font = font
        dateLabel2.textColor = fontColor
        dateLabel2.textAlignment = .center
        dateLabel2.text = "--:--"
        self.addSubview(dateLabel2)
        
        dateLabel3 = UILabel(frame: CGRect(x: width1*2/5, y: 0, width: dateWidth, height: height))
        dateLabel3.font = font
        dateLabel3.textColor = fontColor
        dateLabel3.textAlignment = .center
        dateLabel3.text = "--:--"
        self.addSubview(dateLabel3)
        
        dateLabel4 = UILabel(frame: CGRect(x: width1*3/5, y: 0, width: dateWidth, height: height))
        dateLabel4.font = font
        dateLabel4.textColor = fontColor
        dateLabel4.textAlignment = .center
        dateLabel4.text = "--:--"
        self.addSubview(dateLabel4)
        
        dateLabel5 = UILabel(frame: CGRect(x: width1*4/5, y: 0, width: dateWidth, height: height))
        dateLabel5.font = font
        dateLabel5.textColor = fontColor
        dateLabel5.textAlignment = .center
        dateLabel5.text = "--:--"
        self.addSubview(dateLabel5)
        
        dateLabel6 = UILabel(frame: CGRect(x: self.frame.size.width-dateWidth, y: 0, width:dateWidth, height: height))
        dateLabel6.font = font
        dateLabel6.textColor = fontColor
        dateLabel6.text = "--:--"
        dateLabel6.textAlignment = .right
        self.addSubview(dateLabel6)
        
    }
}
