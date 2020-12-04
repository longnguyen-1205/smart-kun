//
//  attendanceViewController.swift
//  login
//
//  Created by Nguyen Thanh Long on 2019/11/01.
//  Copyright © 2019 Nguyen Thanh Long. All rights reserved.
//

import UIKit

class attendanceViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    var data : Array<Any>!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "attend", for: indexPath)
        let data1 = data[indexPath.row] as! Dictionary<String,Any>
        let a = data1["subject"] as! String
        let b = data1["time"] as! String
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = "\(a)\n\(b)"
        return cell
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
           var id = UserDefaults.standard.value(forKey: "id") as! String
           var pas =  UserDefaults.standard.value(forKey: "pas") as! String
        var no =  String(indexPath.row)
        waiting()
        self.take_detail(id,pas,no)
        
        
       }
    
    @IBOutlet weak var attend: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        attend.dataSource = self
        attend.delegate = self
        if UserDefaults.standard.value(forKey: "attendance") != nil{
            
            
            data = UserDefaults.standard.value(forKey: "attendance") as! Array<Any>
            
            
        }else{
            data = []
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidLoad()
        
        attend.reloadData()
    }
    // Do any additional setup after loading the view.
    
    func take_detail(_ id:String,_ pas:String,_ no:String){
            //let url = URL(string: "http://192.168.0.14:3000/all3") //dell
            //let url = URL(string: "http://192.168.0.10:3000/attendance_de") //fujitsu
            let url = URL(string: "https://longkslife.nw.is.kyusan-u.ac.jp:3000/attendance_de")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let datasend="id=" + id + "&pas=" + pas + "&no=" + no
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
                    let del = try! JSONSerialization.jsonObject(with: data) as! Array<Dictionary<String, Any>>
                    print(del)
                    UserDefaults.standard.set(del, forKey: "attend_de")
                    
                        
                                        
                    DispatchQueue.main.async(){
                        self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "attend_del", sender: self)
                        
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
        func timeout(){
            let alert: UIAlertController = UIAlertController(title: "アクセスができない", message: "タイムアウトしました", preferredStyle:  UIAlertController.Style.alert)
            present(alert, animated: true, completion: nil)
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel)
            
            alert.addAction(cancelAction)
            
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
    



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


