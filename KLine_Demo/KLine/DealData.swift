//
//  GetData.swift
//  KLineDemo
//
//  Created by min on 16/8/21.
//  Copyright © 2016年 min. All rights reserved.
//

import UIKit

class DealData{
    static let shareInstance = DealData()
    var http = ""
    var timer: Timer?
    var getDataBlock: ((Array<DataModel>)->Void)?
    private init(){
        
    }
    // 启动定时器
    func startTimer(){
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
        
    }
    
    // 获取数据
    @objc func getData(){
        let url = URL(string: http)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request,
                                        completionHandler: {(data, response, error) -> Void in
                                            if error != nil{
                                                print(error.debugDescription)
                                            }else{
                                                let jsonArr = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                                                let resultData = self.changeData(data: jsonArr.reversed() as NSArray)
                                                if self.getDataBlock != nil{
                                                    DispatchQueue.main.async {
                                                        self.getDataBlock!(resultData)
                                                    }
                                                }
                                            }
        }) as URLSessionTask
        //使用resume方法启动任务
        dataTask.resume()
    }
    
    
    /**
     *  对获取的数据进行处理
     */
    func changeData(data: NSArray)->Array<DataModel>{
        var resultArr = [DataModel]()
        for item in data{
            let tempItem = item as! NSArray
            let model = DataModel()
            model.date = dateFromString(str: tempItem.object(at: 0) as! String, year: NSMakeRange(0, 4), month: NSMakeRange(4, 2), day: NSMakeRange(6, 2), hour: NSMakeRange(8, 2), minute: NSMakeRange(10, 2), second: NSMakeRange(12, 2))
            model.open = tempItem.object(at: 1) as! Double
            model.height = tempItem.object(at: 2) as! Double
            model.low = tempItem.object(at: 3) as! Double
            model.close = tempItem.object(at: 4) as! Double
            model.volume = tempItem.object(at: 5) as! Double
            let idxLocation = data.index(of: item)
            model.kMA10Value = self.calculateAve(data: data,index: 4,range: NSMakeRange(idxLocation, 10))
            model.kMA30Value = self.calculateAve(data: data,index: 4,range: NSMakeRange(idxLocation, 30))
            model.kMA60Value = self.calculateAve(data: data,index: 4,range: NSMakeRange(idxLocation, 60))
            model.vMA5Value = self.calculateAve(data: data, index: 5, range: NSMakeRange(idxLocation, 5))
            model.vMA10Value = self.calculateAve(data: data, index: 5, range: NSMakeRange(idxLocation, 10))
            resultArr.append(model)
        }
        return resultArr
    }
    
    // 计算收盘价的平均值
    func calculateAve(data: NSArray,index:Int,range: NSRange)->Double{
        var value = 0.0
        if data.count-range.location>range.length{
            let newArray = data.objects(at: NSIndexSet(indexesIn: range) as IndexSet)
            for item in newArray{
                let tempItem = item as! NSArray
                value += tempItem.object(at: index) as! Double
            }
            if value>0{
                value = value/Double(newArray.count)
            }
        }
        return value
    }
    
    /**
     *  字符串转换为日期时间对象
     */
    func dateFromString(str: String,year: NSRange,month: NSRange,day: NSRange,hour: NSRange,minute: NSRange,second: NSRange)->String{
        let year = (str as NSString).substring(with: year)
        let month = (str as NSString).substring(with: month)
        let day = (str as NSString).substring(with: day)
        let hour = (str as NSString).substring(with: hour)
        let minute = (str as NSString).substring(with: minute)
        let second = (str as NSString).substring(with: second)
        let date = year+"-"+month+"-"+day+" "+hour+":"+minute+":"+second
        return date
    }
}
