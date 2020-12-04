//
//  check_scence.swift
//  login
//
//  Created by Nguyen Thanh Long on 2019/10/31.
//  Copyright © 2019 Nguyen Thanh Long. All rights reserved.
//

import UIKit
import UserNotifications
class check_scence: UIViewController ,UNUserNotificationCenterDelegate{
  var database :Dictionary<String, Any>!
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
     

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async(){
                if UserDefaults.standard.value(forKey: "id") == nil{
                           self.performSegue(withIdentifier: "no_auto", sender: self)
                }else{
                //self.performSegue(withIdentifier: "no_auto", sender: self)
                   print(UserDefaults.standard.value(forKey: "id"))
                    var id = UserDefaults.standard.value(forKey: "id") as! String
                    var pas =  UserDefaults.standard.value(forKey: "pas") as! String
                    self.Dologin(id,pas)
                   
                       }
            self.userNotificationCenter.delegate = self
                                      self.requestNotificationAuthorization()

                       
            }
       
        
        }
    
        // Do any additional setup after loading the view.
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if UserDefaults.standard.value(forKey: "id") != nil{
        let d = segue.destination as! scheduleViewController
        d.data2 = database
        
        
    }*/
    
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
                UserDefaults.standard.set(self.database, forKey: "database")
    
                    DispatchQueue.main.async(){
                        self.performSegue(withIdentifier: "auto", sender: self)
                    }
                self.takeall()
                timerTest = Timer.scheduledTimer(timeInterval: 900, target: self, selector: #selector(self.takeall), userInfo: nil, repeats: true)
                
                
                
            }else {      //タイムアウト
            DispatchQueue.main.async(){
            print("timeout")
            self.timeout()
            }
            }
            
        }.resume()
        
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
                   // self.sendNotification("授業連絡",new_clas)
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
    func timeout(){
        let alert: UIAlertController = UIAlertController(title: "アクセスができない", message: "タイムアウトしました", preferredStyle:  UIAlertController.Style.alert)
        present(alert, animated: true, completion: nil)
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cancelAction)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
