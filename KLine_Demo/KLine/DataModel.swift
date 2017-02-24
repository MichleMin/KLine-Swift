//
//  StaticmarketModel.swift
//  KLineDemo
//

import UIKit


class DataModel{
    
    /** 交易日期 */
    var date: String = ""
    /** 开盘价 */
    var open: Double = 0.0
    /** 最高价 */
    var height: Double = 0.0
    /** 最低价 */
    var low: Double = 0.0
    /** 收盘价 */
    var close: Double = 0.0
    /** 成交量 */
    var volume: Double = 0.0
    /** k线MA10 */
    var kMA10Value: Double = 0.0
    /** k线MA30 */
    var kMA30Value: Double = 0.0
    /** k线MA60 */
    var kMA60Value: Double = 0.0
    /** 成交量MA5 */
    var vMA5Value: Double = 0.0
    /** 成交量MA10 */
    var vMA10Value: Double = 0.0

}
