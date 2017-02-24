//
//  Lines.swift
//  KLineDemo
//
//  Created by min on 16/8/19.
//  Copyright © 2016年 min. All rights reserved.
//

import UIKit

class Lines: UIView {
    
    /** 线条起点 */
    var startPoint: CGPoint!
    /** 线条终点 */
    var endPoint: CGPoint!
    /** 多点连线数组 */
    var points: NSArray!
    /** 线条宽度 */
    var lineWidth: CGFloat = 1 // 默认为 1
    /** 线条颜色 */
    var lineColor: String = "#000000" // 默认为白色
    var ma: Int!
    var moveLineOneLableY: CGFloat!
    
    /** 手指按下后显示的两根白色十字线 */
    lazy var moveLineOne: UIView = {
        let _moveLineOne = UIView(frame: CGRect(x: self.frame.size.width/2, y: 0, width: 0.5, height: self.frame.size.height))
        _moveLineOne.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 209/255, alpha: 1)
        _moveLineOne.isHidden = true
        self.addSubview(_moveLineOne)
        self.bringSubview(toFront: _moveLineOne)
        return _moveLineOne
    }()
    lazy var moveLineTwo: UIView = {
        let _moveLineTwo = UIView(frame: CGRect(x: 0, y: self.frame.size.height/2, width: self.frame.size.width, height:1))
        _moveLineTwo.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 209/255, alpha: 1)
        _moveLineTwo.isHidden = true
        self.addSubview(_moveLineTwo)
        self.bringSubview(toFront: _moveLineTwo)
        return _moveLineTwo
    }()
    /** 手指按下后显示的两根白色十字线的焦点*/
    lazy var originImg: UIImageView = {
        var _originImg = UIImageView(frame: CGRect(x: self.moveLineOne.frame.origin.x-5, y: self.moveLineTwo.frame.origin.y-5, width: 10, height: 10))
        _originImg.image = UIImage(named: "原点")
        _originImg.isHidden = true
        self.addSubview(_originImg)
        self.bringSubview(toFront: _originImg)
        return _originImg
    }()
    /** 手指按下后显示的两根白色十字线对应的数据的lable */
    lazy var moveLineOneLable: UILabel = {
        var tempFrame = self.moveLineOne.frame
        tempFrame.size = CGSize(width: 100, height: 12)
        tempFrame.origin.x -= 25
        tempFrame.origin.y += self.moveLineOneLableY
        let _moveLineOneLable = UILabel(frame: tempFrame)
        _moveLineOneLable.font = UIFont.systemFont(ofSize: 9)
        _moveLineOneLable.backgroundColor = UIColor.white
        _moveLineOneLable.textColor = UIColor.black
        _moveLineOneLable.textAlignment = .center
        _moveLineOneLable.text = "-"
        _moveLineOneLable.isHidden = true
        self.addSubview(_moveLineOneLable)
        return _moveLineOneLable
    }()
    lazy var moveLineTwoLable: UILabel = {
        var tempFrame = self.moveLineTwo.frame
        let _moveLineTwoLable = UILabel(frame: CGRect(x: tempFrame.width, y: tempFrame.origin.y-6, width: 60, height: 12))
        _moveLineTwoLable.font = UIFont.systemFont(ofSize: 9)
        _moveLineTwoLable.backgroundColor = UIColor.white
        _moveLineTwoLable.textColor = UIColor.black
        _moveLineTwoLable.textAlignment = .center
        _moveLineTwoLable.text = "-"
        _moveLineTwoLable.isHidden = true
        self.addSubview(_moveLineTwoLable)
        return _moveLineTwoLable
    }()
    
    var lineMA10Points = NSArray()
    var lineMA30Points = NSArray()
    var lineMA60Points = NSArray()
    var vLineMA5Points = NSArray()
    var vLineMA10Points = NSArray()
    var kLinePoints = NSArray()
    var volumePoints = NSArray()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSet()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     *  初始化参数
     */
    func initSet(){
        self.backgroundColor = UIColor.clear
        self.startPoint = self.frame.origin
        self.endPoint = self.frame.origin

    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext() // 获取当前上下文
        // 画各种均线
        if lineMA10Points.count>0{
            self.drawLineWithContext(context: context!,lineWidth: 1,lineColor: "#FFFFFF",points: lineMA10Points)
        }
        
        if lineMA30Points.count>0{
            self.drawLineWithContext(context: context!, lineWidth: 1, lineColor: "#FCFA01",points: lineMA30Points)
        }
        if lineMA60Points.count>0{
            self.drawLineWithContext(context: context!, lineWidth: 1, lineColor: "#1CC80C",points: lineMA60Points)
        }
        
        if vLineMA5Points.count>0{
            self.drawLineWithContext(context: context!,lineWidth: 1,lineColor: "#FFFFFF",points: vLineMA5Points)
        }
        
        if vLineMA10Points.count>0{
            self.drawLineWithContext(context: context!, lineWidth: 1, lineColor: "#FCFA01",points: vLineMA10Points)
        }
        
        
        if kLinePoints.count>0{
            // 画 k 线
            for item in self.kLinePoints{
                // 转换坐标
                let tempItem = item as! NSArray
                var heightPoint,lowPoint,openPoint,closePoint: CGPoint!
                openPoint = CGPointFromString(tempItem.object(at: 0) as! String)
                heightPoint = CGPointFromString(tempItem.object(at: 1) as! String)
                lowPoint = CGPointFromString(tempItem.object(at: 2) as! String)
                closePoint = CGPointFromString(tempItem.object(at: 3) as! String)
                self.drawKWithContext(context: context!, openPoint: openPoint, heightPoint: heightPoint, lowPoint: lowPoint, closePoint: closePoint,width: self.lineWidth)
            }
        }
        
        // 画成交量
        if volumePoints.count>0{
            for item in self.volumePoints{
                // 转换坐标
                let tempItem = item as! NSArray
                var heightPoint,lowPoint,openPoint,closePoint: CGPoint!
                openPoint = CGPointFromString(tempItem.object(at: 0) as! String)
                heightPoint = CGPointFromString(tempItem.object(at: 1) as! String)
                lowPoint = CGPointFromString(tempItem.object(at: 2) as! String)
                closePoint = CGPointFromString(tempItem.object(at: 3) as! String)
                self.drawVolumeWithContext(context: context!, openPoint: openPoint, heightPoint: heightPoint, lowPoint: lowPoint, closePoint: closePoint,width: self.lineWidth)
            }
        }
    }
    
    /**
     *  画连接线
     */
    func drawLineWithContext(context: CGContext,lineWidth: CGFloat,lineColor: String,points: NSArray){
        context.setLineWidth(lineWidth)
        context.setShouldAntialias(true)
        let colorModel = UIColor.RGBWithHexString(color: lineColor as NSString, alpha: self.alpha) // 设置颜色
        context.setStrokeColor(red: CGFloat(colorModel!.R)/255, green: CGFloat(colorModel!.G)/255, blue: CGFloat(colorModel!.B)/255, alpha: self.alpha)
        if self.startPoint == self.endPoint{
            // 定义多个点  画多点连线
            for item in points{
                let currentPoint = CGPointFromString(item as! String)
                if currentPoint.y<self.frame.size.height && currentPoint.y>0{
                    if points.index(of: item) == 0{
                        context.move(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
                        continue
                    }
                    context.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
                    context.strokePath() // 开始画线
                    if points.index(of: item)<points.count{
                        context.move(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
                    }
                }
            }
        }else{
            //定义两个点，画两点连线
            let points = [self.startPoint!,self.endPoint!]
            context.strokeLineSegments(between: points)
        }
        
    }
    
    /**
     *  画一根k线实体
     */
    func drawKWithContext(context: CGContext,openPoint: CGPoint,heightPoint: CGPoint, lowPoint: CGPoint,closePoint: CGPoint,width: CGFloat){
        context.saveGState()
        context.setShouldAntialias(false)
        //根据开盘价和收盘价的坐标来计算，k线是绿色还是红色
        var colorModel1:ColorModel = UIColor.RGBWithHexString(color: "#36E77B", alpha: self.alpha)! //默认设置红色
        // 如果开盘价坐标在收盘价坐标上方 则为绿色 即空
        if openPoint.y>closePoint.y{
            colorModel1 = UIColor.RGBWithHexString(color: "#C61C2C", alpha: self.alpha)! //设置为绿色
        }
        context.setStrokeColor(red: CGFloat(colorModel1.R)/255, green: CGFloat(colorModel1.G)/255, blue: CGFloat(colorModel1.B)/255, alpha: self.alpha)
        // 首先画一个垂直的线包含上影线和下影线
        // 定义两个点 画两点连线
        context.setLineWidth(1) //上下阴影的宽度
        if self.lineWidth <= 2{
            context.setLineWidth(0.5)
        }
        let points = [heightPoint,lowPoint]
        context.strokeLineSegments(between: points) //绘制线段(默认不绘制端点)
        
        //再画中间的实体
        context.setLineWidth(width) //改变线的宽度
        //let halfWidth:CGFloat = 0.0
        //纠正实体的中心点为当前坐标
        let tempOpenPoint = CGPoint(x: openPoint.x ,y: openPoint.y)
        let tempClosePoint = CGPoint(x: closePoint.x,y: closePoint.y)
        //开始画实体
        let points1 = [tempOpenPoint,tempClosePoint]
        context.strokeLineSegments(between: points1) //绘制线段
        
        
        
        context.restoreGState()
    }
    
    /**
     *  画成交量
     */
    func drawVolumeWithContext(context: CGContext,openPoint: CGPoint,heightPoint: CGPoint, lowPoint: CGPoint,closePoint: CGPoint,width: CGFloat){
        context.saveGState()
        context.setShouldAntialias(false)
        //根据开盘价和收盘价的坐标来计算，k线是绿色还是红色
        var colorModel1:ColorModel = UIColor.RGBWithHexString(color: "#36E77B", alpha: self.alpha)! //默认设置红色
        // 如果开盘价坐标在收盘价坐标上方 则为绿色 即空
        if openPoint.y>closePoint.y{
            colorModel1 = UIColor.RGBWithHexString(color: "#C61C2C", alpha: self.alpha)! //设置为绿色
        }
        context.setStrokeColor(red: CGFloat(colorModel1.R)/255, green: CGFloat(colorModel1.G)/255, blue: CGFloat(colorModel1.B)/255, alpha: self.alpha)
        
        //中间的实体
        context.setLineWidth(width) //改变线的宽度
        let halfWidth:CGFloat = 0.0
        //纠正实体的中心点为当前坐标
        var point1 = CGPoint(x: heightPoint.x - halfWidth,y: heightPoint.y)
        let point2 = CGPoint(x: lowPoint.x-halfWidth,y: lowPoint.y)
        if (point2.y-point1.y)<1{
            point1.y = point2.y-1
        }
        //开始画实体
        //print(point1)
        let points = [point1,point2]
        context.strokeLineSegments(between: points) //绘制线段
        
        
        context.restoreGState()
    }
}

// MARK: - 颜色模型
class ColorModel: NSObject{
    var R: UInt32!
    var G: UInt32!
    var B: UInt32!
    var alpha: CGFloat!
}

// MARK: - 16进制转换为RGB模式
extension UIColor{
    static func RGBWithHexString(color: NSString,alpha: CGFloat)->ColorModel?{
        var str = color.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if str.length<6{
            return nil
        }
        if str.hasPrefix("#"){
            str = str.substring(from: 1) as NSString
        }
        if str.hasPrefix("0X"){
            str = str.substring(from: 2) as NSString
        }
        if str.length != 6{
            return nil
        }
        
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        // r
        let rString = str.substring(with: range)
        // g
        range.location = 2
        let gString = str.substring(with: range)
        // b
        range.location = 4
        let bString = str.substring(with: range)
        
        var r: CUnsignedInt = 0,g: CUnsignedInt=0,b: CUnsignedInt=0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        let colorModel = ColorModel()
        colorModel.R = r
        colorModel.G = g
        colorModel.B = b
        colorModel.alpha = alpha
        return colorModel
    }
    
    static func colorWithHexString(color: NSString,alpha: CGFloat)->UIColor{
        let rgb = self.RGBWithHexString(color: color, alpha: alpha)!
        var r: CUnsignedInt = 0,g: CUnsignedInt = 0,b: CUnsignedInt = 0
        r = rgb.R
        g = rgb.G
        b = rgb.B
        let tempAlpha = rgb.alpha
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: tempAlpha!)
    }
}
