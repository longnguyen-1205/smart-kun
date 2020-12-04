//
//  scheduleViewController.swift
//  login
//
//  Created by Nguyen Thanh Long on 2019/09/20.
//  Copyright © 2019 Nguyen Thanh Long. All rights reserved.
//

import UIKit

class timetableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  UITabBarControllerDelegate {
   override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        k = 0
        data.text = getDate()
        table.reloadData()
        
    }
    
    var now = Date()
    var k = 0
    var q = 0
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var n: UIButton!
    @IBOutlet weak var b: UIButton!
    @IBAction func gonext(_ sender: Any) {
        
        k = (k+1) % 7
        q = 1
        data.text = getDate()
        table.reloadData()
    }
    @IBAction func goback(_ sender: Any) {
        k = (k-1) % 7
        q = -1
        data.text = getDate()
        table.reloadData()
    }
    var data2 :Dictionary<String, Any>!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        data2 = UserDefaults.standard.value(forKey: "database") as! Dictionary
        let timetable: Dictionary = data2["timetable"] as! Dictionary<String, Any>
        
        let i = getDate()
        let timetable0: Array = timetable[i] as! Array<Dictionary<String, String>>
        
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping
        let a = timetable0[indexPath.row]["subject"] as! String
        let b = timetable0[indexPath.row]["teacher"] as! String
        let c = timetable0[indexPath.row]["room"] as! String
        cell.textLabel?.text = "\(a)\n\(b)\n\(c)"
        let button = UIButton()
        
               
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    }
    func getDate() -> String  {
        let day = Calendar.current.date(byAdding: .day, value: k, to: now)!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEE", options: 0, locale:  Locale.current)
        var weekday = dateFormatter.string(from: day)
        if(weekday=="日" && q == 1){
            weekday = "月"
            k+=1
        }else if(weekday=="日" && q == -1){
            weekday = "土"
            k-=1
        }else if(weekday=="日"){
            weekday = "月"
        }
        return weekday
    }
    
    
    
    
    
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        //super.viewDidLoad()
        table.dataSource = self
        //let all3: Dictionary = data2["name"] as! Dictionary<String, String>
        var id = UserDefaults.standard.value(forKey: "id") as! String
        var pas =  UserDefaults.standard.value(forKey: "pas") as! String
        
        
        data.text = getDate()
        
    }
    
    func timeout(){
        let alert: UIAlertController = UIAlertController(title: "アクセスができない", message: "タイムアウトしました", preferredStyle:  UIAlertController.Style.alert)
        present(alert, animated: true, completion: nil)
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cancelAction)
        
    }
}


//print(data2)
//data?.text = name
// Do any additional setup after loading the view.




/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


