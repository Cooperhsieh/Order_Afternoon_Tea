//
//  Tea.swift
//  Order_Afternoon_Tea
//
//  Created by Cooper on 2020/11/4.
//

import Foundation

// MARK: Tea 日後可改較為易懂的名稱，如 Order.swift

struct UploadDrinkData: Codable {
    let data: OrderInfo
}

//sheetDB上傳&下載、cell 檔案讀取資料用
struct OrderInfo: Codable {
    var name: String
    var drinks: String
    var price: String
    var size: String
    var sweetness: String
    var ice: String
    var tapioca: String

}


//創建 enum for TeaOrder 頁面使用
enum SugarLevel: String {
    case normal = "正常"
    case seventy = "少糖"
    case half = "半糖"
    case thirty = "微糖"
    case zero = "無糖"
}

enum IceLevel: String {
    case full = "正常"
    case seventy = "少冰"
    case thirty = "微冰"
    case zero = "去冰"
    case hot = "熱飲"
}

enum SizeLevel: String {
    case big = "大杯"
    case medium = "中杯"
}





