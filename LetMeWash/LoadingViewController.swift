//
//  LoadingViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/14/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {
    
    var indicator:NVActivityIndicatorView!
    var statusLabel:UILabel!
    var message:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let frameW = self.view.frame.width
        let frameH = self.view.frame.height
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // Indicator
        indicator = NVActivityIndicatorView(
            frame: CGRect(x: frameW/2 - 24, y: frameH/2 - 24, width: 48, height: 48),
            type: .ballClipRotate,
            color: UIColor.white,
            padding: 0)
        indicator.type = .ballClipRotatePulse
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
        
        // Status messae label
        statusLabel = UILabel(frame: CGRect(
            x: 8,
            y: indicator.frame.origin.y + indicator.frame.height + 16,
            width: frameW - 16,
            height: 24))
        statusLabel.text = message
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textAlignment = .center
        statusLabel.textColor = UIColor.white
        self.view.addSubview(statusLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissLoading() -> Void {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(dismissLoading), name: Notification.Name("dismissLoading"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: Notification.Name("dismissLoading"), object: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
