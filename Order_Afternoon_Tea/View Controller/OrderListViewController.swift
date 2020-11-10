//
//  OrderListViewController.swift
//  Order_Afternoon_Tea
//
//  Created by Cooper on 2020/11/5.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var drinkListTableView: UITableView!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var totalDrinks: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var orderedList = [OrderInfo]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drinkListTableView.delegate = self
        drinkListTableView.dataSource = self
        startLoadingList()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        orderedList.removeAll()
        fetchDrinkOrder()
    }
    
    
    
    
    //抓取DB資料
    func fetchDrinkOrder () {
        URLSession.shared.dataTask(with: URL(string: "https://sheetdb.io/api/v1/eili7urtrn56v?")!) { (data, response, error) in
            if let data = data,
               let orders = try? JSONDecoder().decode([OrderInfo].self, from: data){
                
                self.orderedList = orders
                DispatchQueue.main.async {
                    self.stopLoadingList()
                    self.calculatePrice()
                    self.calculateCup()
                    self.drinkListTableView.reloadData()
                }
            }
            
        }.resume()
    }
    
    
    //訂單金額統計
    func calculatePrice () {
        var price = 0
        
        for i in 0 ..< orderedList.count {
            if let money = Int(orderedList[i].price){
                price += money
            }
        }
        totalPrice.text = "NT: \(price)"
    }
    
    //訂單杯數總計
    func calculateCup () {
        totalDrinks.text = "\(orderedList.count)"
    }
    
    //開始載入動畫
    func startLoadingList(){
        activityIndicator.startAnimating()
    }
    
    //停止載入動畫
    func stopLoadingList(){
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true   // 當停止動畫後隱藏
    }
    
    
    //MARK: Segue back to EditOrder
    //點擊任一 cell 欄位 帶資料至編輯飲料頁面
    @IBSegueAction func backToEditOrder(_ coder: NSCoder) -> TeaOrderTableViewController? {
        let controller = TeaOrderTableViewController(coder: coder)
        if let row = drinkListTableView.indexPathForSelectedRow?.row {
            controller?.editOrder = orderedList[row]
        }
        return controller
    }
    
    
    //MARK: TableView Func
    
    //得到要顯示的Cell，設定Cell的內容
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderedList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = drinkListTableView.dequeueReusableCell(withIdentifier: "\(OrderListTableViewCell.self)", for: indexPath) as! OrderListTableViewCell
        
        let order = orderedList[indexPath.row]
        cell.nameLabel.text = order.name
        cell.drinkLabel.text = order.drinks
        cell.priceLabel.text = String(order.price)
        cell.sizeLabel.text = order.size
        cell.sweetnessLabel.text = order.sweetness
        cell.iceLabel.text = order.ice
        cell.tapiocaLabel.text = order.tapioca
        
        cell.drinkPic.image = UIImage(named: "\(order.drinks)")
        return cell
    }
    
    //左滑 刪除
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        //MARK: 刪除,連線DB，依照 name 來刪除/\(drink.name)
        let delete = UIContextualAction(style: .normal, title: "DELETE") { (action, view, bool) in
            let order = self.orderedList[indexPath.row]
            let url = URL(string: "https://sheetdb.io/api/v1/eili7urtrn56v/name/\(order.name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data,
                   let dic = try? JSONDecoder().decode([String: Int].self, from: data),
                   dic["deleted"] == 1 {
                    
                    DispatchQueue.main.async {
                        self.orderedList.remove(at: indexPath.row)
                        self.drinkListTableView.deleteRows(at: [indexPath], with: .fade)
                        self.calculatePrice()
                        self.calculateCup()
                    }
                }
            }.resume()
        }
            
        delete.backgroundColor = .red
        
        //左滑到底時不做任何動作
        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
    }
    
    //假設 user 按了 "送出訂單" 就回到 首頁
    @IBAction func sendDrinkOrder(_ sender: Any) {
        let alert = UIAlertController(title: "訂單完成", message: "感謝您的購買，您的飲料將在15分鐘內送達！", preferredStyle: .alert)
        let ok = UIAlertAction(title: "好", style: .default) { (action) in
            //實際情況看要帶到哪一頁
        }

        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
  
}


