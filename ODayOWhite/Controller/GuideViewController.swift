//
//  GuideViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/21.
//

import UIKit
import ImageSlideshow

class GuideViewController: UIViewController {
    
    @IBOutlet weak var allowBluetooth: UIButton!
    @IBOutlet weak var onboardingView: ImageSlideshow!
    @IBOutlet var hideView: UIView!
    
    let imageResources = [
        ImageSource(image: UIImage(named: "1")!),
        ImageSource(image: UIImage(named: "2")!),
        ImageSource(image: UIImage(named: "3")!),
        ImageSource(image: UIImage(named: "4")!),
        ImageSource(image: UIImage(named: "5")!),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allowBluetooth.isHidden = true
        hideView.isHidden = true
        onboardingView.delegate = self
        onboardingView.setImageInputs(imageResources)
        onboardingView.pageIndicatorPosition = .init(horizontal: .center, vertical: .top)
        
        onboardingView.contentScaleMode = .scaleAspectFit
        print(onboardingView.slideshowItems.count)
    }
    @IBAction func onAllowBluetooth(_ sender: Any) {
        print(#function)
        Core.shared.setIsNotNewUser()
        dismiss(animated: true, completion: nil)
    }
    
}
extension GuideViewController: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print(page)
        if page == 4 {
            allowBluetooth.isHidden = false
            hideView.isHidden = false
        }
    }
    
}
