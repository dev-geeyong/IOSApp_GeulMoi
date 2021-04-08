//
//  Extensions.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/04/08.
//
import UIKit
import JGProgressHUD
import MessageUI
extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    

    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }

}

