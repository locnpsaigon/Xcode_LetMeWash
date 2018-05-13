//
//  ChangePassViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/16/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class ChangePassViewController: UIViewController {

    var scrollView:UIScrollView!
    var changePassView:UIView!
    var currentPassLabel:UILabel!
    var currentPassInput:UITextField!
    var newPassLabel:UILabel!
    var newPassInput:UITextField!
    var newPassLabel2:UILabel!
    var newPassInput2:UITextField!
    var changePassButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Đổi mật khẩu"
        self.view.backgroundColor = Colors.white
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(dismissEditing))
        self.view.addGestureRecognizer(tapGuesture)
        
        initControls()
        relayoutControls(frameSize: self.view.bounds.size)
    }
    
    @objc func dismissEditing() {
        self.view.endEditing(true)
    }
    
    func initControls() {
        
        scrollView = UIScrollView()
        // scrollView.backgroundColor = UIColor.cyan
        self.view.addSubview(scrollView)
        
        changePassView = UIView()
        // changePassView.backgroundColor = UIColor.brown
        scrollView.addSubview(changePassView)
        
        currentPassLabel = UILabel()
        currentPassLabel.text = "Mật khẩu hiện tại (*):"
        currentPassLabel.font = UIFont.systemFont(ofSize: 15)
        changePassView.addSubview(currentPassLabel)
        
        currentPassInput = UITextField()
        currentPassInput.placeholder = "Mật khẩu hiện tại"
        currentPassInput.font = UIFont.systemFont(ofSize: 15)
        currentPassInput.borderStyle = .roundedRect
        currentPassInput.keyboardType = .default
        currentPassInput.returnKeyType = .done
        currentPassInput.autocorrectionType = .no
        currentPassInput.clearButtonMode = .whileEditing
        currentPassInput.isSecureTextEntry = true
        changePassView.addSubview(currentPassInput)

        newPassLabel = UILabel()
        newPassLabel.text = "Mật khẩu mới (*):"
        newPassLabel.font = UIFont.systemFont(ofSize: 15)
        changePassView.addSubview(newPassLabel)
        
        newPassInput = UITextField()
        newPassInput.placeholder = "Nhập mật khẩu mới"
        newPassInput.font = UIFont.systemFont(ofSize: 15)
        newPassInput.borderStyle = .roundedRect
        newPassInput.keyboardType = .default
        newPassInput.returnKeyType = .done
        newPassInput.autocorrectionType = .no
        newPassInput.clearButtonMode = .whileEditing
        newPassInput.isSecureTextEntry = true
        changePassView.addSubview(newPassInput)

        
        newPassLabel2 = UILabel()
        newPassLabel2.text = "Nhập lại mật khẩu (*):"
        newPassLabel2.font = UIFont.systemFont(ofSize: 15)
        changePassView.addSubview(newPassLabel2)
        
        newPassInput2 = UITextField()
        newPassInput2.placeholder = "Nhập lại mật khẩu"
        newPassInput2.font = UIFont.systemFont(ofSize: 15)
        newPassInput2.borderStyle = .roundedRect
        newPassInput2.keyboardType = .default
        newPassInput2.returnKeyType = .done
        newPassInput2.autocorrectionType = .no
        newPassInput2.clearButtonMode = .whileEditing
        newPassInput2.isSecureTextEntry = true
        changePassView.addSubview(newPassInput2)

        
        changePassButton = UIButton()
        changePassButton.layer.cornerRadius = 4
        changePassButton.layer.borderWidth = 1
        changePassButton.layer.borderColor = Colors.lightGray.cgColor
        changePassButton.setTitle("Đổi mật khẩu", for: .normal)
        changePassButton.tintColor = UIColor.white
        changePassButton.backgroundColor = Colors.blue
        changePassButton.addTarget(self, action: #selector(changePass(_:)), for: .touchUpInside)
        changePassView.addSubview(changePassButton)
    }
    
    func relayoutControls(frameSize:CGSize) {
        
        scrollView.frame.origin.x = 0
        scrollView.frame.origin.y = 0
        scrollView.frame.size = frameSize
        
        // Change password view
        let changePassSize = CGSize(width: 300, height: 300)
        changePassView.frame.origin.x = (frameSize.width - changePassSize.width)/2
        changePassView.frame.origin.y = 16
        changePassView.frame.size = changePassSize
        
        currentPassLabel.frame.origin.x = 8
        currentPassLabel.frame.origin.y = 8
        currentPassLabel.frame.size.width = changePassSize.width - 16
        currentPassLabel.frame.size.height = 24
        
        currentPassInput.frame.origin.x = 8
        currentPassInput.frame.origin.y = currentPassLabel.frame.origin.y + currentPassLabel.frame.height + 4
        currentPassInput.frame.size.width = changePassSize.width - 16
        currentPassInput.frame.size.height = 32
        
        newPassLabel.frame.origin.x = 8
        newPassLabel.frame.origin.y = currentPassInput.frame.origin.y + currentPassInput.frame.height + 8
        newPassLabel.frame.size.width = changePassSize.width - 16
        newPassLabel.frame.size.height = 24
        
        newPassInput.frame.origin.x = 8
        newPassInput.frame.origin.y = newPassLabel.frame.origin.y + newPassLabel.frame.height + 4
        newPassInput.frame.size.width = changePassSize.width - 16
        newPassInput.frame.size.height = 32

        
        newPassLabel2.frame.origin.x = 8
        newPassLabel2.frame.origin.y = newPassInput.frame.origin.y + newPassInput.frame.height + 4
        newPassLabel2.frame.size.width = changePassSize.width - 16
        newPassLabel2.frame.size.height = 24
        
        newPassInput2.frame.origin.x = 8
        newPassInput2.frame.origin.y = newPassLabel2.frame.origin.y + newPassLabel2.frame.height + 4
        newPassInput2.frame.size.width = changePassSize.width - 16
        newPassInput2.frame.size.height = 32

        changePassButton.frame.origin.x = 8
        changePassButton.frame.origin.y = newPassInput2.frame.origin.y + newPassInput2.frame.height + 12
        changePassButton.frame.size.width = changePassSize.width - 16
        changePassButton.frame.size.height = 48
        
        changePassView.frame.size.height = changePassButton.frame.origin.y + changePassButton.frame.height + 8
        
        scrollView.contentSize.height = changePassView.frame.origin.y + changePassView.frame.height + 8
    }
    
    @objc func changePass(_ sender: AnyObject) {
        let phone = GlobalCache.logonUser?.phone ?? ""
        let currentPass = currentPassInput.text ?? ""
        let newPass = newPassInput.text ?? ""
        let newPass2 = newPassInput2.text ?? ""
        
        if phone == "" {
            // Go login
            let backBtn = UIBarButtonItem()
            backBtn.title = ""
            self.navigationItem.backBarButtonItem = backBtn
            
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
            dismissChangePass()
        }
        
        
        if currentPass == "" {
            currentPassInput.becomeFirstResponder()
            let alert = UIAlertController(title: "Đổi mật khẩu", message: "Vui lòng nhập mật khẩu hiện tại", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if newPass == "" {
            newPassInput.becomeFirstResponder()
            let alert = UIAlertController(title: "Đổi mật khẩu", message: "Vui lòng nhập mật khẩu mới", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if newPass != newPass2 {
            newPassInput2.becomeFirstResponder()
            let alert = UIAlertController(title: "Đổi mật khẩu", message: "Mật khẩu và xác nhận mật khẩu phải giống nhau", preferredStyle: .alert)
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
        APIService.changePass(phone: phone, currentPass: currentPass, newPass: newPass, handler: {(success, message) in
            let nc = NotificationCenter.default
            nc.post(name: NSNotification.Name(rawValue: "dismissLoading"), object: nil)
            if success {
                self.dismissChangePass()
            } else {
                let alert = UIAlertController(title: "Đổi mật khẩu", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func dismissChangePass() {
        self.navigationController?.popViewController(animated: true)
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
