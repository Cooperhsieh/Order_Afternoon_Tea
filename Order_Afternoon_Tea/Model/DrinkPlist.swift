//
//  DrinkPlist.swift
//  Order_Afternoon_Tea
//
//  Created by Cooper on 2020/11/4.
//

import Foundation

//對應 plist 資料
struct DrinkPlist: Decodable {
    let drinks: String
    let price: Int
    
}

// MARK: 在這裡直接抓取 Plist 資料
struct MenuDBController {
    
    static let shared = MenuDBController()
    
    func fetchDrinkPlist (completion: @escaping([DrinkPlist]?) -> ()) {
        let url = Bundle.main.url(forResource: "Drinks", withExtension: "plist")!
        //print("\(url)")
        if let data = try? Data(contentsOf: url),
           let drinkPlist = try? PropertyListDecoder().decode([DrinkPlist].self, from: data) {
            completion(drinkPlist)
            //print(drinkPlist)
        } else {
            completion(nil)
        }
    }
}
