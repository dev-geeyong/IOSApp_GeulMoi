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
    
    let imageResources = [
        ImageSource(image: UIImage(named: "1")!),
        ImageSource(image: UIImage(named: "2")!),
        ImageSource(image: UIImage(named: "3")!),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.setImageInputs(imageResources)
        onboardingView.pageIndicatorPosition = .init(horizontal: .center, vertical: .top)
        onboardingView.contentScaleMode = .scaleAspectFit
    }
    @IBAction func onAllowBluetooth(_ sender: Any) {
        print(#function)
        Core.shared.setIsNotNewUser()
        dismiss(animated: true, completion: nil)
    }
    
}
