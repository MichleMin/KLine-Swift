//
//  VolumeBoxView.swift
//  KLineDemo
//
//  Created by min on 16/8/21.
//  Copyright © 2016年 min. All rights reserved.
//

import UIKit

class VolumeBoxView: UIView {
    
    var point5: CGPoint!
    var point4: CGPoint!
    var point3: CGPoint!
    var point2: CGPoint!
    
    override func draw(_ rect: CGRect) {
        
        let height = self.frame.size.height
        
        let context = UIGraphicsGetCurrentContext()
        context!.setShouldAntialias(true)
        
        // 画直线
        context!.setLineWidth(0.5)
        context!.setStrokeColor(UIColor(red: 83/255, green: 93/255, blue: 106/255, alpha: 1).cgColor)
        
        if point5 != nil{
            context?.move(to: CGPoint(x: point5!.x, y: 0))
            context?.addLine(to: CGPoint(x: point5!.x, y: height))
        }
        
        if point4 != nil{
            context?.move(to: CGPoint(x: point4!.x, y: 0))
            context?.addLine(to: CGPoint(x: point4!.x, y: height))
        }
        if point3 != nil{
            context?.move(to: CGPoint(x: point3!.x, y: 0))
            context?.addLine(to: CGPoint(x: point3!.x, y: height))
        }
        if point2 != nil{
            context?.move(to: CGPoint(x: point2!.x, y: 0))
            context?.addLine(to: CGPoint(x: point2!.x, y: height))
        }
        
        context!.strokePath()
    }
    
}
