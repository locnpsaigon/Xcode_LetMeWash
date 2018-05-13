//
//  RecoveryPasswordViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/17/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class RecoveryPasswordViewController: UIViewController {

    
    var scrollView:UIScrollView!
    var recoveryPasswordView:UIView!
    var phoneInputLabel:UILabel!
    var phoneInput:UITextField!
    var emailInputLabel:UILabel!
    var emailInput:UITextField!
    var recoveryButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Khôi phục mật khẩu"
        self.view.backgroundColor = Colors.white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissEditing))
        self.view.addGestureRecognizer(tap)
        
        initControls()
        relayoutControls(frameSize: self.view.bounds.size)
    }
    
    @objc func dismissEditing() {
        self.view.endEditing(true)
    }
    
    func initControls() {
        
        scrollView = UIScrollView()
        // scrollView.backgroundColor = UIColor.blue
        self.view.addSubview(scrollView)
        
        recoveryPasswordView = UIView()
        // recoveryPasswordView.backgroundColor = UIColor.cyan
        scrollView.addSubview(recoveryPasswordView)
        
        phoneInputLabel = UILabel()
        phoneInputLabel.text = "Số điện thoại (*):"
        phoneInputLabel.font = UIFont.systemFont(ofSize: 15)
        recoveryPasswordView.addSubview(phoneInputLabel)
        
        phoneInput = UITextField()
        phoneInput.text = "0909841682"
        phoneInput.placeholder = "Nhập số điện thoại"
        phoneInput.font = UIFont.systemFont(ofSize: 15)
        phoneInput.borderStyle = .roundedRect
        phoneInput.keyboardType = .default
        phoneInput.returnKeyType = .done
        phoneInput.autocorrectionType = .no
        phoneInput.clearButtonMode = .whileEditing
        recoveryPasswordView.addSubview(phoneInput)

        emailInputLabel = UILabel()
        emailInputLabel.text = "Địa chỉ email (*):"
        emailInputLabel.font = UIFont.systemFont(ofSize: 15)
        recoveryPasswordView.addSubview(emailInputLabel)
        
        emailInput = UITextField()
        emailInput.text = "locnp.saigon@gmail.com"
        emailInput.placeholder = "Nhập số điện thoại"
        emailInput.font = UIFont.systemFont(ofSize: 15)
        emailInput.borderStyle = .roundedRect
        emailInput.keyboardType = .default
        emailInput.returnKeyType = .done
        emailInput.autocorrectionType = .no
        emailInput.clearButtonMode = .whileEditing
        recoveryPasswordView.addSubview(emailInput)

        recoveryButton = UIButton()
        recoveryButton.layer.cornerRadius = 4
        recoveryButton.layer.borderWidth = 1
        recoveryButton.layer.borderColor = Colors.lightGray.cgColor
        recoveryButton.setTitle("Khôi phục mật khẩu", for: .normal)
        recoveryButton.tintColor = UIColor.white
        recoveryButton.backgroundColor = Colors.blue
        recoveryButton.addTarget(self, action: #selector(recoveryPassword), for: .touchUpInside)
        recoveryPasswordView.addSubview(recoveryButton)
        
    }
    
    func relayoutControls(frameSize:CGSize) {
    
        scrollView.frame.origin.x = 0
        scrollView.frame.origin.y = 0
        scrollView.frame.size = frameSize
        
        let recoveryFrameSize = CGSize(width: 300, height: 300)
        recoveryPasswordView.frame.origin.x = (frameSize.width - recoveryFrameSize.width) / 2
        recoveryPasswordView.frame.origin.y = 16
        recoveryPasswordView.frame.size = recoveryFrameSize
        
        phoneInputLabel.frame.origin.x = 8
        phoneInputLabel.frame.origin.y = 8
        phoneInputLabel.frame.size.width = recoveryFrameSize.width - 16
        phoneInputLabel.frame.size.height = 24
        
        phoneInput.frame.origin.x = 8
        phoneInput.frame.origin.y = phoneInputLabel.frame.origin.y + phoneInputLabel.frame.height + 4
        phoneInput.frame.size.width = recoveryFrameSize.width - 16
        phoneInput.frame.size.height = 32
        
        emailInputLabel.frame.origin.x = 8
        emailInputLabel.frame.origin.y = phoneInput.frame.origin.y + phoneInput.frame.height + 4
        emailInputLabel.frame.size.width = recoveryFrameSize.width - 16
        emailInputLabel.frame.size.height = 24
        
        emailInput.frame.origin.x = 8
        emailInput.frame.origin.y = emailInputLabel.frame.origin.y + emailInputLabel.frame.height + 4
        emailInput.frame.size.width = recoveryFrameSize.width - 16
        emailInput.frame.size.height = 32

        recoveryButton.frame.origin.x = 8
        recoveryButton.frame.origin.y = emailInput.frame.origin.y + emailInput.frame.height + 16
        recoveryButton.frame.size.width = recoveryFrameSize.width - 16
        recoveryButton.frame.size.height = 48
        
        recoveryPasswordView.frame.size.height = recoveryButton.frame.origin.y + recoveryButton.frame.height + 8
        scrollView.contentSize.height = recoveryPasswordView.frame.origin.y + recoveryPasswordView.frame.height + 8
    }
    
    @objc func recoveryPassword() {
        let phone = phoneInput.text ?? ""
        let email = emailInput.text ?? ""
        
        if phone == "" {
            phoneInput.becomeFirstResponder()
            let alert = UIAlertController(title: "Khôi phục mật khẩu", message: "Vui lòng nhập số điện thoại", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if email == "" {
            emailInput.becomeFirstResponder()
            let alert = UIAlertController(title: "Khôi phục mật khẩu", message: "Vui lòng nhập địa chỉ email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Show loading
        let loadVC = LoadingViewController()
        loadVC.message = "Đang xử lý..."
        loadVC.modalPresentationStyle = .overCurrentContext
        loadVC.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(loadVC, animated: true, completion: nil)
        APIService.recoveryPassword(phone: phone, email: email, handler: {(success, message) in
            let nc = NotificationCenter.default
            nc.post(name: NSNotification.Name(rawValue: "dismissLoading"), object: nil)
            let alert = UIAlertController(title: "Khôi phục mật khẩu", message: message, preferredStyle: .alert)
            if success {
                alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: {(alert: UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                }))
            } else {
                alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            }
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        relayoutControls(frameSize: size)
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
