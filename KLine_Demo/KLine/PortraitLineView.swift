//
//  PortraitLineView.swift
//  KLineDemo
//
//  Created by Min on 2016/11/29.
//  Copyright © 2016年 cdu.com. All rights reserved.
//

import UIKit

class PortraitLineView: UIView {
    
    /** 传入获取的k线数据 */
    open var allDatas: Array<DataModel>?
    /** 背景主题默认颜色 */
    open var backgroundTitleColor = UIColor(red: 41/255, green: 44/255, blue: 52/255, alpha: 1)
    /** 字体默认颜色 */
    open var textColor = UIColor(red: 83/255, green: 93/255, blue: 106/255, alpha: 1)
    /** k线图控件 */
    private var kBoxView: KBoxView!
    /** 成交量控件 */
    private var volumeBoxView: VolumeBoxView!
    /** 价格标签试图 */
    private var priceLabelView: PortraitPriceLableView!
    /** 时间轴标签试图 */
    private var dateStampView: DateStampView!
    /** 成交量标签 */
    private var volumMaxValueLabel: UILabel!
    private var volumAverValueLabel: UILabel!
    private var volumZeroValueLabel: UILabel!
    private var kvolumeView: UIView!
    private var containerView: UIView!
    /// 某个时刻的价格
    /** 开盘价 */
    private var tOpenPriceLab: UILabel!
    /** 最高价 */
    private var tHighPriceLab: UILabel!
    /** 最低价 */
    private var tLowPriceLab: UILabel!
    /** 收盘价 */
    private var tClosePriceLab: UILabel!
    /** k线10日均线 */
    private var kMA5Lab: UILabel!
    /** k线30日均线 */
    private var kMA30Lab: UILabel!
    /** k线60日均线 */
    private var kMA60Lab: UILabel!
    /** 成交量 */
    private var tVolumLab: UILabel!
    /** 成交量50日均线 */
    private var vMA5Lab: UILabel!
    /**成交量10日均线 */
    private var vMA10Lab: UILabel!
    /** 默认字体大小 */
    let font: UIFont = UIFont.systemFont(ofSize: 9)
    
    /** k线所有坐标数组 */
    private var pointArray: NSMutableArray!
    /** k线的宽度，默认为3*/
    private var kLineWidth: CGFloat = 4
    /** k线的最大宽度 */
    private var kLineMaxWidth: CGFloat = 20
    /** k线的最小宽度 */
    private var kLineMinWidth: CGFloat = 2
    /** k线之间的间隔 */
    private var kLinePadding: CGFloat = 1
    /** 分时 */
    var period: String = "001"
    /** 当前界面数据 */
    private var datas: Array<DataModel>?
    private var lastPrice: Double!
    private var lastMaxValue: Double?
    private var lastMinValue: Double?
    /** 画线View */
    private var lines: Lines?
    private var range: NSRange!
    private var location: Int = 1
    private var kLineCount: Int = 0
    /** 记录上次放大手势的倍数*/
    private var lastPinScale: CGFloat = 0
    /** 记录点击的位置 */
    private var touchViewPoint: CGPoint?
    /** 是否正在拖动 */
    private var isPanGesture = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFrame()
        // 添加手指捏合手势，放大或缩小k线图
        let pinGesture = UIPinchGestureRecognizer(target: self, action: #selector(PortraitLineView.touchBoxAction(pinGesture:)))
        self.kvolumeView.addGestureRecognizer(pinGesture)
        // 添加手指滑动
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(PortraitLineView.panGestureAction(gesture:)))
        panGesture.maximumNumberOfTouches = 1
        self.kvolumeView.addGestureRecognizer(panGesture)
        // 添加手指点击，生成十字线
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PortraitLineView.tapGestureAction(gesture:)))
        self.kvolumeView.addGestureRecognizer(tapGesture)
        DealData.shareInstance.getDataBlock = { [unowned self](resultData) in
            self.allDatas = resultData
            if self.lines != nil{
                self.lines!.removeFromSuperview()
                self.lines = nil
            }
            self.lines = Lines(frame: CGRect(x: 0, y: 0, width: self.kvolumeView.frame.size.width, height: self.kvolumeView.frame.size.height))
            self.kvolumeView.addSubview(self.lines!)
            self.lines!.moveLineOneLableY = self.kBoxView.frame.size.height+4
            self.kLineCount = Int(self.kvolumeView.frame.size.width/(self.kLineWidth+self.kLinePadding))
            self.location = resultData.count-self.kLineCount
            self.range = NSMakeRange(self.location, self.kLineCount)
            self.changeMaxAndMinValue(data: resultData,range: self.range)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        if allDatas != nil{
            self.clearsContextBeforeDrawing = true
            changeMaxAndMinValue(data: allDatas!, range: self.range)
            
            
            
            self.lines!.setNeedsDisplay()
        }
    }
    
    // 初始化View
    func initFrame(){
        self.backgroundColor = backgroundTitleColor
        kBoxView = KBoxView()
        kBoxView.backgroundColor = backgroundTitleColor
        self.addSubview(kBoxView)
        kBoxView.translatesAutoresizingMaskIntoConstraints = false
        let leftKBoxView = NSLayoutConstraint(item: kBoxView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let rightKBoxView = NSLayoutConstraint(item: kBoxView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -50)
        let bottomKBoxView = NSLayoutConstraint(item: kBoxView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 0.68, constant: 0)
        let topKBoxView = NSLayoutConstraint(item: kBoxView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        self.addConstraints([leftKBoxView,rightKBoxView,bottomKBoxView,topKBoxView])
        
        
        volumeBoxView = VolumeBoxView()
        volumeBoxView.backgroundColor = backgroundTitleColor
        self.addSubview(volumeBoxView)
        volumeBoxView.translatesAutoresizingMaskIntoConstraints = false
        let leftvolumeBoxView = NSLayoutConstraint(item: volumeBoxView, attribute: .left, relatedBy: .equal, toItem: kBoxView, attribute: .left, multiplier: 1, constant: 0)
        let rightvolumeBoxView = NSLayoutConstraint(item: volumeBoxView, attribute: .right, relatedBy: .equal, toItem: kBoxView, attribute: .right, multiplier: 1, constant: 0)
        let bottomvolumeBoxView = NSLayoutConstraint(item: volumeBoxView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let topvolumeBoxView = NSLayoutConstraint(item: volumeBoxView, attribute: .top, relatedBy: .equal, toItem: kBoxView, attribute: .bottom, multiplier: 1, constant: 25)
        self.addConstraints([leftvolumeBoxView,rightvolumeBoxView,topvolumeBoxView,bottomvolumeBoxView])
        
        dateStampView = DateStampView()
        dateStampView.backgroundColor = UIColor(red: 32/255, green: 35/255, blue: 43/255, alpha: 1)
        self.addSubview(dateStampView)
        dateStampView.translatesAutoresizingMaskIntoConstraints = false
        let dateViewLeft = NSLayoutConstraint(item: dateStampView, attribute: .left, relatedBy: .equal, toItem: kBoxView, attribute: .left, multiplier: 1, constant: 0)
        let dateViewRight = NSLayoutConstraint(item: dateStampView, attribute: .right, relatedBy: .equal, toItem: kBoxView, attribute: .right, multiplier: 1, constant: 0)
        let dateViewBottom = NSLayoutConstraint(item: dateStampView, attribute: .bottom, relatedBy: .equal, toItem: volumeBoxView, attribute: .top, multiplier: 1, constant: 0)
        let dateViewTop = NSLayoutConstraint(item: dateStampView, attribute: .top, relatedBy: .equal, toItem: kBoxView, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([dateViewLeft,dateViewRight,dateViewTop,dateViewBottom])
        
        priceLabelView = PortraitPriceLableView()
        priceLabelView.backgroundColor = backgroundTitleColor
        self.addSubview(priceLabelView)
        priceLabelView.translatesAutoresizingMaskIntoConstraints = false
        let priceLabelViewLeft = NSLayoutConstraint(item: priceLabelView, attribute: .left, relatedBy: .equal, toItem: kBoxView, attribute: .right, multiplier: 1, constant: 0)
        let priceLabelViewRight = NSLayoutConstraint(item: priceLabelView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let priceLabelViewTop = NSLayoutConstraint(item: priceLabelView, attribute: .top, relatedBy: .equal, toItem: kBoxView, attribute: .top, multiplier: 1, constant: 0)
        let priceLabelViewBottom = NSLayoutConstraint(item: priceLabelView, attribute: .bottom, relatedBy: .equal, toItem: kBoxView, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([priceLabelViewLeft,priceLabelViewRight,priceLabelViewTop,priceLabelViewBottom])
        
        kvolumeView = UIView()
        self.addSubview(kvolumeView)
        kvolumeView.translatesAutoresizingMaskIntoConstraints = false
        let kvolumeViewLetf = NSLayoutConstraint(item: kvolumeView, attribute: .left, relatedBy: .equal, toItem: kBoxView, attribute: .left, multiplier: 1, constant: 0)
        let kvolumeViewRight = NSLayoutConstraint(item: kvolumeView, attribute: .right, relatedBy: .equal, toItem: kBoxView, attribute: .right, multiplier: 1, constant: 0)
        let kvolumeViewTop = NSLayoutConstraint(item: kvolumeView, attribute: .top, relatedBy: .equal, toItem: kBoxView, attribute: .top, multiplier: 1, constant: 0)
        let kvolumeViewBottom = NSLayoutConstraint(item: kvolumeView, attribute: .bottom, relatedBy: .equal, toItem: volumeBoxView, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([kvolumeViewRight,kvolumeViewLetf,kvolumeViewTop,kvolumeViewBottom])
        
        
        
        containerView = UIView()
        containerView.backgroundColor = backgroundTitleColor
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let containerViewLeft = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: volumeBoxView, attribute: .right, multiplier: 1, constant: 2)
        let containerViewRight = NSLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let containerViewTop = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: volumeBoxView, attribute: .top, multiplier: 1, constant: 15)
        let containerViewBottom = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: volumeBoxView, attribute: .bottom, multiplier: 1, constant: -2)
        self.addConstraints([containerViewLeft,containerViewRight,containerViewTop,containerViewBottom])
        
        volumMaxValueLabel = UILabel()
        volumMaxValueLabel.font = font
        volumMaxValueLabel.textColor = textColor
        volumMaxValueLabel.backgroundColor = UIColor.clear
        volumMaxValueLabel.adjustsFontSizeToFitWidth = true
        volumMaxValueLabel.text = "----"
        containerView.addSubview(volumMaxValueLabel)
        volumAverValueLabel = UILabel()
        volumAverValueLabel.font = font
        volumAverValueLabel.textColor = textColor
        volumAverValueLabel.backgroundColor = UIColor.clear
        volumAverValueLabel.adjustsFontSizeToFitWidth = true
        volumAverValueLabel.text = "----"
        containerView.addSubview(volumAverValueLabel)
        volumZeroValueLabel = UILabel()
        volumZeroValueLabel.font = font
        volumZeroValueLabel.textColor = textColor
        volumZeroValueLabel.backgroundColor = UIColor.clear
        volumZeroValueLabel.adjustsFontSizeToFitWidth = true
        volumZeroValueLabel.text = "0"
        containerView.addSubview(volumZeroValueLabel)
        
        volumMaxValueLabel.translatesAutoresizingMaskIntoConstraints = false
        let volumMaxValueLabelLetf = NSLayoutConstraint(item: volumMaxValueLabel, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0)
        let volumMaxValueLabelRight = NSLayoutConstraint(item: volumMaxValueLabel, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0)
        let volumMaxValueLabelTop = NSLayoutConstraint(item: volumMaxValueLabel, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
        let volumMaxValueLabelHeight = NSLayoutConstraint(item: volumMaxValueLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 21)
        volumMaxValueLabel.addConstraint(volumMaxValueLabelHeight)
        volumMaxValueLabel.superview!.addConstraints([volumMaxValueLabelLetf,volumMaxValueLabelRight,volumMaxValueLabelTop])
        
        volumAverValueLabel.translatesAutoresizingMaskIntoConstraints = false
        let volumAverValueLabelLetf = NSLayoutConstraint(item: volumAverValueLabel, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0)
        let volumAverValueLabelRight = NSLayoutConstraint(item: volumAverValueLabel, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0)
        let volumAverValueLabelTop = NSLayoutConstraint(item: volumAverValueLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0)
        let volumAverValueLabelHeight = NSLayoutConstraint(item: volumAverValueLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 21)
        volumAverValueLabel.addConstraint(volumAverValueLabelHeight)
        volumAverValueLabel.superview!.addConstraints([volumAverValueLabelLetf,volumAverValueLabelRight,volumAverValueLabelTop])
        
        volumZeroValueLabel.translatesAutoresizingMaskIntoConstraints = false
        let volumZeroValueLabelLetf = NSLayoutConstraint(item: volumZeroValueLabel, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0)
        let volumZeroValueLabelRight = NSLayoutConstraint(item: volumZeroValueLabel, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0)
        let volumZeroValueLabelBottom = NSLayoutConstraint(item: volumZeroValueLabel, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        let volumZeroValueLabelHeight = NSLayoutConstraint(item: volumZeroValueLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 21)
        volumZeroValueLabel.addConstraint(volumZeroValueLabelHeight)
        volumZeroValueLabel.superview!.addConstraints([volumZeroValueLabelLetf,volumZeroValueLabelRight,volumZeroValueLabelBottom])
        
        kBoxView.layer.borderColor = UIColor(red: 51/255, green: 62/255, blue: 75/255, alpha: 1).cgColor
        kBoxView.layer.borderWidth = 0.5
        volumeBoxView.layer.borderColor = UIColor(red: 51/255, green: 62/255, blue: 75/255, alpha: 1).cgColor
        volumeBoxView.layer.borderWidth = 0.5
        
        tOpenPriceLab = createLabel(str: "开:---", textColor: textColor, subView: kBoxView,toItemView: nil)
        tHighPriceLab = createLabel(str: "高:---", textColor: textColor, subView: kBoxView,toItemView: tOpenPriceLab)
        tLowPriceLab = createLabel(str: "低:---", textColor: textColor, subView: kBoxView,toItemView: tHighPriceLab)
        tClosePriceLab = createLabel(str: "关:---", textColor: textColor, subView: kBoxView,toItemView: tLowPriceLab)
        kMA5Lab = createLabel(str: "MA10:---", textColor: UIColor.white, subView: kBoxView, toItemView: nil,toItemView2: tOpenPriceLab)
        kMA30Lab = createLabel(str: "MA30:---", textColor: UIColor(red: 255/255, green: 252/255, blue: 0/255, alpha: 1), subView: kBoxView, toItemView: kMA5Lab,toItemView2: tLowPriceLab)
        kMA60Lab = createLabel(str: "MA60:---", textColor: UIColor(red: 28/255, green: 200/255, blue: 12/255, alpha: 1), subView: kBoxView, toItemView: kMA30Lab,toItemView2: tClosePriceLab)
        tVolumLab = createLabel(str: "成交量:---", textColor: textColor, subView: volumeBoxView, toItemView: nil)
        vMA5Lab = createLabel(str: "MA5:---", textColor: UIColor.white, subView: volumeBoxView, toItemView: tVolumLab)
        vMA10Lab = createLabel(str: "MA10:---", textColor: UIColor(red: 255/255, green: 252/255, blue: 0/255, alpha: 1), subView: volumeBoxView, toItemView: vMA5Lab)
        
        
    }
    
    func createLabel(str: String,textColor: UIColor,subView: UIView,toItemView: UIView?,toItemView2: UIView? = nil  )->UILabel{
        let tempLabel = UILabel()
        tempLabel.textColor = textColor
        tempLabel.font = font
        tempLabel.text = str
        tempLabel.isHidden = true
        subView.addSubview(tempLabel)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        var tempLabelLeft = NSLayoutConstraint()
        if toItemView != nil{
            tempLabelLeft = NSLayoutConstraint(item: tempLabel, attribute: .left, relatedBy: .equal, toItem: toItemView!, attribute: .right, multiplier: 1, constant: 5)
        }else{
            tempLabelLeft = NSLayoutConstraint(item: tempLabel, attribute: .left, relatedBy: .equal, toItem: subView, attribute: .left, multiplier: 1, constant: 5)
        }
        var tempLabelTop = NSLayoutConstraint()
        if toItemView2 != nil{
            tempLabelTop = NSLayoutConstraint(item: tempLabel, attribute: .top, relatedBy: .equal, toItem: toItemView2, attribute: .bottom, multiplier: 1, constant: 3)
        }else{
            tempLabelTop = NSLayoutConstraint(item: tempLabel, attribute: .top, relatedBy: .equal, toItem: subView, attribute: .top, multiplier: 1, constant: 3)
        }
        subView.addConstraints([tempLabelLeft,tempLabelTop])
        return tempLabel
    }
    
    /// MARK: 计算坐标
    /**
     *  把股市数据换算成实际的均线点坐标数组
     */
    func changePointWithData(data: [DataModel],index: Int,maxValue: Double,minValue: Double,volumMaxValue: Double?=nil)->NSArray{
        let tempArray = NSMutableArray()
        var startPointX: CGFloat = self.kvolumeView.frame.size.width-0.5*self.kLineWidth // 起点坐标
        for item in data{
            if index == 0{
                let currentValue = item.kMA10Value
                let yViewHeight = self.kBoxView.frame.height
                // 换算成实际的坐标数组
                var currentPointY:CGFloat = 0.0
                if maxValue != minValue{
                    currentPointY = (1-CGFloat((currentValue-minValue)/(maxValue-minValue)))*yViewHeight
                }
                let currentPoint = CGPoint(x: startPointX,y:  currentPointY)
                tempArray.add(NSStringFromCGPoint(currentPoint))
                // 生成下一个点的x坐标
                startPointX -= self.kLineWidth+self.kLinePadding
            }else if index == 1{
                let currentValue = item.kMA30Value
                let yViewHeight = self.kBoxView.frame.height
                // 换算成实际的坐标数组
                var currentPointY:CGFloat = 0.0
                if maxValue != minValue{
                    currentPointY = (1-CGFloat((currentValue-minValue)/(maxValue-minValue)))*yViewHeight
                }
                let currentPoint = CGPoint(x: startPointX,y: currentPointY)
                tempArray.add(NSStringFromCGPoint(currentPoint))
                // 生成下一个点的x坐标
                startPointX -= self.kLineWidth+self.kLinePadding
            }else if index == 2{
                let currentValue = item.kMA60Value
                let yViewHeight = self.kBoxView.frame.height
                // 换算成实际的坐标数组
                var currentPointY:CGFloat = 0.0
                if maxValue != minValue{
                    currentPointY = (1-CGFloat((currentValue-minValue)/(maxValue-minValue)))*yViewHeight
                }
                let currentPoint = CGPoint(x: startPointX,y: currentPointY)
                tempArray.add(NSStringFromCGPoint(currentPoint))
                // 生成下一个点的x坐标
                startPointX = startPointX-(self.kLineWidth+self.kLinePadding)
            }else if index == 3{
                let currentValue = item.vMA5Value
                // y的价格高度
                if let yHeight = volumMaxValue{
                    // y的实际坐标高度
                    let yViewHeight = self.kvolumeView.frame.size.height-self.kBoxView.frame.size.height-22-25
                    // 换算成实际坐标
                    var volumePointY = self.kvolumeView.frame.size.height
                    if currentValue != 0{
                        volumePointY = self.kvolumeView.frame.size.height-CGFloat(currentValue/yHeight)*yViewHeight
                    }
                    let currentPoint = CGPoint(x: startPointX,y: volumePointY)
                    tempArray.add(NSStringFromCGPoint(currentPoint))
                    // 生成下一个点的x坐标
                    startPointX = startPointX-(self.kLineWidth+self.kLinePadding)
                }
            }else if index == 4{
                let currentValue = item.vMA10Value
                // y的价格高度
                if let yHeight = volumMaxValue{
                    // y的实际坐标高度
                    let yViewHeight = self.kvolumeView.frame.size.height-self.kBoxView.frame.size.height-22-25
                    // 换算成实际坐标
                    var volumePointY = self.kvolumeView.frame.size.height
                    if currentValue != 0{
                        volumePointY = self.kvolumeView.frame.size.height-CGFloat(currentValue/yHeight)*yViewHeight
                    }
                    let currentPoint = CGPoint(x: startPointX,y: volumePointY)
                    tempArray.add(NSStringFromCGPoint(currentPoint))
                    // 生成下一个点的x坐标
                    startPointX = startPointX-(self.kLineWidth+self.kLinePadding)
                }
            }
        }
        return tempArray
    }
    
    /**
     *  把股市数据换算成实际的k线实体坐标数组
     */
    func changePointWithData(data: [DataModel],maxValue: Double,minValue: Double)->NSArray{
        let tempArray = NSMutableArray()
        self.pointArray = NSMutableArray()
        var startPointX = self.kvolumeView.frame.size.width - self.kLineWidth/2
        for item in data{
            // y的价格高度
            let yHeight = maxValue-minValue
            // y的实际坐标高度
            let yViewHeight = self.kBoxView.bounds.size.height
            // 换算成实际坐标
            var openPointY: CGFloat = 0
            var heightPointY: CGFloat = 0
            var lowPointY: CGFloat = 0
            var closePointY: CGFloat = 0
            if minValue != maxValue{
                openPointY = CGFloat((1-(item.open-minValue)/yHeight))*yViewHeight
                heightPointY = CGFloat((1-(item.height-minValue)/yHeight))*yViewHeight
                lowPointY = CGFloat((1-(item.low-minValue)/yHeight))*yViewHeight
                closePointY = CGFloat((1-(item.close-minValue)/yHeight))*yViewHeight
            }
            
            let openPoint = CGPoint(x: startPointX,y: openPointY)
            let heightPoint = CGPoint(x: startPointX,y: heightPointY)
            let lowhtPoint = CGPoint(x: startPointX,y: lowPointY)
            let closePoint = CGPoint(x: startPointX,y: closePointY)
            
            // 实际坐标组装成数组
            var currentArray: NSArray? = NSArray(objects: NSStringFromCGPoint(openPoint),NSStringFromCGPoint(heightPoint),NSStringFromCGPoint(lowhtPoint),NSStringFromCGPoint(closePoint),item.date,item.close,item.kMA10Value,item.kMA30Value,item.kMA60Value,item.open,item.height,item.low,item.volume,item.vMA5Value,item.vMA10Value)
            tempArray.add(currentArray!) //坐标添加到数组
            currentArray = nil
            startPointX = startPointX-(self.kLineWidth+self.kLinePadding)
        }
        self.pointArray = tempArray
        return tempArray
    }
    
    /**
     *  把股市数据换算成实际的成交量实体坐标数组
     */
    func changeVolumePointWithData(data: [DataModel],volumMaxValue: Double)->NSArray{
        let tempArray = NSMutableArray()
        var startPointX = self.kvolumeView.frame.size.width - self.kLineWidth/2
        for item in data{
            // y的价格高度
            let yHeight = volumMaxValue
            // y的实际坐标高度
            let yViewHeight = self.kvolumeView.frame.size.height-self.kBoxView.frame.size.height-22-25
            // 换算成实际坐标
            var volumePointY = self.kvolumeView.frame.size.height
            if Int(item.volume) != 0{
                volumePointY = self.kvolumeView.frame.size.height-CGFloat(item.volume/yHeight)*yViewHeight
            }
            let volumePoint = CGPoint(x: startPointX,y: volumePointY)
            let volumeStartPoint = CGPoint(x: startPointX,y: self.kvolumeView.frame.size.height)
            let openPoint = CGPoint(x: startPointX,y: CGFloat(item.open))
            let closePoint = CGPoint(x: startPointX,y: CGFloat(item.close))
            
            // 实际坐标组装成数组
            var currentArray: NSArray? = NSArray(objects: NSStringFromCGPoint(closePoint),NSStringFromCGPoint(volumePoint),NSStringFromCGPoint(volumeStartPoint),NSStringFromCGPoint(openPoint))
            tempArray.add(currentArray!) //坐标添加到数组
            currentArray = nil
            startPointX = startPointX-(self.kLineWidth+self.kLinePadding)
        }
        return tempArray
    }
    
    /// MARK: Tool Method
    /**
     *  成交量数据处理
     */
    func volumeData(volume: Double)->String{
        var newData = volume;
        var unit = ""
        if volume > 10000 && volume<10000000{
            newData = volume/10000
            unit = "万"
        }else if volume > 10000000 && volume < 100000000{
            newData = volume/10000000
            unit = "千万"
        }else if volume>100000000{
            newData = volume/100000000
            unit = "亿"
        }
        let newStr = String(format: "%0.1f", newData)+unit
        return newStr
    }
    
    /**
     *  计算最大值和最小值
     */
    func changeMaxAndMinValue(data: Array<DataModel>,range: NSRange){
        
        var tempArray = (data.reversed() as NSArray).objects(at: NSIndexSet(indexesIn: range) as IndexSet) as! [DataModel]
        tempArray = tempArray.reversed()
        self.datas = tempArray
        /** 成交价的最大值 */
        var maxValue: Double = 0
        /** 成交价的最小值 */
        var minValue: Double = Double(Int.max)
        /** 成交量的最大值 */
        var volumMaxValue: Double = 0.0
        /** 成交量的平均值 */
        var volumAveValue: Double = 0.0
        for item in tempArray{
            if item.height>maxValue{
                maxValue = item.height
            }
            if item.low<minValue{
                minValue = item.low
            }
            if item.kMA10Value>maxValue && item.kMA10Value > 0{
                maxValue = item.kMA10Value
            }
            if item.kMA30Value>maxValue && item.kMA30Value > 0{
                maxValue = item.kMA30Value
            }
            if item.kMA60Value>maxValue && item.kMA60Value > 0{
                maxValue = item.kMA60Value
            }
            if item.kMA60Value<minValue && item.kMA60Value > 0{
                minValue = item.kMA60Value
            }
            if item.kMA10Value<minValue && item.kMA10Value > 0{
                minValue = item.kMA10Value
            }
            if item.kMA30Value<minValue && item.kMA30Value > 0{
                minValue = item.kMA30Value
            }
            if item.volume>volumMaxValue{
                volumMaxValue = item.volume
            }
            if item.vMA5Value>volumMaxValue{
                volumMaxValue = item.vMA5Value
            }
            if item.vMA10Value>volumMaxValue{
                volumMaxValue = item.vMA10Value
            }
            volumAveValue = volumMaxValue/2
        }
        let padValue = (maxValue-minValue)/6
        maxValue += padValue
        minValue -= padValue
        self.lastMaxValue = maxValue
        self.lastMinValue = minValue
        self.setPriceLabel(maxValue: maxValue, minValue: minValue, volumMaxValue: volumMaxValue, volumAveValue: volumAveValue)
        if self.lines != nil{
            self.drawBoxWithKLine(lines: lines!, maxValue: maxValue, minValue: minValue, volumMaxValue: volumMaxValue)
        }
        if touchViewPoint != nil{
            self.isKPointWithPoint(point: touchViewPoint!)
        }
    }
    
    /// MARK: 初始化数据
    /**
     *  给平均线添加值
     */
    func setPriceLabel(maxValue: Double,minValue: Double, volumMaxValue: Double,volumAveValue: Double){
        // 给平均线添加值
        if maxValue != minValue{
            let padvalue = (maxValue-minValue)/4
            for i in 0...4{
                self.priceLabelView.priceLabels[i].text = String(format: "%.2f",padvalue*Double(i)+minValue)
            }
        }else{
            for i in 0...4{
                self.priceLabelView.priceLabels[i].text = String(format: "%.2f",minValue)
            }
        }
        // 设置成交量的值
        self.volumMaxValueLabel.text = self.volumeData(volume: volumMaxValue)
        self.volumAverValueLabel.text = self.volumeData(volume: volumAveValue)
    }
    
    /**
     *  给时间轴添加值
     */
    func setDateLabel(data: NSArray){
        
        
        // 时间字符串截取
        let range = NSMakeRange(10, 6)
        
        self.dateStampView.dateLabel6.text = ((data.object(at: 0) as! NSArray).object(at: 4) as! NSString).substring(with: range)
        
        let index5 = (data.count)/5
        let point5 = CGPointFromString((data.object(at: index5) as! NSArray).object(at: 2) as! String)
        self.dateStampView.dateLabel5.frame.origin.x = point5.x-self.dateStampView.dateLabel5.frame.size.width/2
        self.dateStampView.dateLabel5.text = ((data.object(at: index5) as! NSArray).object(at: 4) as! NSString).substring(with: range)
        
        let index4 = (data.count)*2/5
        let point4 = CGPointFromString((data.object(at: index4) as! NSArray).object(at: 2) as! String)
        self.dateStampView.dateLabel4.frame.origin.x = point4.x-self.dateStampView.dateLabel4.frame.size.width/2
        self.dateStampView.dateLabel4.text = ((data.object(at: index4) as! NSArray).object(at: 4) as! NSString).substring(with: range)
        
        let index3 = (data.count)*3/5
        let point3 = CGPointFromString((data.object(at: index3) as! NSArray).object(at: 2) as! String)
        self.dateStampView.dateLabel3.frame.origin.x = point3.x-self.dateStampView.dateLabel3.frame.size.width/2
        self.dateStampView.dateLabel3.text = ((data.object(at: index3) as! NSArray).object(at: 4) as! NSString).substring(with: range)
        
        let index2 = (data.count)*4/5
        let point2 = CGPointFromString((data.object(at: index2) as! NSArray).object(at: 2) as! String)
        self.dateStampView.dateLabel2.frame.origin.x = point2.x-self.dateStampView.dateLabel2.frame.size.width/2
        self.dateStampView.dateLabel2.text = ((data.object(at: index2) as! NSArray).object(at: 4) as! NSString).substring(with: range)
        self.dateStampView.dateLabel1.text = ((data.lastObject! as! NSArray).object(at: 4) as! NSString).substring(with: range)
        
        // 画网格
        self.kBoxView.point5 = point5
        self.kBoxView.point4 = point4
        self.kBoxView.point3 = point3
        self.kBoxView.point2 = point2
        self.kBoxView.clearsContextBeforeDrawing = true
        self.kBoxView.setNeedsDisplay()
        
        self.volumeBoxView.point5 = point5
        self.volumeBoxView.point4 = point4
        self.volumeBoxView.point3 = point3
        self.volumeBoxView.point2 = point2
        self.volumeBoxView.clearsContextBeforeDrawing = true
        self.volumeBoxView.setNeedsDisplay()
        
    }
    
    /**
     *  开始在框框里画k线
     */
    func drawBoxWithKLine(lines: Lines,maxValue: Double,minValue: Double,volumMaxValue: Double){
        
        /// 开始画均线
        //1.画十日均线
        self.drawMAWithIndex(index: 0,lines: lines,maxValue: maxValue,minValue: minValue)
        //2.画三十日均线
        self.drawMAWithIndex(index: 1, lines: lines,maxValue: maxValue,minValue: minValue)
        //3.画六十日均线
        self.drawMAWithIndex(index: 2, lines: lines, maxValue: maxValue, minValue: minValue)
        //4.画五日成交量均线
        self.drawMAWithIndex(index: 3, lines: lines, maxValue: maxValue, minValue: minValue,volumMaxValue: volumMaxValue)
        //5.画十日成交量均线
        self.drawMAWithIndex(index: 4, lines: lines, maxValue: maxValue, minValue: minValue,volumMaxValue: volumMaxValue)
        //6.走势线
        //         self.drawMAWithIndex(2, color: "#FF00FF",lines: lines)
        
        // 开始画k连线
        self.drawKLineWithData(line: lines, maxValue: maxValue, minValue: minValue)
        
        // 开始画成交量
        self.drawVolumeLineWithData(line: lines, volumMaxValue: volumMaxValue)
        
    }
    
    /**
     *  开始画各种均线
     */
    func drawMAWithIndex(index: Int,lines: Lines,maxValue: Double,minValue: Double,volumMaxValue: Double?=nil){
        // 换算成实际的坐标数组
        let tempArray = self.changePointWithData(data: datas!,index: index,maxValue: maxValue,minValue: minValue,volumMaxValue: volumMaxValue)
        if index == 0 {
            lines.lineMA10Points = tempArray
        }else if index == 1{
            lines.lineMA30Points = tempArray
        }else if index == 2{
            lines.lineMA60Points = tempArray
        }else if index == 3{
            lines.vLineMA5Points = tempArray
        }else if index == 4{
            lines.vLineMA10Points = tempArray
        }
    }
    
    /**
     *  开始画k线实体
     */
    func drawKLineWithData(line: Lines,maxValue: Double,minValue: Double){
        // 换算成实际k线实体坐标数组
        let ktempArray = self.changePointWithData(data: datas!,maxValue: maxValue,minValue: minValue)
        line.lineWidth = self.kLineWidth
        line.kLinePoints = ktempArray
        setDateLabel(data: ktempArray)
    }
    
    /**
     *  开始画成交量实体
     */
    func drawVolumeLineWithData(line: Lines,volumMaxValue: Double){
        // 换算成实际k线实体坐标数组
        let volumeTempArray = self.changeVolumePointWithData(data: datas!,volumMaxValue: volumMaxValue)
        line.lineWidth = self.kLineWidth
        line.volumePoints = volumeTempArray
        
    }
    
    /// MARK: 手势动作
    /**
     *  手指捏合，放大缩小
     */
    var float: CGFloat = 0.5
    var flag = 1
    func touchBoxAction(pinGesture: UIPinchGestureRecognizer){
        if flag == 1{
            self.kLineWidth = pinGesture.scale*self.kLineWidth
            flag = 2
        }else{
            pinGesture.scale = pinGesture.scale-lastPinScale+1
            self.kLineWidth = pinGesture.scale*self.kLineWidth
        }
        if self.kLineWidth>self.kLineMaxWidth{
            self.kLineWidth = self.kLineMaxWidth
        }
        if self.kLineWidth<self.kLineMinWidth{
            self.kLineWidth = self.kLineMinWidth
        }
        if pinGesture.scale>1{
            self.location += (self.kLineCount-Int(self.kvolumeView.frame.size.width/(self.kLineWidth+self.kLinePadding)))
        }else{
            self.location -= (Int(self.kvolumeView.frame.size.width/(self.kLineWidth+self.kLinePadding))-self.kLineCount)
        }
        
        kLineCount = Int(self.kvolumeView.frame.size.width/(self.kLineWidth+self.kLinePadding))
        if self.allDatas != nil{
            if location>self.allDatas!.count-kLineCount{
                self.location = self.allDatas!.count-kLineCount
            }else if location<0{
                self.location = 0
            }
            self.range = NSMakeRange(location, kLineCount)
        }
        
        //location = self.tempDatas!.count-kLineCount
        self.setNeedsDisplay()
        self.lastPinScale = pinGesture.scale
        if self.kLineWidth>10{
            self.float = 0.28
        }else{
            self.float = 0.5
        }
    }
    
    /**
     *  手指滑动，加载更多数据
     */
    func panGestureAction(gesture: UIPanGestureRecognizer){
        self.isPanGesture = true
        let offsetX = gesture.translation(in: self.kvolumeView).x
        if offsetX>0{
            let temp = offsetX/(self.kLineWidth+self.kLinePadding)
            var moveCount = 0
            if temp<=1 && temp > float{
                moveCount = 1
            }else{
                moveCount = Int(temp)
            }
            
            location -= moveCount
            if location<0{
                location = 0
            }
            self.range = NSMakeRange(location,kLineCount)
            
            if DealData.shareInstance.timer != nil{
                DealData.shareInstance.timer!.invalidate()
                DealData.shareInstance.timer = nil
            }
            self.setNeedsDisplay()
        }else{
            let temp = (-offsetX)/(self.kLineWidth+self.kLinePadding)
            var moveCount = 0
            if temp<=1 && temp > float{
                moveCount = 1
            }else{
                moveCount = Int(temp)
            }
            location += moveCount
            if self.location>self.allDatas!.count-self.kLineCount{
                self.location = self.allDatas!.count-self.kLineCount
            }
            self.range = NSMakeRange(location,kLineCount)
            self.setNeedsDisplay()
        }
        
        if gesture.state == .ended{
            self.isPanGesture = false
            if self.location == (self.allDatas!.count-self.kLineCount){
                if DealData.shareInstance.timer == nil{
                    DealData.shareInstance.getData()
                    DealData.shareInstance.startTimer()
                }
            }
            self.range = NSMakeRange(location,kLineCount)
            self.setNeedsDisplay()
        }
        gesture.setTranslation(CGPoint(x: offsetX/(self.kLineWidth+self.kLinePadding) ,y: 0), in: self.kvolumeView)
    }
    
    
    /**
     *  手指点击，生成十字线
     */
    func tapGestureAction(gesture: UITapGestureRecognizer){
        touchViewPoint = gesture.location(in: self.kvolumeView)
        // 手指点击时开始显示十字线
        
        self.lines!.moveLineOne.isHidden = false
        self.lines!.moveLineTwo.isHidden = false
        self.lines!.moveLineOneLable.isHidden = false
        self.lines!.moveLineTwoLable.isHidden = false
        self.lines!.originImg.isHidden = false
        self.tClosePriceLab.isHidden = false
        self.tOpenPriceLab.isHidden = false
        self.tHighPriceLab.isHidden = false
        self.tLowPriceLab.isHidden = false
        self.kMA5Lab.isHidden = false
        self.kMA30Lab.isHidden = false
        self.kMA60Lab.isHidden = false
        self.tVolumLab.isHidden = false
        self.vMA5Lab.isHidden = false
        self.vMA10Lab.isHidden = false
        self.isKPointWithPoint(point: touchViewPoint!)
        
    }
    
    /**
     *  判断并在十字线上显示提示信息
     */
    func isKPointWithPoint(point: CGPoint){
        var closeItemX: CGFloat = 0
        for item in self.pointArray{
            // 收盘价坐标
            let itemPoint: CGPoint = CGPointFromString((item as! NSArray).object(at: 3) as! String)
            closeItemX = itemPoint.x
            let itemX = Int(closeItemX)
            let pointX = Int(point.x)
            if itemX == pointX || point.x-closeItemX<=self.kLineWidth/2{
                self.lines!.moveLineOne.frame.origin.x = closeItemX
                let maxValue = Double(self.priceLabelView.priceLabel1.text!)
                let minValue = Double(self.priceLabelView.priceLabel5.text!)
                var tempLineTwoY = point.y
                var tempPrice = CGFloat(maxValue!)-point.y/self.kBoxView.frame.size.height*CGFloat((maxValue!-minValue!))
                if point.y>self.kBoxView.frame.size.height{
                    tempLineTwoY = self.kBoxView.frame.size.height
                    tempPrice = CGFloat(minValue!)
                }
                self.lines!.moveLineTwo.frame.origin.y = tempLineTwoY
                self.lines!.originImg.frame.origin = CGPoint(x: closeItemX-5,y:
                    tempLineTwoY-5)
                if closeItemX<=self.lines!.moveLineOneLable.frame.size.width/2{
                    self.lines!.moveLineOneLable.frame.origin.x = 0
                }else if self.lines!.frame.size.width-closeItemX<=self.lines!.moveLineOneLable.frame.size.width/2{
                    self.lines!.moveLineOneLable.frame.origin.x = self.lines!.frame.size.width-self.lines!.moveLineOneLable.frame.size.width
                }else{
                    self.lines!.moveLineOneLable.frame.origin.x = closeItemX-50
                }
                self.lines!.moveLineTwoLable.frame.origin.y = tempLineTwoY-6
                self.lines!.moveLineOneLable.text = "\((item as! NSArray).object(at: 4))"
                self.lines!.moveLineTwoLable.text = String(format: "%.2f", tempPrice)
                self.tOpenPriceLab.text = "开:\((item as! NSArray).object(at: 9))"
                self.tHighPriceLab.text = "高:\((item as! NSArray).object(at: 10))"
                self.tLowPriceLab.text = "低:\((item as! NSArray).object(at: 11))"
                self.tClosePriceLab.text = "收:\((item as! NSArray).object(at: 5))"
                self.kMA5Lab.text = "MA10:"+String(format: "%.2f",(item as! NSArray).object(at: 6) as! Double)
                self.kMA30Lab.text = "MA30:"+String(format: "%.2f",(item as! NSArray).object(at: 7) as! Double)
                self.kMA60Lab.text = "MA60:"+String(format: "%.2f",(item as! NSArray).object(at: 8) as! Double)
                self.tVolumLab.text = "成交量:"+String(format: "%.3f",(item as! NSArray).object(at: 12) as! Double)
                self.vMA5Lab.text = "MA5:"+String(format: "%.2f",(item as! NSArray).object(at: 13) as! Double)
                self.vMA10Lab.text = "MA10:"+String(format: "%.2f",(item as! NSArray).object(at: 14) as! Double)
            }
        }
    }
}
