//
//  ViewController.swift
//  crawler
//
//  Created by Nguyen Thanh Long on 2019/04/13.
//  Copyright © 2019 Nguyen Thanh Long. All rights reserved.
//

import UIKit
import UserNotifications
var timerTest : Timer?
class ViewController: UIViewController ,UNUserNotificationCenterDelegate{
    var database :Dictionary<String, Any>!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _id: UITextField!
    @IBOutlet weak var login: UIButton!
    let userNotificationCenter = UNUserNotificationCenter.current()
    func requestNotificationAuthorization() {
        // Code here
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification(_ title:String,_ body:String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        //notificationContent.badge = NSNumber(value: 0)
        
        if let url = Bundle.main.url(forResource: "dune",
                                    withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                            url: url,
                                                            options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: title,
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
     
    override func viewDidLoad() {
       self.userNotificationCenter.delegate = self
                             self.requestNotificationAuthorization()
                            
       
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
 /*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! scheduleViewController
        destination.data2 = database
        
    }*/
    
    @IBAction func loginbutton(_ sender: UIButton) {
        
        let id = _id.text
        let pas = _password.text
        
        
            waiting()
            Dologin(id!,pas!)
            
        
       
       }
   
    
    
    
     func Dologin(_ id:String,_ pas:String){
        
        //let url = URL(string: "http://192.168.0.14:3000/all3") //dell
        //let url = URL(string: "http://192.168.0.10:3000/all3") //fujitsu
        let url = URL(string: "https://longkslife.nw.is.kyusan-u.ac.jp:3000/all3")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let datasend="id=" + id + "&pas=" + pas
        request.httpBody = datasend.data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                // JSONからDictionaryへ変換
                //                var data1 = try! JSONSerialization.jsonObject(with: data) as! [String :Any]
                //                let data2 = data1["name"] as! [String :Any]
                self.database = try! JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
              DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
              }
                if(!self.database.isEmpty){    //ログイン成功
                    
                    DispatchQueue.main.async(){
                         
                        UserDefaults.standard.set(self._id.text, forKey: "id")
                        UserDefaults.standard.set(self._password.text,forKey:"pas")
                        UserDefaults.standard.set(self.database, forKey: "database")
                        self.takeall()
                        self.performSegue(withIdentifier: "Dologin", sender: self)
                       
                       timerTest = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.takeall1), userInfo: nil, repeats: true)
                    }
                }else{        //ログイン失敗
                     DispatchQueue.main.async(){
                    print("ログイン失敗")
                    self.Loginfail()
                    }
                    
                }
                
                
            }else {      //タイムアウト
            DispatchQueue.main.async(){
                self.dismiss(animated: true, completion: nil)
            print("timeout")
            self.timeout()
            }
            }
            
        }.resume()
        
    }
    var i = 0
    @objc func takeall1(){
        i+=1
        print(i)
    }
    
    func Loginfail(){
        let alert: UIAlertController = UIAlertController(title: "アクセスができない", message: "IDまたはパスワードが間違いますか", preferredStyle:  UIAlertController.Style.alert)
        present(alert, animated: true, completion: nil)
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cancelAction)
        
        
    }
    func timeout(){
        let alert: UIAlertController = UIAlertController(title: "アクセスができない", message: "タイムアウトしました", preferredStyle:  UIAlertController.Style.alert)
        present(alert, animated: true, completion: nil)
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cancelAction)
        
    }
    @objc func takeall(){
        //let url = URL(string: "http://192.168.0.14:3000/all3") //dell
       // let url = URL(string: "http://192.168.0.10:3000/all2") //fujitsu
        let id = UserDefaults.standard.value( forKey: "id") as! String
        let pas = UserDefaults.standard.value(forKey:"pas") as! String
        let url = URL(string: "https://longkslife.nw.is.kyusan-u.ac.jp:3000/all2")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let datasend="id=" + id + "&pas=" + pas
        request.httpBody = datasend.data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                // JSONからDictionaryへ変換
                //                var data1 = try! JSONSerialization.jsonObject(with: data) as! [String :Any]
                //                let data2 = data1["name"] as! [String :Any]
                let all = try! JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
                //データ分散
                let attendance : Array = all["attendance"] as! Array<Dictionary<String, Any>>
                UserDefaults.standard.set(attendance, forKey: "attendance")
                let schedule : Array = all["schedule"] as! Array<Dictionary<String, Any>>
                 UserDefaults.standard.set(schedule, forKey: "schedule")
                let camp : Array = all["camp"] as! Array<Dictionary<String, Any>>
                UserDefaults.standard.set(camp, forKey: "camp")
                let clas : Array = all["clas"] as! Array<Dictionary<String, Any>>
                UserDefaults.standard.set(clas, forKey: "clas")
                //学内連絡
                let notify_camp = camp[0] as! Dictionary<String,Any>
                let new_camp = notify_camp["title"] as! String
                let new_camp_time = notify_camp["time"] as! String
                print(UserDefaults.standard.value(forKey: "newest_camp_time"))
                if(UserDefaults.standard.value(forKey: "newest_camp_time") != nil){
                   
               let newest_camp_time = UserDefaults.standard.value(forKey: "newest_camp_time") as! String
                    print(new_camp_time != newest_camp_time)
                    if(new_camp_time != newest_camp_time){
                      UserDefaults.standard.set(new_camp_time, forKey: "newest_camp_time")
                    self.sendNotification("学内連絡",new_camp)
                      }
                }else{
                    //self.sendNotification("学内連絡",new_camp)
                    UserDefaults.standard.set(new_camp_time, forKey: "newest_camp_time")
                }
                
                //授業連絡
                let notify_clas = clas[0] as! Dictionary<String,Any>
                  let a = notify_clas["title"] as! String
                  let b = notify_clas["subject"] as! String
                  let new_clas = a + b
                  
                  if(UserDefaults.standard.value(forKey: "newest_clas") != nil){
                   let newest_clas = UserDefaults.standard.value(forKey: "newest_clas") as! String
                    if(new_clas != newest_clas){
                      UserDefaults.standard.set(new_clas, forKey: "newest_clas")
                    self.sendNotification("授業連絡",new_clas)
                      }
                  }else{
                    UserDefaults.standard.set(new_clas, forKey: "newest_clas")
                    //self.sendNotification("授業連絡",new_clas)
                }
                  
                print("takeallした")
                
                
                
                
            }else {      //タイムアウト
                DispatchQueue.main.async(){
                    print("timeout")
                    self.timeout()
                }
            }
            
        }.resume()
        
    }
    func waiting(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
       // loadingIndicator.removeFromSuperview()
        //alert.dismiss(animated: false, completion: nil)
    }
    
    
}
