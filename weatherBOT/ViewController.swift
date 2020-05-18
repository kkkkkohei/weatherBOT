//
//  ViewController.swift
//  weatherBOT
//
//  Created by kohei morioka on 2020/05/18.
//  Copyright © 2020 kohei morioka. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var callTime = ""
    var latlng = ""
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        let startColor = UIColor(red: 2/255.0, green: 173/255.0, blue: 200/255.0, alpha: 1.0).cgColor
        let endColor = UIColor(red: 0/255.0, green: 220/255.0, blue: 172/255.0, alpha: 1.0).cgColor

        // viewの左上から右下へ
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // 値が変わった際のイベントを登録する.
        datePicker.addTarget(self, action: #selector(ViewController.onDidChangeDate(sender:)), for: .valueChanged)
        
        // ロケーションマネージャのセットアップ
        setupLocationManager()
        
    }
    
    
    
    // ロケーションマネージャのセットアップ
    func setupLocationManager(){
        locationManager = CLLocationManager()
        
        // 位置情報取得許可ダイアログの表示
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        
        // ステータスごとの処理
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            // 位置情報取得を開始
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc internal func onDidChangeDate(sender: UIDatePicker){
        
        // フォーマットを生成.
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "HH:mm"
        
        // 日付をフォーマットに則って取得.
        let mySelectedDate: NSString = myDateFormatter.string(from: sender.date) as NSString
        callTime = mySelectedDate as String
        print(callTime)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        <#code#>
    }


}

