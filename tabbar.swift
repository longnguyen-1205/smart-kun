//
//  tabbar.swift
//  login
//
//  Created by Nguyen Thanh Long on 2019/11/01.
//  Copyright © 2019 Nguyen Thanh Long. All rights reserved.
//

import UIKit

class tabbar: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // tell our UITabBarController subclass to handle its own delegate methods
        self.delegate = self
    }
    
   
    // called whenever a tab button is tapped
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController is timetableViewController {
        print("1st tab")
        } else if viewController is attendanceViewController {
            //print("Second tab")
        }
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


