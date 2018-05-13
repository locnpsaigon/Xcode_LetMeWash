//
//  CheckOutViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/22/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class CheckOutViewController: UIViewController {
    
    var scrollView:UIScrollView!
    var phoneLabel:UILabel!
    var fullnameLabel:UILabel!
    var addressLabel:UILabel!
    var noteLabel:UILabel!
    
    var phoneInput:UITextField!
    var fullnameInput:UITextField!
    var addressInput:UITextField!
    var noteInput:UITextView!

    var loginButton:UIButton!
    var confirmOrderButton:UIButton!
    
    var wasInitControls = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Xác nhận thanh toán"
        self.view.backgroundColor = Colors.white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissEditing))
        self.view.addGestureRecognizer(tap)
        
        initControls()
        
    }
    
    @objc func dismissEditing() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        relayoutControls(frameSize: self.view.bounds.size)
        
        if GlobalCache.logonUser != nil {
            showUserInfo(user: GlobalCache.logonUser!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        relayoutControls(frameSize: size)
    }
    
    func initControls() {
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        
        // Create lables
        phoneLabel = UILabel()
        phoneLabel.text = "Số điện thoại (*):"
        phoneLabel.font = UIFont.systemFont(ofSize: 15)
        scrollView.addSubview(phoneLabel)
        
        fullnameLabel = UILabel()
        fullnameLabel.text = "Họ tên khách hàng (*)"
        fullnameLabel.font = UIFont.systemFont(ofSize: 15)
        scrollView.addSubview(fullnameLabel)
        
        addressLabel = UILabel()
        addressLabel.text = "Vị trí xe:"
        addressLabel.font = UIFont.systemFont(ofSize: 15)
        scrollView.addSubview(addressLabel)
        
        noteLabel = UILabel()
        noteLabel.text = "Ghi chú:"
        noteLabel.font = UIFont.systemFont(ofSize: 15)
        scrollView.addSubview(noteLabel)
        
        // create text fields
        phoneInput = UITextField()
        phoneInput.placeholder = "Nhập số điện thoại"
        phoneInput.font = UIFont.systemFont(ofSize: 15)
        phoneInput.borderStyle = .roundedRect
        phoneInput.keyboardType = .default
        phoneInput.returnKeyType = .done
        phoneInput.autocorrectionType = .no
        phoneInput.clearButtonMode = .whileEditing
        scrollView.addSubview(phoneInput)
        
        fullnameInput = UITextField()
        fullnameInput.placeholder = "Nhập họ tên khách hàng"
        fullnameInput.font = UIFont.systemFont(ofSize: 15)
        fullnameInput.borderStyle = .roundedRect
        fullnameInput.keyboardType = .default
        fullnameInput.returnKeyType = .done
        fullnameInput.autocorrectionType = .no
        fullnameInput.clearButtonMode = .whileEditing
        scrollView.addSubview(fullnameInput)
        
        addressInput = UITextField()
        addressInput.placeholder = "Nhập vị trí xe"
        addressInput.font = UIFont.systemFont(ofSize: 15)
        addressInput.borderStyle = .roundedRect
        addressInput.keyboardType = .default
        addressInput.returnKeyType = .done
        addressInput.autocorrectionType = .no
        addressInput.clearButtonMode = .whileEditing
        scrollView.addSubview(addressInput)
        
        noteInput = UITextView()
        noteInput.font = UIFont.systemFont(ofSize: 15)
        noteInput.layer.borderWidth = 1
        noteInput.layer.borderColor = Colors.gray.cgColor
        noteInput.layer.cornerRadius = 5
        noteInput.keyboardType = .default
        noteInput.returnKeyType = .done
        noteInput.autocorrectionType = .no
        scrollView.addSubview(noteInput)
        
        loginButton = UIButton()
        loginButton.layer.cornerRadius = 4
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = Colors.lightGray.cgColor
        loginButton.setTitle("Đăng nhập", for: .normal)
        loginButton.tintColor = UIColor.white
        loginButton.backgroundColor = Colors.blue
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        scrollView.addSubview(loginButton)
        
        confirmOrderButton = UIButton()
        confirmOrderButton.layer.cornerRadius = 4
        confirmOrderButton.layer.borderWidth = 1
        confirmOrderButton.layer.borderColor = Colors.lightGray.cgColor
        confirmOrderButton.setTitle("Xác nhận thanh toán", for: .normal)
        confirmOrderButton.tintColor = UIColor.black
        confirmOrderButton.backgroundColor = UIColor.orange
        confirmOrderButton.addTarget(self, action: #selector(checkOut), for: .touchUpInside)
        scrollView.addSubview(confirmOrderButton)
        
        wasInitControls = true
        
    }
    
    func relayoutControls(frameSize:CGSize) {
        if !wasInitControls {
            return
        }
        
        scrollView.frame.origin.x = 0
        scrollView.frame.origin.y = 0
        scrollView.frame.size = frameSize
        
        phoneLabel.frame.origin.x = 8
        phoneLabel.frame.origin.y = 8
        phoneLabel.frame.size.width = frameSize.width - 16
        phoneLabel.frame.size.height = 24
        
        phoneInput.frame.origin.x = 8
        phoneInput.frame.origin.y = phoneLabel.frame.origin.y + phoneLabel.frame.height
        phoneInput.frame.size.width = frameSize.width - 16
        phoneInput.frame.size.height = 32

        fullnameLabel.frame.origin.x = 8
        fullnameLabel.frame.origin.y = phoneInput.frame.origin.y + phoneInput.frame.height + 4
        fullnameLabel.frame.size.width = frameSize.width - 16
        fullnameLabel.frame.size.height = 24
        
        fullnameInput.frame.origin.x = 8
        fullnameInput.frame.origin.y = fullnameLabel.frame.origin.y + fullnameLabel.frame.height
        fullnameInput.frame.size.width = frameSize.width - 16
        fullnameInput.frame.size.height = 32

        addressLabel.frame.origin.x = 8
        addressLabel.frame.origin.y = fullnameInput.frame.origin.y + fullnameInput.frame.height + 4
        addressLabel.frame.size.width = frameSize.width - 16
        addressLabel.frame.size.height = 24
        
        addressInput.frame.origin.x = 8
        addressInput.frame.origin.y = addressLabel.frame.origin.y + addressLabel.frame.height
        addressInput.frame.size.width = frameSize.width - 16
        addressInput.frame.size.height = 32

        noteLabel.frame.origin.x = 8
        noteLabel.frame.origin.y = addressInput.frame.origin.y + addressInput.frame.height + 4
        noteLabel.frame.size.width = frameSize.width - 16
        noteLabel.frame.size.height = 24
        
        noteInput.frame.origin.x = 8
        noteInput.frame.origin.y = noteLabel.frame.origin.y + noteLabel.frame.height
        noteInput.frame.size.width = frameSize.width - 16
        noteInput.frame.size.height = 60
        
        if GlobalCache.logonUser != nil {
            loginButton.removeFromSuperview()
            
            showUserInfo(user: GlobalCache.logonUser!)
            
            confirmOrderButton.frame.origin.x = 8
            confirmOrderButton.frame.origin.y = noteInput.frame.origin.y + noteInput.frame.height + 8
            confirmOrderButton.frame.size.width = frameSize.width - 16
            confirmOrderButton.frame.size.height = 48
        } else {
            scrollView.addSubview(loginButton)
            
            loginButton.frame.origin.x = 8
            loginButton.frame.origin.y = noteInput.frame.origin.y + noteInput.frame.height + 8
            loginButton.frame.size.width = frameSize.width - 16
            loginButton.frame.size.height = 48
            
            confirmOrderButton.frame.origin.x = 8
            confirmOrderButton.frame.origin.y = loginButton.frame.origin.y + loginButton.frame.height + 4
            confirmOrderButton.frame.size.width = frameSize.width - 16
            confirmOrderButton.frame.size.height = 48
        }

        scrollView.contentSize.width = frameSize.width
        scrollView.contentSize.height = confirmOrderButton.frame.origin.y + confirmOrderButton.frame.height + 8
    }
    
    func showUserInfo(user:User) {
        phoneInput.text = user.phone ?? ""
        fullnameInput.text = user.fullname ?? ""
        addressInput.text = user.address ?? ""
    }
    
    @objc func login() {
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func checkOut() {
        let phone = phoneInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let fullname = fullnameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let address = addressInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let note = noteInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        var serviceBookings:[ServiceBooking] = []
        
        // Create service bookings
        for item in Cart.cartItems {
            let sb = ServiceBooking()
            sb.groupId = item.service?.groupId ?? 0
            sb.groupName = item.service?.groupName ?? ""
            sb.serviceId = item.service?.serviceId ?? 0
            sb.serviceName = item.service?.serviceName ?? ""
            sb.totalAmount = item.getTotalAmount()
            sb.discountAmount = item.getDiscountAmount()
            sb.paymentAmount = item.getPaymentAmount()
            for details in item.serviceDetails {
                sb.details.append(details)
            }
            serviceBookings.append(sb)
        }
        
        // Validate data
        if phone == "" {
            phoneInput.becomeFirstResponder()
            let alert = UIAlertController(title: "Lưu đơn hàng", message: "Vui lòng nhập số điện thoại", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Show loading status
        let loadVC = LoadingViewController()
        loadVC.message = "Đang xử lý..."
        loadVC.modalPresentationStyle = .overCurrentContext
        loadVC.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(loadVC, animated: true, completion: nil)
        
        // Call api to save order
        APIService.saveOrder(
            phone: phone,
            fullname: fullname,
            address: address,
            note: note,
            serviceBookings: serviceBookings,
            handler: {(success, message) in

            // Dismiss loading status
            let nc = NotificationCenter.default
            nc.post(name: NSNotification.Name(rawValue: "dismissLoading"), object: nil)

            if success {
                Cart.removeAllItems()
                let alert = UIAlertController(title: "Lưu đơn hàng", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: {(alert: UIAlertAction!) in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        self.navigationController?.popToRootViewController(animated: true)
                        self.tabBarController?.selectedIndex = 1
                        self.tabBarController?.tabBar.isHidden = false
                    })
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Đổi mật khẩu", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
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
