//
//  ViewController.swift
//  weatherBOT
//
//  Created by kohei morioka on 2020/05/18.
//  Copyright © 2020 kohei morioka. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    
    // 通知時間
    var callTime = ""
    
    let apiKey = "apikey"
    // 緯度
    var latitudeNow: Double = 0
    // 経度
    var longitudeNow: Double = 0
    
    // ロケーションマネージャ
    var locationManager: CLLocationManager!
    
    // loading
    var activityIndicator: NVActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 背景設定
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
        }
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        convertGeoCoding()
        
        AF.request("api.openweathermap.org/data/2.5/weather?lat=\(latitudeNow)&lon=\(longitudeNow)&appid=\(apiKey)&units=metric").responseJSON {
            
            response in
            
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.weatherImg.image = UIImage(named: iconName)
                print(jsonTemp)
            }
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
    
    func convertGeoCoding(){
        // 逆ジオコーディング
        let location = CLLocation(latitude: latitudeNow, longitude: longitudeNow)
        CLGeocoder().reverseGeocodeLocation(location) {placemarks, error in
            guard
                let placemark = placemarks?.first, error == nil, let locality = placemark.locality
                else {
                    self.locationLabel.text = "位置情報取得を許可して下さい。"
                    return
            }
            self.locationLabel.text = "\(locality)"
        }
    }
    
    /// 位置情報が更新された際、位置情報を格納する
    /// - Parameters:
    ///   - manager: ロケーションマネージャ
    ///   - locations: 位置情報
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        // 位置情報を格納する
        self.latitudeNow = latitude!
        self.longitudeNow = longitude!
        
        print("\(latitudeNow), \(longitudeNow)")
        
    }


}


