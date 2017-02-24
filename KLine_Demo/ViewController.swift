//
//  ViewController.swift
//  KLine_Demo
//
//  Created by Min on 2017/2/24.
//  Copyright © 2017年 cdu.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /** 币种类型 */
    var coinID: String!
    /** 分时 */
    var period: String!
    /** 地址 */
    let http = "http://api.huobi.com/staticmarket/btc_kline_060_json.js"
    var timer: Timer?
    
    var portraitLineView: PortraitLineView!
    
    // 启动定时器
    func startTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        startTimer()
        portraitLineView = PortraitLineView()
        //        portraitLineView.backgroundColor = UIColor.red
        self.view.addSubview(portraitLineView)
        portraitLineView.translatesAutoresizingMaskIntoConstraints = false
        let letf = NSLayoutConstraint(item: portraitLineView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 3)
        let right = NSLayoutConstraint(item: portraitLineView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: portraitLineView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -30)
        let top = NSLayoutConstraint(item: portraitLineView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 114)
        portraitLineView.superview!.addConstraints([letf,right,bottom,top])
        
        DealData.shareInstance.http = http
        DealData.shareInstance.startTimer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 获取最新分时行情
    func getData(){
        let url = URL(string: http)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request,
                                        completionHandler: {(data, response, error) -> Void in
                                            if error != nil{
                                                print(error.debugDescription)
                                            }else{
                                                let jsonArr = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                                                let result = DealData.shareInstance.changeData(data: jsonArr.reversed() as NSArray)
                                                self.portraitLineView.allDatas = result
                                                DispatchQueue.main.async {
                                                    self.portraitLineView.setNeedsDisplay()
                                                }
                                                
                                                //                                                print(result[1])
                                            }
        }) as URLSessionTask
        //使用resume方法启动任务
        dataTask.resume()
    }
}

