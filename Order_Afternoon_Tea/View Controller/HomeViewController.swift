//
//  HomeViewController.swift
//  Order_Afternoon_Tea
//
//  Created by Cooper on 2020/11/4.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController {
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //因UITapGestureRecognizer 只能對應一個相同的View，固創建4個分別對應4個UIImageView

        let gesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.imageTap(gesture:)))
            image1.addGestureRecognizer(gesture)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.imageTap(gesture:)))
            image2.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.imageTap(gesture:)))
            image3.addGestureRecognizer(gesture3)
        
        
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.imageTap(gesture:)))
            image4.addGestureRecognizer(gesture4)
              
}
    
    
    
    func callAlert (){
        let alert = UIAlertController(title: "訂單完成", message: "感謝您的購買，您的飲料將在15分鐘內送達！", preferredStyle: .alert)
        let ok = UIAlertAction(title: "好", style: .default) { (action) in
            
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @objc func imageTap(gesture: UIGestureRecognizer) {
    //使用Safari Controller來開啟網頁
    //活動的網址日後可能會失效，可換成下面的官網測試
    //https://www.chunyangtea.com/index.php
     
        var url = URL(string: "")
        
        let tapped = gesture.view as! UIImageView
       
        switch tapped {
        case image1 :
            url = URL(string: "https:www.chunyangtea.com/news_detail.php?Key=69")
            let safariController = SFSafariViewController(url: url!)
            present(safariController, animated: true)
        case image2 :
            url = URL(string: "https:www.chunyangtea.com/news_detail.php?Key=68")
            let safariController = SFSafariViewController(url: url!)
            present(safariController, animated: true)
        case image3 :
            url = URL(string: "https:www.chunyangtea.com/news_detail.php?Key=67")
            let safariController = SFSafariViewController(url: url!)
            present(safariController, animated: true)
        case image4 :
            url = URL(string: "https:www.chunyangtea.com/news_detail.php?Key=66")
            let safariController = SFSafariViewController(url: url!)
            present(safariController, animated: true)
        default:
            print("")
        }
    }
    
    
    

  
}
