//
//  attend_deltaiViewController.swift
//  login
//
//  Created by Nguyen Thanh Long on 2019/11/05.
//  Copyright © 2019 Nguyen Thanh Long. All rights reserved.
//

import UIKit

class attend_deltaiViewController: UIViewController {

    
    @IBOutlet weak var tex: UITextView!
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = UserDefaults.standard.value(forKey: "attend_de") as! Array<Dictionary<String, Any>>
        let data2 = data[0]["naiyo"] as! String
        tex?.text = data2 as! String
        
        }
      //tex?.text =  formatter.string(from: data2 as! Date)
       // print(a)
        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
