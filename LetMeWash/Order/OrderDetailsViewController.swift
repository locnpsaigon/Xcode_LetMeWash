//
//  OrderDetailsViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/17/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    var scrollView:UIScrollView!
    
    var headerView:UIView!
    var headerHighlight:UIView!
    var orderNoLabel:UILabel!
    var orderTitleLabel:UILabel!
    var totalAmountLabel:UILabel!
    var orderDateLabel:UILabel!
    var orderStatusLabel:UILabel!
    var seperatorView:UIView!
    var detailsView:UIView!
    var reuseOrderButton:UIButton!
    
    var order:Order?
    var orderDetails:[OrderDetails] = []
    var wasOrderDetailsLoaded = false
    var wasInitControls = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Chi tiết đơn hàng"
        self.view.backgroundColor = Colors.lightGray
        
        initControls()
        relayoutControls(frameSize: self.view.bounds.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if order != nil {
            loadOrderDetails(order: order!)
        }
        else {
            // No order found
            let alert = UIAlertController(
                title: "Chi tiết đơn hàng",
                message: "Không tìm thấy thông tin đơn hàng cần hiển thị",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: {(alert: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        relayoutControls(frameSize: size)
        if wasOrderDetailsLoaded {
            showOrderDetails(order: self.order!, orderDetails: self.orderDetails)
        }
    }
    
    func initControls() {
        
        // create scroll view
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(rgb: 0xefefef)
        self.view.addSubview(scrollView)
        
        // create header view
        headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.layer.borderWidth = 1
        headerView.layer.borderColor = UIColor(rgb: 0xdedede).cgColor
        scrollView.addSubview(headerView)

        headerHighlight = UIView()
        headerHighlight.layer.backgroundColor = Colors.darkCyan.cgColor
        headerView.addSubview(headerHighlight)
        
        orderNoLabel = UILabel()
        orderNoLabel.text = "ĐH: -"
        orderNoLabel.font = UIFont.systemFont(ofSize: 15)
        orderNoLabel.textColor = UIColor.white
        orderNoLabel.backgroundColor = UIColor.clear
        headerView.addSubview(orderNoLabel)
        
        orderDateLabel = UILabel()
        orderDateLabel.text = "-"
        orderDateLabel.font = UIFont.systemFont(ofSize: 15)
        orderDateLabel.textColor = UIColor.white
        orderDateLabel.backgroundColor = UIColor.clear
        headerView.addSubview(orderDateLabel)

        orderTitleLabel = UILabel()
        orderTitleLabel.text = "Tiêu đề"
        orderTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        orderTitleLabel.textColor = UIColor.darkGray
        headerView.addSubview(orderTitleLabel)
        
        orderStatusLabel = UILabel()
        orderStatusLabel.text = "Trạng thái"
        orderStatusLabel.font = UIFont.systemFont(ofSize: 15)
        headerView.addSubview(orderStatusLabel)
        
        detailsView = UIView()
        // detailsView.backgroundColor = UIColor.brown
        headerView.addSubview(detailsView)
        
        // Details
        seperatorView = UIView()
        seperatorView.backgroundColor = Colors.lightGray
        headerView.addSubview(seperatorView)
        
        totalAmountLabel = UILabel()
        totalAmountLabel.text = "Tổng tiền: 0Đ"
        totalAmountLabel.font = UIFont.systemFont(ofSize: 15)
        totalAmountLabel.textColor = Colors.pink
        headerView.addSubview(totalAmountLabel)
        
        // Reuse order button
        reuseOrderButton = UIButton()
        reuseOrderButton.layer.cornerRadius = 4
        reuseOrderButton.layer.borderWidth = 1
        reuseOrderButton.layer.borderColor = Colors.lightGray.cgColor
        reuseOrderButton.setTitle("Sử dụng lại đơn hàng", for: .normal)
        reuseOrderButton.tintColor = UIColor.white
        reuseOrderButton.backgroundColor = Colors.blue
        reuseOrderButton.addTarget(self, action: #selector(reuseOrder), for: .touchUpInside)
        self.view.addSubview(reuseOrderButton)
        
        wasOrderDetailsLoaded = true
    }
    
    func relayoutControls(frameSize:CGSize) {
        
        // Was controls initialized
        if !wasOrderDetailsLoaded { return }
        
        let reuseOrderButtonHeight = CGFloat(48)
        
        // scrollview
        scrollView.frame.origin.x = 0
        scrollView.frame.origin.y = 0
        scrollView.frame.size.width = frameSize.width
        scrollView.frame.size.height = frameSize.height - reuseOrderButtonHeight - 16
        
        // header view
        headerView.frame.origin.x = 8
        headerView.frame.origin.y = 8
        headerView.frame.size.width = frameSize.width - 16
        headerView.frame.size.height = 300
        
        headerHighlight.frame.origin.x = 0
        headerHighlight.frame.origin.y = 0
        headerHighlight.frame.size.width = headerView.frame.width
        headerHighlight.frame.size.height = 32
        let rectShape = CAShapeLayer()
        rectShape.path = UIBezierPath(
            roundedRect: headerView.bounds,
            byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: 8, height: 8)).cgPath
        headerHighlight.layer.mask = rectShape
        
        orderNoLabel.frame.origin.x = 8
        orderNoLabel.frame.origin.y = 4
        orderNoLabel.frame.size.width = (headerView.frame.width - 24) * 0.5
        orderNoLabel.frame.size.height = 24
        
        orderDateLabel.frame.origin.x = orderNoLabel.frame.origin.x + orderNoLabel.frame.width + 8
        orderDateLabel.frame.origin.y = orderNoLabel.frame.origin.y
        orderDateLabel.frame.size.width = (headerView.frame.width - 24) * 0.5
        orderDateLabel.frame.size.height = 24

        orderTitleLabel.frame.origin.x = 8
        orderTitleLabel.frame.origin.y = headerHighlight.frame.origin.y + headerHighlight.frame.height + 4
        orderTitleLabel.frame.size.width = headerView.frame.width - 16
        orderTitleLabel.frame.size.height = 24
        
        totalAmountLabel.frame.origin.x = 8
        totalAmountLabel.frame.origin.y = orderTitleLabel.frame.origin.y + orderTitleLabel.frame.height
        totalAmountLabel.frame.size.width = headerView.frame.width - 16
        totalAmountLabel.frame.size.height = 24
        
        orderStatusLabel.frame.origin.x = 8
        orderStatusLabel.frame.origin.y = totalAmountLabel.frame.origin.y + totalAmountLabel.frame.height
        orderStatusLabel.frame.size.width = headerView.frame.width - 16
        orderStatusLabel.frame.size.height = 24
        
        seperatorView.frame.origin.x = 8
        seperatorView.frame.origin.y = orderStatusLabel.frame.origin.y + orderStatusLabel.frame.height + 8
        seperatorView.frame.size.width = headerView.frame.width - 16
        seperatorView.frame.size.height = 1
        
        detailsView.frame.origin.x = 0
        detailsView.frame.origin.y = seperatorView.frame.origin.y + seperatorView.frame.height
        detailsView.frame.size.width = headerView.frame.width
        detailsView.frame.size.height = 0
        
        headerView.frame.size.height = totalAmountLabel.frame.origin.y + totalAmountLabel.frame.height + 8
        headerView.layer.borderWidth = 1
        headerView.layer.borderColor = UIColor(rgb: 0xefefef).cgColor
        headerView.layer.cornerRadius = 8
        
        // details view
        scrollView.contentSize.width = frameSize.width
        scrollView.contentSize.height = headerView.frame.origin.y + headerView.frame.height + 8
        
        // Reuse order button
        reuseOrderButton.frame.origin.x = 8
        reuseOrderButton.frame.origin.y = frameSize.height - reuseOrderButtonHeight - 8
        reuseOrderButton.frame.size.width = frameSize.width - 16
        reuseOrderButton.frame.size.height = reuseOrderButtonHeight
    }
    
    func loadOrderDetails(order:Order) {
        APIService.getOrderDetails(orderId: order.orderId, handler: {(success, results, message) in
            if success {
                // Success
                self.wasOrderDetailsLoaded = true
                self.orderDetails = results ?? []
                self.showOrderDetails(order: self.order!, orderDetails: self.orderDetails)
            } else {
                // Error
                let alert = UIAlertController(title: "Chi tiết đơn hàng", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: {(alert: UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func showOrderDetails(order:Order, orderDetails:[OrderDetails]) {
        
        let formatter = NumberFormatter()
        let dateFormatter = DateFormatter()
        
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        
        let title = order.title ?? ""
        let titleHeight = title.height(withConstrainedWidth: orderTitleLabel.frame.width, font: orderTitleLabel.font)
        var orderDateText = "-"
        if let orderDate = Converter.getDate(dateString: order.date ?? "") {
            orderDateText = "\(dateFormatter.string(from: orderDate))"
        }
        
        orderNoLabel.text = "ĐH: \(order.orderId)"
        orderTitleLabel.text = title
        orderTitleLabel.frame.size.height = titleHeight
        totalAmountLabel.text = "\(formatter.string(from: NSNumber(value: order.amount)) ?? "0")Đ"
        orderDateLabel.text = orderDateText
        switch order.status {
        case Order.STATUS_OPENED:
            orderStatusLabel.text = "Đang mở"
            orderStatusLabel.textColor = Colors.darkGray
            
        case Order.STATUS_PENDING:
            orderStatusLabel.text = "Đã tiếp nhận"
            orderStatusLabel.textColor = Colors.darkCyan
            
        case Order.STATUS_PROCESSING:
            orderStatusLabel.text = "Đang xử lý"
            orderStatusLabel.textColor = Colors.green
            
        case Order.STATUS_FINSIHED:
            orderStatusLabel.text = "Đã hoàn tất"
            orderStatusLabel.textColor = Colors.orange
            
        case Order.STATUS_CLOSED:
            orderStatusLabel.text = "Đã đóng"
            orderStatusLabel.textColor = Colors.gray
            
        default:
            orderStatusLabel.text = "Đã đóng"
            orderStatusLabel.textColor = Colors.gray
        }
        
        // Get service groups
        var services:[Service] = []
        for details in orderDetails {
            var wasExisted = false
            for service in services {
                if service.serviceId == details.serviceId {
                    wasExisted = true
                    break
                }
            }
            if !wasExisted {
                let newService = Service(serviceId: details.serviceId, serviceName: details.serviceName, groupId: 0, groupName: "", iconUrl: "", description: "")
                services.append(newService)
            }
        }
        
        // Remove all details subviews
        for view in detailsView.subviews {
            view.removeFromSuperview()
        }

        detailsView.frame.size.height = 0
        
        // Show order details
        for service in services {
            // Service name
            let serviceLabel = UILabel()
            serviceLabel.text = "+ \(service.serviceName ?? "-")"
            serviceLabel.font = UIFont.boldSystemFont(ofSize: 15)
            serviceLabel.textColor = UIColor.darkGray
            detailsView.addSubview(serviceLabel)
            serviceLabel.frame.origin.x = 8
            serviceLabel.frame.origin.y = detailsView.frame.height + 8
            serviceLabel.frame.size.width = detailsView.frame.width - 16
            serviceLabel.frame.size.height = 24
            detailsView.frame.size.height = serviceLabel.frame.origin.y + serviceLabel.frame.height
            
            for details in orderDetails {
                if details.serviceId == service.serviceId {
                    // Service details name
                    let serviceDetailsLabel = UILabel()
                    serviceDetailsLabel.text = details.itemName
                    serviceDetailsLabel.font = UIFont.systemFont(ofSize: 15)
                    serviceDetailsLabel.textColor = UIColor.darkGray
                    detailsView.addSubview(serviceDetailsLabel)
                    serviceDetailsLabel.frame.origin.x = 20
                    serviceDetailsLabel.frame.origin.y = detailsView.frame.height + 4
                    serviceDetailsLabel.frame.size.width = detailsView.frame.width - 16
                    serviceDetailsLabel.frame.size.height = 24
                    detailsView.frame.size.height = serviceDetailsLabel.frame.origin.y + serviceDetailsLabel.frame.height
                    
                    // Service detail price
                    let price = details.price
                    let quantity = details.quantity
                    let amount = price * Double(quantity)
                    let serviceDetailsPriceLabel = UILabel()
                    serviceDetailsPriceLabel.text = "\(formatter.string(from: NSNumber(value: price)) ?? "Đ") x \(quantity) = \(formatter.string(from: NSNumber(value: amount)) ?? "0")Đ"
                    serviceDetailsPriceLabel.font = UIFont.systemFont(ofSize: 15)
                    serviceDetailsPriceLabel.textColor = UIColor.darkGray
                    detailsView.addSubview(serviceDetailsPriceLabel)
                    serviceDetailsPriceLabel.frame.origin.x = 20
                    serviceDetailsPriceLabel.frame.origin.y = detailsView.frame.height
                    serviceDetailsPriceLabel.frame.size.width = detailsView.frame.width - 16
                    serviceDetailsPriceLabel.frame.size.height = 24
                    detailsView.frame.size.height = serviceDetailsPriceLabel.frame.origin.y + serviceDetailsPriceLabel.frame.height
                    
                    let detailsSeperatorView = UIView()
                    detailsSeperatorView.backgroundColor = UIColor(rgb: 0xefefef)
                    detailsView.addSubview(detailsSeperatorView)
                    detailsSeperatorView.frame.origin.x = 20
                    detailsSeperatorView.frame.origin.y = detailsView.frame.height
                    detailsSeperatorView.frame.size.width = detailsView.frame.width - 40
                    detailsSeperatorView.frame.size.height = 1
                    detailsView.frame.size.height = detailsSeperatorView.frame.origin.y + detailsSeperatorView.frame.height + 8
                }
            }
        }
        
        headerView.frame.size.height = detailsView.frame.origin.y + detailsView.frame.height + 16
        scrollView.contentSize.height = headerView.frame.height + 8
    }
    
    @objc func reuseOrder() {
        let orderId = self.order?.orderId ?? 0
        // Show loading
        let loadVC = LoadingViewController()
        loadVC.message = "Đang xử lý..."
        loadVC.modalPresentationStyle = .overCurrentContext
        loadVC.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(loadVC, animated: true, completion: nil)
        APIService.reuseOrder(orderId: orderId, handler: {(success, details, message) in
            
            // Dismiss loading status
            let nc = NotificationCenter.default
            nc.post(name: NSNotification.Name(rawValue: "dismissLoading"), object: nil)
            
            if success {
                
                // Get services
                var services:[Service] = []
                for item in details {
                    var wasExisted = false
                    for service in services {
                        if service.serviceId == item.serviceId {
                            wasExisted = true
                            break
                        }
                    }
                    if !wasExisted {
                        let newService = Service(
                            serviceId: item.serviceId,
                            serviceName: item.serviceName,
                            groupId: item.groupId,
                            groupName: item.groupName,
                            iconUrl: "",
                            description: "")
                        services.append(newService)
                    }
                }
                
                // Initialize cart items
                var cartItems:[CartItem] = []
                for service in services {
                    let cartItem = CartItem()
                    cartItem.service = service
                    for item in details {
                        if item.serviceId == service.serviceId {
                            let serviceDetails = ServiceDetails(itemId: item.itemId, itemName: item.itemName, serviceId: item.serviceId, serviceName: item.serviceName, groupId: item.groupId, groupName: item.groupName, unit: item.unit, price: item.price, priceOriginal: item.priceOriginal)
                            cartItem.serviceDetails.append(serviceDetails)
                        }
                    }
                    cartItems.append(cartItem)
                }
                
                // Add cart items
                Cart.removeAllItems()
                Cart.cartItems.append(contentsOf: cartItems)
                
                // Show Cart
                self.tabBarController?.selectedIndex = 2
                self.tabBarController?.tabBar.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.navigationController?.popToRootViewController(animated: false)
                })
            } else {
                let alert = UIAlertController(title: "Sử dụng lại đơn hàng", message: message, preferredStyle: .alert)
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
