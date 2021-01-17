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
        self.delegate = self
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.overlap
        
        
        
        // Do any additional setup after loading the view.
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        let index = self.tabBar.items?.index(of: item)
        let subView = tabBar.subviews[index!+1].subviews.first as! UIImageView
        self.performSpringAnimation(imgView: subView)
    }

    //func to perform spring animation on imageview
    func performSpringAnimation(imgView: UIImageView) {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {

            imgView.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)

            //reducing the size
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                imgView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { (flag) in
            }
        }) { (flag) in

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

}
//extension TabBarController: UITabBarControllerDelegate{
//    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
//        print("Selected item")
//    }
//}
