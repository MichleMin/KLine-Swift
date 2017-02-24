
//
//  KBoxView.swift
//  KLineDemo
//

import UIKit

class KBoxView: UIView {
    
    
    var point5: CGPoint?
    var point4: CGPoint?
    var point3: CGPoint?
    var point2: CGPoint?
    
    override func draw(_ rect: CGRect) {
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        context.setShouldAntialias(true)
        
        // 画直线
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor(red: 51/255, green: 62/255, blue: 75/255, alpha: 1).cgColor)
        
        if point5 != nil{
            context.move(to: CGPoint(x: point5!.x, y: 0))
            context.addLine(to: CGPoint(x: point5!.x, y: height))
        }
        if point4 != nil{
            context.move(to: CGPoint(x: point4!.x, y: 0))
            context.addLine(to: CGPoint(x: point4!.x, y: height))
        }
        if point3 != nil{
            context.move(to: CGPoint(x: point3!.x, y: 0))
            context.addLine(to: CGPoint(x: point3!.x, y: height))
        }
        if point2 != nil{
            context.move(to: CGPoint(x: point2!.x, y: 0))
            context.addLine(to: CGPoint(x: point2!.x, y: height))
        }
        context.strokePath()
        
        context.setLineWidth(1)
        context.setStrokeColor(UIColor(red: 83/255, green: 93/255, blue: 106/255, alpha: 1).cgColor)
        context.move(to: CGPoint(x: 0, y: height/4))
        context.addLine(to: CGPoint(x: width, y: height/4))
        
        context.move(to: CGPoint(x: 0, y: height*2/4))
        context.addLine(to: CGPoint(x: width, y: height*2/4))
        
        context.move(to: CGPoint(x: 0, y: height*3/4))
        context.addLine(to: CGPoint(x: width, y: height*3/4))
    
        context.strokePath()
    }
    
}
