//
//  ViewController.swift
//  weatherBOT
//
//  Created by kohei morioka on 2020/05/18.
//  Copyright © 2020 kohei morioka. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    // 通知時間
    var callTime = ""
    // 緯度
    var latitudeNow: String = ""
    // 経度
    var longitudeNow: String = ""
    
    // ロケーションマネージャ
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
        
        // 位置情報を記録
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        } else if status == .authorizedWhenInUse {
            print("\(latitudeNow), \(longitudeNow)")
        }
        
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
    
    // アラートを表示する
    func showAlert() {
        let alertTitle = "位置情報取得が許可されていません。"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert
        )
        // okボタン
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK", style: UIAlertAction.Style.default, handler: nil
        )
        // UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
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


}

extension ViewController: CLLocationManagerDelegate {
    
    /// 位置情報が更新された際、位置情報を格納する
    /// - Parameters:
    ///   - manager: ロケーションマネージャ
    ///   - locations: 位置情報
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        // 位置情報を格納する
        self.latitudeNow = String(latitude!)
        self.longitudeNow = String(longitude!)
        
    }
}

