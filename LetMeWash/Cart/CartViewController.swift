//
//  CartViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/20/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class CartViewController: UIViewController { 

    var scrollView:UIScrollView!
    var totalAmountLabel:UILabel!
    var totalAmountValueLabel:UILabel!
    var checkoutButton:UIButton!
    var wasControlsInitialized = false
    
    var emptyCartView:UIView!
    var emptyCartIcon:UIImageView!
    var emptyCartLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Giỏ hàng (\(Cart.getItemsCount()))"
        self.view.backgroundColor = Colors.white
        
        initControls()
        showCart(frameSize: self.view.bounds.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Giỏ hàng (\(Cart.getItemsCount()))"
        showCart(frameSize: self.view.bounds.size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Show tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        showCart(frameSize: size)
    }
    
    func initControls() {
        scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        
        totalAmountLabel = UILabel()
        totalAmountLabel.text = "Tổng cộng:"
        totalAmountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        totalAmountLabel.textAlignment = .right
        self.view.addSubview(totalAmountLabel)
        
        totalAmountValueLabel = UILabel()
        totalAmountValueLabel.text = "0Đ"
        totalAmountValueLabel.font = UIFont.boldSystemFont(ofSize: 15)
        totalAmountValueLabel.textColor = Colors.pink
        totalAmountValueLabel.textAlignment = .right
        self.view.addSubview(totalAmountValueLabel)

        checkoutButton = UIButton()
        checkoutButton.layer.cornerRadius = 4
        checkoutButton.layer.borderWidth = 1
        checkoutButton.layer.borderColor = Colors.lightGray.cgColor
        checkoutButton.setTitle("Tiến hành thanh toán", for: .normal)
        checkoutButton.tintColor = UIColor.black
        checkoutButton.backgroundColor = Colors.orange
        checkoutButton.addTarget(self, action: #selector(checkOut), for: .touchUpInside)
        self.view.addSubview(checkoutButton)
        
        emptyCartView = UIView()
        
        emptyCartIcon = UIImageView()
        emptyCartIcon.image = UIImage(named: "ic_cart_empty")
        emptyCartView.addSubview(emptyCartIcon)
        
        emptyCartLabel = UILabel()
        emptyCartLabel.text = "Giỏ hàng đang trống"
        emptyCartLabel.font = UIFont.systemFont(ofSize: 15)
        emptyCartLabel.textColor = Colors.darkGray
        emptyCartLabel.textAlignment = .center
        emptyCartView.addSubview(emptyCartLabel)

        wasControlsInitialized = true
    }
    
    func showCart(frameSize:CGSize) {
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        let formatter = NumberFormatter()
        
        if !wasControlsInitialized { return }
        
        
        // Remove details item in scrollview
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        
        if Cart.getItemsCount() == 0 {
            // Empty cart
            emptyCartView.frame.origin.x = 0
            emptyCartView.frame.origin.y = 0
            emptyCartView.frame.size = frameSize
            
            emptyCartIcon.frame.size = CGSize(width: 75, height: 75)
            emptyCartIcon.frame.origin.x = (frameSize.width - emptyCartIcon.frame.width)/2
            emptyCartIcon.frame.origin.y = (frameSize.height - emptyCartIcon.frame.height)/2
            
            emptyCartLabel.frame.origin.x = 8
            emptyCartLabel.frame.origin.y = emptyCartIcon.frame.origin.y + emptyCartIcon.frame.height + 4
            emptyCartLabel.frame.size.width = frameSize.width - 16
            emptyCartLabel.frame.size.height = 24
            
            self.view.addSubview(emptyCartView)
            self.totalAmountLabel.removeFromSuperview()
            self.totalAmountValueLabel.removeFromSuperview()
            self.checkoutButton.removeFromSuperview()
            
        } else {
            
            // Remove empty cart view
            emptyCartView.removeFromSuperview()
            self.view.addSubview(totalAmountLabel)
            self.view.addSubview(totalAmountValueLabel)
            self.view.addSubview(checkoutButton)
            
            formatter.groupingSeparator = ","
            formatter.numberStyle = .decimal
            
            checkoutButton.frame.size.width = frameSize.width - 16
            checkoutButton.frame.size.height = 48
            checkoutButton.frame.origin.x = 8
            checkoutButton.frame.origin.y = frameSize.height - tabBarHeight - checkoutButton.frame.height - 8
            
            let splitterPosition = frameSize.width * 0.65
            totalAmountLabel.frame.size.width = splitterPosition - 8
            totalAmountLabel.frame.size.height = 24
            totalAmountLabel.frame.origin.x = 8
            totalAmountLabel.frame.origin.y = checkoutButton.frame.origin.y - totalAmountLabel.frame.height - 4
            
            totalAmountValueLabel.text = "\(formatter.string(from: NSNumber(value: Cart.getTotalAmount())) ?? "0")Đ"
            totalAmountValueLabel.frame.size.width = frameSize.width - splitterPosition - 12
            totalAmountValueLabel.frame.size.height = 24
            totalAmountValueLabel.frame.origin.x = splitterPosition + 4
            totalAmountValueLabel.frame.origin.y = checkoutButton.frame.origin.y - totalAmountValueLabel.frame.height - 4
            
            scrollView.frame.origin.x = 0
            scrollView.frame.origin.y = 0
            scrollView.frame.size.width = frameSize.width
            scrollView.frame.size.height = totalAmountLabel.frame.origin.y
            
            // Show cart info
            var currentHeight = CGFloat(0)
            for item in Cart.cartItems {
                // show services
                let headerHighlightView = UIView()
                headerHighlightView.frame.origin.x = 0
                headerHighlightView.frame.origin.y = currentHeight
                headerHighlightView.frame.size.width = frameSize.width
                headerHighlightView.frame.size.height = 36
                headerHighlightView.backgroundColor = UIColor(rgb: 0x57B4CC)
                scrollView.addSubview(headerHighlightView)
                
                let serviceNameLabel = UILabel()
                serviceNameLabel.text = "\(item.service?.serviceName ?? "-")"
                serviceNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
                serviceNameLabel.textColor = UIColor.white
                serviceNameLabel.frame.origin.x = 8
                serviceNameLabel.frame.origin.y = currentHeight + 8
                serviceNameLabel.frame.size.width = frameSize.width - 16
                serviceNameLabel.frame.size.height = 24
                scrollView.addSubview(serviceNameLabel)
                
                currentHeight = headerHighlightView.frame.origin.y + headerHighlightView.frame.height
                
                // Show cart service details
                for details in item.serviceDetails {
                    let itemNameLabel = UILabel()
                    itemNameLabel.text = "\(details.itemName ?? "-")"
                    itemNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
                    itemNameLabel.frame.origin.x = 16
                    itemNameLabel.frame.origin.y = currentHeight + 8
                    itemNameLabel.frame.size.width = frameSize.width - 32
                    itemNameLabel.frame.size.height = 24
                    scrollView.addSubview(itemNameLabel)
                    
                    let itemPriceLabel = UILabel()
                    itemPriceLabel.text = "\(formatter.string(from: NSNumber(value: details.price)) ?? "0")Đ"
                    itemPriceLabel.font = UIFont.systemFont(ofSize: 15)
                    itemPriceLabel.textColor = Colors.darkGray
                    itemPriceLabel.frame.origin.x = 16
                    itemPriceLabel.frame.origin.y = itemNameLabel.frame.origin.y + itemNameLabel.frame.height + 4
                    itemPriceLabel.frame.size.width = frameSize.width - 32
                    itemPriceLabel.frame.size.height = 24
                    scrollView.addSubview(itemPriceLabel)
                    
                    let removeItemButton = UIButton()
                    let imageSize = CGSize(width: 36, height: 36)
                    removeItemButton.setImage(UIImage(named: "ic_trash"), for: .normal)
                    removeItemButton.frame.size = imageSize
                    removeItemButton.frame.origin.x = frameSize.width - removeItemButton.frame.width - 16
                    removeItemButton.frame.origin.y = itemPriceLabel.frame.origin.y - removeItemButton.frame.height / 2
                    removeItemButton.addTarget(self, action: #selector(removeCartItem), for: .touchUpInside)
                    removeItemButton.tag = details.itemId ?? 0
                    scrollView.addSubview(removeItemButton)
                    
                    let seperatorView = UIView()
                    seperatorView.backgroundColor = UIColor(rgb: 0xefefef)
                    seperatorView.frame.origin.x = 16
                    seperatorView.frame.origin.y = itemPriceLabel.frame.origin.y + itemPriceLabel.frame.height
                    seperatorView.frame.size.width = frameSize.width - 32
                    seperatorView.frame.size.height = 1
                    scrollView.addSubview(seperatorView)
                    
                    currentHeight = seperatorView.frame.origin.y + 4
                }
                
                scrollView.contentSize.height = currentHeight
            }
        }
        
    }
    
    @objc func removeCartItem(sender:UIButton) {
        let itemId = sender.tag
        print("Remove cart item \(itemId)")
        Cart.removeCartItemServiceDetails(itemId: itemId)
        showCart(frameSize: self.view.bounds.size)
    }
    
    @objc func checkOut() {
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        let vc = CheckOutViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
