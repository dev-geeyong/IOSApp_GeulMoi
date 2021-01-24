//
//  PrivacyAgreementViewController.swift
//  ODayOWhite
//
//  Created by dev.geeyong on 2021/01/24.
//

import UIKit
import WebKit
class PrivacyAgreementViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://dev-geeyong.tistory.com/36")
        let request = URLRequest(url: url!)
        webView.load(request)
        // Do any additional setup after loading the view.
    }
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: .none)
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
