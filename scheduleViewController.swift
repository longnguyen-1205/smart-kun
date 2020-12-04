//
//  scheduleViewController.swift
//  login
//
//  Created by Nguyen Thanh Long on 2019/11/03.
//  Copyright © 2019 Nguyen Thanh Long. All rights reserved.
//

import UIKit

class scheduleViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var data : Array<Any>!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data1 = data[indexPath.row] as! Dictionary<String,Any>
        
        let a = data1["date"] as! String
        let b = data1["event"] as! String
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = "\(a)\n\(b)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        if UserDefaults.standard.value(forKey: "schedule") != nil{
            
            
            data = UserDefaults.standard.value(forKey: "schedule") as! Array<Any>
            
            
        }else{
            data = []
        
    
        // Do any additional setup after loading the view.
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidLoad()
        
        table.reloadData()
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
