//
//  TeaOrderTableViewController.swift
//  Order_Afternoon_Tea
//
//  Created by Cooper on 2020/11/4.
//

import UIKit

class TeaOrderTableViewController: UITableViewController {
    
    //MARK: UI Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var sizeSegmentedField: UISegmentedControl!
    @IBOutlet weak var sweetSegmentedField: UISegmentedControl!
    @IBOutlet weak var iceSegmentedField: UISegmentedControl!
    @IBOutlet weak var tapiocaSwitch: UISwitch!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var confrimOrderButton: UIButton!
    @IBOutlet weak var editOrderButton: UIButton!
    
    
    //MARK: SheetDB 免費帳戶只有500次/月使用，如無法上傳/下載資料，可換成另外一組 API
    //備用 API 1
    //https://sheetdb.io/api/v1/jcombi4mfoh9j
    //備用 API 2
    //https://sheetdb.io/api/v1/eili7urtrn56v
    
    
    var isNewOrder = true
    
    //for API Edit data Transfer
    var editOrder: OrderInfo?
    
    var sugar: SugarLevel = .normal
    var ice: IceLevel = .full
    var size: SizeLevel = .medium
    var price = Int()
    var addFood = ""
   
    // Plist Data
    var drinksData : [DrinkPlist] = []
    
   
    
    

    
    
    // MARK: UI Action
    //甜度轉換字串
    @IBAction func sugarSegAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sugar = .normal
        case 1:
            sugar = .seventy
        case 2:
            sugar = .half
        case 3:
            sugar = .thirty
        case 4:
            sugar = .zero
        default:
            sugar = .normal
        }
}
    
    //冰塊選擇
    @IBAction func iceSegAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            ice = .full
        case 1:
            ice = .seventy
        case 2:
            ice = .thirty
        case 3:
            ice = .zero
        case 4:
            ice = .hot
        default:
            ice = .full
        }
    }
    
    //容量選擇
    @IBAction func sizeSegAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            size = .medium
        case 1:
            size = .big
        default:
            size = .medium
        }
        calculateSizePrice()
    }
    
    
    //加珍珠加錢
    @IBAction func addTapiocaSwitch(_ sender: UISwitch) {
        var text = ""
        
        
        if tapiocaSwitch.isOn {
            text = "加珍珠"
            addFood = text
        } else {
            text = "不加珍珠"
            addFood = text
        }
        
       calculateTapiocaPrice()
    }
    
    
    
    
    // MARK: Function Declaration
    //取回訂單資料
    func getDrinkRecord () {
        
        nameTextField.text = editOrder?.name
            
        drinkButton.setTitle(editOrder?.drinks, for: .normal)
            
        priceLabel.text = editOrder?.price
            
        tapiocaSwitch.isOn = editOrder?.tapioca == "加珍珠" ? true : false
        
        sweetSegmentedField.selectedSegmentIndex = convertStringToIndex(str: editOrder!.sweetness)
        iceSegmentedField.selectedSegmentIndex = convertStringToIndex(str: editOrder!.ice)
        sizeSegmentedField.selectedSegmentIndex = convertStringToIndex(str: editOrder!.size)
    }
    
    //從 SheetDB 中的容量、甜度及冰度字串資料 轉換回 SegmentedIndex 資料
    func convertStringToIndex(str: String) -> Int {
            switch str {
            case "中杯", "正常":
                return 0
            case "大杯", "少糖", "少冰":
                return 1
            case "半糖", "微冰":
                return 2
            case "微糖", "去冰":
                return 3
            case "無糖", "熱飲":
                return 4
            default:
                return 0
            }
        }
    
    //如果點 button 換飲料就更新容量為中杯、冰塊甜度變回正常、珍珠不加
    func clearDrinkInfo () {
        sizeSegmentedField.selectedSegmentIndex = 0
        sweetSegmentedField.selectedSegmentIndex = 0
        iceSegmentedField.selectedSegmentIndex = 0
        tapiocaSwitch.isOn = false
        
    }
    
    //計算容量的價錢
    func calculateSizePrice () {
        MenuDBController.shared.fetchDrinkPlist { (drinkPlist) in
            if let drinkData = drinkPlist {
                var drinkName = ""
                var sizePrice = Int()
                
                for changeSize in drinkData {
                    drinkName = changeSize.drinks
                    self.price = changeSize.price
                    
                    //跑迴圈後抓出飲料價錢及名稱，再用飲料名 = 按鈕選後顯示的名稱來加價
                    if drinkName == self.drinkButton.currentTitle {
                        if self.sizeSegmentedField.selectedSegmentIndex == 1 {
                            print("drink Name is = \(drinkName)")
                            sizePrice = self.price + 5
                            print("How much price added? = \(self.price) + \(5)")
                            self.priceLabel.text = String(sizePrice)
                            print("Large-Size price = \(sizePrice)")
                        } else {
                            self.priceLabel.text = String(self.price)
                            print("Mid-Size price = \(self.price)")
                        }
                    }
                }
            }
        }
    }
    
    //計算珍珠的價錢
    func calculateTapiocaPrice () {
        MenuDBController.shared.fetchDrinkPlist { (drinkPlist) in
            if let drinkData = drinkPlist {
                var drinkName = ""
                var tapiocaPrice = Int()
                
                for changeSize in drinkData {
                    drinkName = changeSize.drinks
                    self.price = changeSize.price
                    
                    
                    if drinkName == self.drinkButton.currentTitle
                    {
                        if self.tapiocaSwitch.isOn && self.sizeSegmentedField.selectedSegmentIndex == 1 {
                            tapiocaPrice = self.price + 10
                            self.priceLabel.text = String(tapiocaPrice)
                            print("加珍珠價錢 = \(tapiocaPrice)")
                        } else if self.tapiocaSwitch.isOn == false && self.sizeSegmentedField.selectedSegmentIndex == 1 {
                            tapiocaPrice = self.price + 5
                            self.priceLabel.text = String(tapiocaPrice)
                            print("不加珍珠價錢 = \(tapiocaPrice)")
                            
                        }
                            
                        if self.tapiocaSwitch.isOn && self.sizeSegmentedField.selectedSegmentIndex == 0 {
                            tapiocaPrice = self.price + 5
                            self.priceLabel.text = String(tapiocaPrice)
                            print("中杯加珍珠價錢 = \(tapiocaPrice)")
                        } else if self.tapiocaSwitch.isOn == false && self.sizeSegmentedField.selectedSegmentIndex == 0 {
                            tapiocaPrice = self.price
                            self.priceLabel.text = String(tapiocaPrice)
                            print("中杯不加珍珠價錢 = \(tapiocaPrice)")
                        }
                    }
                }
            }
        }
    }
    
    
    //選擇飲料的按鈕，導入plist
    @IBAction func selectDrink(_ sender: Any) {
        MenuDBController.shared.fetchDrinkPlist(completion: { (drinkPlist) in
            let controller = UIAlertController(title: "春陽茶事", message: "選擇飲料", preferredStyle: .actionSheet)
            
            if let drinkPlist = drinkPlist {
                for drink in drinkPlist {
                    let action = UIAlertAction(title: drink.drinks, style: .default) { (_) in
                        //將飲料名、價格帶至指定的欄位
                        self.drinkButton.setTitle(drink.drinks, for: .normal)
                        self.priceLabel.text = "\(drink.price)"
                        
                        self.clearDrinkInfo()
                    }
                    controller.addAction(action)
                }
                self.present(controller, animated: true)
            }
            
        })
    }
    
    
    // MARK: Real Action - 填好表單按下送出時 - 做新增 or 修改的判斷
    @IBAction func confrimDrinkOrder(_ sender: Any) {
        
        let drink = OrderInfo(name: nameTextField.text ?? "", drinks: drinkButton.currentTitle ?? "" , price: priceLabel.text ?? "", size: size.rawValue, sweetness: sugar.rawValue, ice: ice.rawValue, tapioca: addFood)
        
        
        let editDrinkData = UploadDrinkData(data: drink)
        
        let url: URL
        let method: String
        
        //修改用PUT，新增用POST
        if let ediOrder = editOrder {
            url = URL(string: "https://sheetdb.io/api/v1/eili7urtrn56v/name/\(ediOrder.name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            method = "PUT"
        } else {
            url = URL(string: "https://sheetdb.io/api/v1/eili7urtrn56v")!
            method = "POST"
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(editDrinkData)
        
        //檢查上傳的JSON
        if let data = urlRequest.httpBody,
           let content = String(data: data, encoding: .utf8) {
            print(content)
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data,
               let dic = try? JSONDecoder().decode([String: Int].self, from: data),
               (dic["created"] == 1 || dic["updated"] == 1) {
                
                DispatchQueue.main.async {
                    if dic["created"] == 1 {
                        let alertController = UIAlertController(title: "飲料已加到購物車", message: "請至訂單列表做最後確認唷！", preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "好", style: .default) { (UIAlertAction) in
                            //按下完成跳回前頁
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else if dic["updated"] == 1 {
                        let alertController = UIAlertController(title: "飲料資訊已修改", message: "請至訂單列表做最後確認唷！", preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "好", style: .default) { (UIAlertAction) in
                            //按下完成跳回前頁
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            } else {
            }
        }.resume()
    }
    
    
    @IBAction func returnKeyboard(_ sender: Any) {
        resignFirstResponder()
    }
    
    
    
    // MARK: UI LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //自訂 tableview 的格線,沒有資料的cell欄位隱藏分隔線
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        if editOrder != nil {
            getDrinkRecord()
            
        } else {
            
        }
    }
    
}
    
    


