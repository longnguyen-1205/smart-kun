//
//  detailViewController.swift
//  login
//
//  Created by Nguyen Thanh Long on 2019/11/03.
//  Copyright © 2019 Nguyen Thanh Long. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {
    
    
    @IBOutlet weak var notify_deltai: UITextView!
    @IBOutlet weak var notify_title: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var data = UserDefaults.standard.value(forKey: "del") as! Array<Any>
        let data2 : Dictionary = data[0] as! Dictionary<String,String>
        notify_title?.text = data2["title"] as! String
        notify_deltai?.text = data2["naiyo"] as! String

        // Do any additional setup after loading the view.
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
