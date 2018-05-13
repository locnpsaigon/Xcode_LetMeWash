//
//  LoginViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/14/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var selectedIndex = 0
    var wasInitControls = false
    var tapGesture:UITapGestureRecognizer!
    var tapGestureEditing:UITapGestureRecognizer!
    
    var segmentControl:UISegmentedControl!
    var scrollView:UIScrollView!
    var loginView:UIView!
    var registerView:UIView!
    
    // Login controls
    var phoneLabel:UILabel!
    var phoneInput:UITextField!
    var passwordLabel:UILabel!
    var passwordInput:UITextField!
    var forgetPasswordLabel:UILabel!
    var loginButton:UIButton!
    
    // Register controls
    var requiredInputLabel:UILabel!
    var fullNameLabel:UILabel!
    var fullNameInput:UITextField!
    var phoneLabel2:UILabel!
    var phoneInput2:UITextField!
    var emailLabel:UILabel!
    var emailInput:UITextField!
    var passwordLabel2:UILabel!
    var passwordInput2:UITextField!
    var passwordLabel3:UILabel!
    var passwordInput3:UITextField!
    var registerButton:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Đăng nhập/Đăng ký"
        self.view.backgroundColor = Colors.white
        
        // Custom indicator image
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.tapGestureEditing = UITapGestureRecognizer(target: self, action: #selector(dismissEditing))
        self.view.addGestureRecognizer(self.tapGestureEditing)
        
        initControls()
    }
    
    func initControls() {
        
        self.view.backgroundColor = UIColor.white
    
        // Segment control
        segmentControl = UISegmentedControl(items: ["Đăng nhập", "Đăng ký"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.tintColor = UIColor(rgb: 0xaa0635)
        segmentControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        self.view.addSubview(segmentControl)
        
        // ScrollView
        scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        
        // LoginView
        loginView = UIView()
        // loginView.backgroundColor = UIColor.cyan
        
        phoneLabel = UILabel()
        phoneLabel.text = "Số điện thoại:"
        phoneLabel.font = UIFont.systemFont(ofSize: 15)
        loginView.addSubview(phoneLabel)
        
        phoneInput = UITextField()
        phoneInput.text = "0909841682"
        phoneInput.placeholder = "Nhập số điện thoại"
        phoneInput.font = UIFont.systemFont(ofSize: 15)
        phoneInput.borderStyle = .roundedRect
        phoneInput.keyboardType = .default
        phoneInput.returnKeyType = .done
        phoneInput.autocorrectionType = .no
        phoneInput.clearButtonMode = .whileEditing
        loginView.addSubview(phoneInput)
        
        passwordLabel = UILabel()
        passwordLabel.text = "Mật khẩu:"
        passwordLabel.font = UIFont.systemFont(ofSize: 15)
        loginView.addSubview(passwordLabel)
        
        passwordInput = UITextField()
        passwordInput.text = "123456aA@"
        passwordInput.placeholder = "Nhập mật khẩu"
        passwordInput.font = UIFont.systemFont(ofSize: 15)
        passwordInput.borderStyle = .roundedRect
        passwordInput.keyboardType = .default
        passwordInput.returnKeyType = .done
        passwordInput.autocorrectionType = .no
        passwordInput.clearButtonMode = .whileEditing
        passwordInput.isSecureTextEntry = true
        loginView.addSubview(passwordInput)
        
        forgetPasswordLabel = UILabel()
        forgetPasswordLabel.text = "Quên mật khẩu?"
        forgetPasswordLabel.font = UIFont.systemFont(ofSize: 15)
        forgetPasswordLabel.textColor = Colors.blue
        forgetPasswordLabel.textAlignment = .right
        forgetPasswordLabel.isUserInteractionEnabled = true
        forgetPasswordLabel.addGestureRecognizer(tapGesture)
        forgetPasswordLabel.tag = 1000
        loginView.addSubview(forgetPasswordLabel)
        
        loginButton = UIButton()
        loginButton.layer.cornerRadius = 4
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(rgb: 0xefefef).cgColor
        loginButton.setTitle("Đăng nhập", for: .normal)
        loginButton.tintColor = UIColor.black
        loginButton.backgroundColor = Colors.blue
        loginButton.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
        loginView.addSubview(loginButton)
        
        // Register View
        registerView = UIView()
        // registerView.backgroundColor = UIColor.brown
        
        requiredInputLabel = UILabel()
        requiredInputLabel.text = "Bạn cần điền các mục"
        requiredInputLabel.font = UIFont.systemFont(ofSize: 13)
        registerView.addSubview(requiredInputLabel)
        
        fullNameLabel = UILabel()
        fullNameLabel.text = "Họ tên (*)"
        fullNameLabel.font = UIFont.systemFont(ofSize: 15)
        registerView.addSubview(fullNameLabel)

        fullNameInput = UITextField()
        fullNameInput.placeholder = "Nhập họ và tên"
        fullNameInput.font = UIFont.systemFont(ofSize: 15)
        fullNameInput.borderStyle = .roundedRect
        fullNameInput.keyboardType = .default
        fullNameInput.returnKeyType = .done
        fullNameInput.autocorrectionType = .no
        fullNameInput.clearButtonMode = .whileEditing
        registerView.addSubview(fullNameInput)
        
        phoneLabel2 = UILabel()
        phoneLabel2.text = "Số điện thoại (*)"
        phoneLabel2.font = UIFont.systemFont(ofSize: 15)
        registerView.addSubview(phoneLabel2)
        
        phoneInput2 = UITextField()
        phoneInput2.placeholder = "Nhập số điện thoại"
        phoneInput2.font = UIFont.systemFont(ofSize: 15)
        phoneInput2.borderStyle = .roundedRect
        phoneInput2.keyboardType = .default
        phoneInput2.returnKeyType = .done
        phoneInput2.autocorrectionType = .no
        phoneInput2.clearButtonMode = .whileEditing
        registerView.addSubview(phoneInput2)
        
        emailLabel = UILabel()
        emailLabel.text = "Email (*)"
        emailLabel.font = UIFont.systemFont(ofSize: 15)
        registerView.addSubview(emailLabel)
        
        emailInput = UITextField()
        emailInput.placeholder = "Nhập địa chỉ email"
        emailInput.font = UIFont.systemFont(ofSize: 15)
        emailInput.borderStyle = .roundedRect
        emailInput.keyboardType = .default
        emailInput.returnKeyType = .done
        emailInput.autocorrectionType = .no
        emailInput.clearButtonMode = .whileEditing
        registerView.addSubview(emailInput)

        passwordLabel2 = UILabel()
        passwordLabel2.text = "Mật khẩu (*)"
        passwordLabel2.font = UIFont.systemFont(ofSize: 15)
        registerView.addSubview(passwordLabel2)
        
        passwordInput2 = UITextField()
        passwordInput2.placeholder = "Nhập mật khẩu"
        passwordInput2.font = UIFont.systemFont(ofSize: 15)
        passwordInput2.borderStyle = .roundedRect
        passwordInput2.keyboardType = .default
        passwordInput2.returnKeyType = .done
        passwordInput2.autocorrectionType = .no
        passwordInput2.clearButtonMode = .whileEditing
        passwordInput2.isSecureTextEntry = true
        registerView.addSubview(passwordInput2)

        passwordLabel3 = UILabel()
        passwordLabel3.text = "Nhập lại mật khẩu (*)"
        passwordLabel3.font = UIFont.systemFont(ofSize: 15)
        registerView.addSubview(passwordLabel3)
        
        passwordInput3 = UITextField()
        passwordInput3.placeholder = "Nhập lại mật khẩu"
        passwordInput3.font = UIFont.systemFont(ofSize: 15)
        passwordInput3.borderStyle = .roundedRect
        passwordInput3.keyboardType = .default
        passwordInput3.returnKeyType = .done
        passwordInput3.autocorrectionType = .no
        passwordInput3.clearButtonMode = .whileEditing
        passwordInput3.isSecureTextEntry = true
        registerView.addSubview(passwordInput3)
        
        registerButton = UIButton()
        registerButton.layer.cornerRadius = 4
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = Colors.lightGray.cgColor
        registerButton.setTitle("Đăng ký tài khoản", for: .normal)
        registerButton.tintColor = UIColor.white
        registerButton.backgroundColor = Colors.blue
        registerButton.addTarget(self, action: #selector(register(_:)), for: .touchUpInside)
        registerView.addSubview(registerButton)
        
        // Set default selected view
        segmentControl.selectedSegmentIndex = selectedIndex
        scrollView.addSubview(loginView)
        
        wasInitControls = true
    }
    
    func relayoutControls(frameSize: CGSize) {
        
        if wasInitControls == false { return }
        
        var topPos = CGFloat(0)
        
        switch UIDevice.current.orientation{
        case .portrait:
            topPos = 72
        case .portraitUpsideDown:
            topPos = 72
        case .landscapeLeft:
            topPos = 44
        case .landscapeRight:
            topPos = 44
        default:
            // Another
            break
        }

        // Segment control
        segmentControl.frame.origin.x = (frameSize.width - segmentControl.frame.width) / 2
        segmentControl.frame.origin.y = topPos
        
        // ScrollView
        scrollView.frame = CGRect(
            x: 0,
            y: segmentControl.frame.origin.y + segmentControl.frame.height + 8,
            width: frameSize.width,
            height: frameSize.height - segmentControl.frame.origin.y - segmentControl.frame.height - 58)
        
        // LoginView
        let loginSize = CGSize(width: 300, height: 300)
        loginView.frame.origin.x = (frameSize.width - loginSize.width) / 2
        loginView.frame.origin.y = 8
        loginView.frame.size = loginSize
        
        phoneLabel.frame.origin.x = 8
        phoneLabel.frame.origin.y = 8
        phoneLabel.frame.size.width = loginSize.width - 16
        phoneLabel.frame.size.height = 24
        
        phoneInput.frame.origin.x = 8
        phoneInput.frame.origin.y = phoneLabel.frame.origin.y + phoneLabel.frame.height + 4
        phoneInput.frame.size.width = loginSize.width - 16
        phoneInput.frame.size.height = 32
        
        passwordLabel.frame.origin.x = 8
        passwordLabel.frame.origin.y = phoneInput.frame.origin.y + phoneInput.frame.height + 4
        passwordLabel.frame.size.width = loginSize.width - 16
        passwordLabel.frame.size.height = 24

        passwordInput.frame.origin.x = 8
        passwordInput.frame.origin.y = passwordLabel.frame.origin.y + passwordLabel.frame.height + 4
        passwordInput.frame.size.width = loginSize.width - 16
        passwordInput.frame.size.height = 32

        forgetPasswordLabel.frame.origin.x = 8
        forgetPasswordLabel.frame.origin.y = passwordInput.frame.origin.y + passwordInput.frame.height + 4
        forgetPasswordLabel.frame.size.width = loginSize.width - 16
        forgetPasswordLabel.frame.size.height = 24
        
        loginButton.frame.origin.x = 8
        loginButton.frame.origin.y = forgetPasswordLabel.frame.origin.y + forgetPasswordLabel.frame.height + 4
        loginButton.frame.size.width = loginSize.width - 16
        loginButton.frame.size.height = 48
        
        loginView.frame.size.height = loginButton.frame.origin.y + loginButton.frame.height + 8
        
        
        // Register View
        let registerSize = CGSize(width: 300, height: 300)
        
        registerView.frame.origin.x = (frameSize.width - registerSize.width) / 2
        registerView.frame.origin.y = 8
        registerView.frame.size.width = registerSize.width
        registerView.frame.size.height = registerSize.height
        
        requiredInputLabel.frame.origin.x = 8
        requiredInputLabel.frame.origin.y = 8
        requiredInputLabel.frame.size.width = registerSize.width - 16
        requiredInputLabel.frame.size.height = 18
        
        fullNameLabel.frame.origin.x = 8
        fullNameLabel.frame.origin.y = requiredInputLabel.frame.origin.y + requiredInputLabel.frame.height + 4
        fullNameLabel.frame.size.width = registerSize.width - 16
        fullNameLabel.frame.size.height = 24
        
        fullNameInput.frame.origin.x = 8
        fullNameInput.frame.origin.y = fullNameLabel.frame.origin.y + fullNameLabel.frame.height + 4
        fullNameInput.frame.size.width = registerSize.width - 16
        fullNameInput.frame.size.height = 32
        
        phoneLabel2.frame.origin.x = 8
        phoneLabel2.frame.origin.y = fullNameInput.frame.origin.y + fullNameInput.frame.height + 4
        phoneLabel2.frame.size.width = registerSize.width - 16
        phoneLabel2.frame.size.height = 24
        
        phoneInput2.frame.origin.x = 8
        phoneInput2.frame.origin.y = phoneLabel2.frame.origin.y + phoneLabel2.frame.height + 4
        phoneInput2.frame.size.width = registerSize.width - 16
        phoneInput2.frame.size.height = 32
        
        emailLabel.frame.origin.x = 8
        emailLabel.frame.origin.y = phoneInput2.frame.origin.y + phoneInput2.frame.height + 4
        emailLabel.frame.size.width = registerSize.width - 16
        emailLabel.frame.size.height = 24
        
        emailInput.frame.origin.x = 8
        emailInput.frame.origin.y = emailLabel.frame.origin.y + emailLabel.frame.height + 4
        emailInput.frame.size.width = registerSize.width - 16
        emailInput.frame.size.height = 32
        
        passwordLabel2.frame.origin.x = 8
        passwordLabel2.frame.origin.y = emailInput.frame.origin.y + emailInput.frame.height + 4
        passwordLabel2.frame.size.width = registerSize.width - 16
        passwordLabel2.frame.size.height = 24
        
        passwordInput2.frame.origin.x = 8
        passwordInput2.frame.origin.y = passwordLabel2.frame.origin.y + passwordLabel2.frame.height + 4
        passwordInput2.frame.size.width = registerSize.width - 16
        passwordInput2.frame.size.height = 32
        
        passwordLabel3.frame.origin.x = 8
        passwordLabel3.frame.origin.y = passwordInput2.frame.origin.y + passwordInput2.frame.height + 4
        passwordLabel3.frame.size.width = registerSize.width - 16
        passwordLabel3.frame.size.height = 24
        
        passwordInput3.frame.origin.x = 8
        passwordInput3.frame.origin.y = passwordLabel3.frame.origin.y + passwordLabel3.frame.height + 4
        passwordInput3.frame.size.width = registerSize.width - 16
        passwordInput3.frame.size.height = 32
        
        registerButton.frame.origin.x = 8
        registerButton.frame.origin.y = passwordInput3.frame.origin.y + passwordInput3.frame.height + 12
        registerButton.frame.size.width = registerSize.width - 16
        registerButton.frame.size.height = 48
        
        registerView.frame.size.height = registerButton.frame.origin.y + registerButton.frame.height + 8

        // Set scrollView content size
        switch selectedIndex {
        case 0:
            scrollView.contentSize.height = loginView.frame.origin.y + loginView.frame.height + 8
            break
            
        case 1:
            scrollView.contentSize.height = registerView.frame.origin.y + registerView.frame.height + 8
            break
            
        default:
            break
        }
    }
    
    @objc func dismissEditing() {
        self.view.endEditing(true)
    }
    
    @objc func indexChanged(_ sender: AnyObject) {
        
        selectedIndex = segmentControl.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            print("Login")
            registerView.removeFromSuperview()
            scrollView.addSubview(loginView)
            break
        case 1:
            print("Register")
            loginView.removeFromSuperview()
            scrollView.addSubview(registerView)
            break
        default:
            break
        }
        
        relayoutControls(frameSize: self.view.bounds.size)
    }
    
    @objc func login(_ sender: AnyObject) {
        print("Login")
        let phone = phoneInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordInput.text ?? ""
        
        if phone == "" {
            phoneInput.becomeFirstResponder()
            let alert = UIAlertController(title: "Đăng nhập", message: "Vui lòng nhập số điện thoại", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if password == "" {
            phoneInput.becomeFirstResponder()
            let alert = UIAlertController(title: "Đăng nhập", message: "Vui lòng nhập mật khẩu", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Show loading
        let loadVC = LoadingViewController()
        loadVC.message = "Đang đăng nhập..."
        loadVC.modalPresentationStyle = .overCurrentContext
        loadVC.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(loadVC, animated: true, completion: nil)
        APIService.login(phone: phone, password: password, handler: {(user, message) in
            let nc = NotificationCenter.default
            nc.post(name: NSNotification.Name(rawValue: "dismissLoading"), object: nil)
            if user != nil {
                // Success
                GlobalCache.logonUser = user
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                // Login fail
                GlobalCache.logonUser = nil
                let alert = UIAlertController(title: "Đăng nhập", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func recoveryPassword(_ sender: AnyObject) {
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        let vc = RecoveryPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func register(_ sender: AnyObject) {
        print("Register")
        let fullname = fullNameInput.text ?? ""
        let phone = phoneInput2.text ?? ""
        let email = emailInput.text ?? ""
        let password2 = passwordInput2.text ?? ""
        let password3 = passwordInput3.text ?? ""
        
        if fullname == "" {
            fullNameInput.becomeFirstResponder()
            let alert = UIAlertController(title: "Đăng ký tài khoản", message: "Vui lòng nhập Họ tên", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if phone == "" {
            phoneInput2.becomeFirstResponder()
            let alert = UIAlertController(title: "Đăng ký tài khoản", message: "Vui lòng nhập Số điện thoại", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if password2 == "" {
            passwordInput2.becomeFirstResponder()
            let alert = UIAlertController(title: "Đăng ký tài khoản", message: "Vui lòng nhập mật khẩu", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if password2 != password3 {
            passwordInput3.becomeFirstResponder()
            let alert = UIAlertController(title: "Đăng ký tài khoản", message: "Mật khẩu và mật khẩu xác nhận phải giống nhau", preferredStyle: .alert)
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
        APIService.register(fullname: fullname, phone: phone, password: password2, email: email, handler: {(success, user, message) in
            let nc = NotificationCenter.default
            nc.post(name: NSNotification.Name(rawValue: "dismissLoading"), object: nil)
            if success {
                GlobalCache.logonUser = user
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                let alert = UIAlertController(title: "Đăng ký tài khoản", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let view = sender.view as? UILabel else { return }
        if view.tag == forgetPasswordLabel.tag {
            recoveryPassword(sender)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        relayoutControls(frameSize: self.view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        relayoutControls(frameSize: size)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
