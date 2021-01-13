//
//  TabBarController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/13.
//

import UIKit
import  SwipeableTabBarController

class  TabBarController : SwipeableTabBarController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.overlap
        
        
        
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
