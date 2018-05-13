//
//  ServiceDetailsViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/19/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class ServiceDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let CELL_HEIGHT = CGFloat(64)
    
    var serviceDetailsTable:UITableView!
    var totalAmountLabel:UILabel!
    var totalAmountValueLabel:UILabel!
    var discountAmountLabel:UILabel!
    var discountAmountValueLabel:UILabel!
    var referAmountLabel:UILabel!
    var referAmountValueLabel:UILabel!
    var addToCartButton:UIButton!
    var cartButton:BadgeButton!
    var checkAllButton:UIButton!
    
    var service:Service?
    var serviceDetails:[ServiceDetails] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "\(self.service?.serviceName ?? "Chi tiết dịch vụ")"
        self.view.backgroundColor = UIColor.white
        
        
        // add right bar button
        self.checkAllButton = UIButton(type: .custom)
        self.checkAllButton.setImage(UIImage(named: "ic_check_all")?.withRenderingMode(.automatic), for: .normal)
        self.checkAllButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.checkAllButton.addTarget(self, action: #selector(toggleCheckAll), for: .touchUpInside)
        
        // Create cart badge button
        self.cartButton = BadgeButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        self.cartButton.setImage(UIImage(named: "ic_cart")?.withRenderingMode(.automatic), for: .normal)
        self.cartButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        self.cartButton.badgeBackgroundColor = Colors.cyan
        self.cartButton.badgeTextColor = Colors.white
        self.cartButton.badge = nil
        self.cartButton.addTarget(self, action: #selector(showCart), for: .touchUpInside)
        
        let bbtnCheckAll = UIBarButtonItem(customView: self.checkAllButton)
        let bbtnShowCart = UIBarButtonItem(customView: self.cartButton)
        navigationItem.rightBarButtonItems = [bbtnCheckAll, bbtnShowCart]
        
        initControls()
        relayoutControls(frameSize: self.view.bounds.size)
        loadServiceDetails(serviceId: self.service?.serviceId ?? 0)
    }
    
    @objc func showCart() {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.selectedIndex = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Cart.getItemsCount() > 0 {
            self.cartButton.badge = "\(Cart.getItemsCount())"
        } else {
            self.cartButton.badge = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.relayoutControls(frameSize: size)
        self.serviceDetailsTable.reloadData()
    }
    
    func initControls() {
        serviceDetailsTable = UITableView()
        serviceDetailsTable.separatorStyle = .none
        serviceDetailsTable.dataSource = self
        serviceDetailsTable.delegate = self
        self.view.addSubview(serviceDetailsTable)
        
        totalAmountLabel = UILabel()
        totalAmountLabel.text = "Tổng cộng:"
        totalAmountLabel.font = UIFont.systemFont(ofSize: 15)
        totalAmountLabel.textAlignment = .right
        self.view.addSubview(totalAmountLabel)
        
        totalAmountValueLabel = UILabel()
        totalAmountValueLabel.text = "0Đ"
        totalAmountValueLabel.font = UIFont.systemFont(ofSize: 15)
        totalAmountValueLabel.textAlignment = .right
        self.view.addSubview(totalAmountValueLabel)
        
        discountAmountLabel = UILabel()
        discountAmountLabel.text = "Giảm giá:"
        discountAmountLabel.font = UIFont.systemFont(ofSize: 15)
        discountAmountLabel.textAlignment = .right
        self.view.addSubview(discountAmountLabel)
        
        discountAmountValueLabel = UILabel()
        discountAmountValueLabel.text = "0Đ"
        discountAmountValueLabel.font = UIFont.systemFont(ofSize: 15)
        discountAmountValueLabel.textColor = UIColor(rgb: 0xFF4081)
        discountAmountValueLabel.textAlignment = .right
        self.view.addSubview(discountAmountValueLabel)
        
        referAmountLabel = UILabel()
        referAmountLabel.text = "Còn lại:"
        referAmountLabel.font = UIFont.systemFont(ofSize: 15)
        referAmountLabel.textAlignment = .right
        self.view.addSubview(referAmountLabel)
        
        referAmountValueLabel = UILabel()
        referAmountValueLabel.text = "0Đ"
        referAmountValueLabel.font = UIFont.boldSystemFont(ofSize: 15)
        referAmountValueLabel.textAlignment = .right
        self.view.addSubview(referAmountValueLabel)
        
        addToCartButton = UIButton()
        addToCartButton = UIButton()
        addToCartButton.layer.cornerRadius = 4
        addToCartButton.layer.borderWidth = 1
        addToCartButton.layer.borderColor = Colors.lightGray.cgColor
        addToCartButton.setTitle("Thêm vào giỏ hàng", for: .normal)
        addToCartButton.tintColor = UIColor.black
        addToCartButton.backgroundColor = Colors.blue
        addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        self.view.addSubview(addToCartButton)
    }
    
    func relayoutControls(frameSize:CGSize) {
        
        addToCartButton.frame.size.width = frameSize.width - 16
        addToCartButton.frame.size.height = 48
        addToCartButton.frame.origin.x = 8
        addToCartButton.frame.origin.y = frameSize.height - addToCartButton.frame.height - 8
        
        let splitterPosition = frameSize.width * 0.65
        referAmountLabel.frame.size.width = splitterPosition - 8
        referAmountLabel.frame.size.height = 24
        referAmountLabel.frame.origin.x = 8
        referAmountLabel.frame.origin.y = addToCartButton.frame.origin.y - referAmountLabel.frame.height - 4
        
        referAmountValueLabel.frame.size.width = frameSize.width - splitterPosition - 12
        referAmountValueLabel.frame.size.height = 24
        referAmountValueLabel.frame.origin.x = splitterPosition + 4
        referAmountValueLabel.frame.origin.y = addToCartButton.frame.origin.y - referAmountLabel.frame.height - 4
        
        discountAmountLabel.frame.size.width = splitterPosition - 8
        discountAmountLabel.frame.size.height = 24
        discountAmountLabel.frame.origin.x = 8
        discountAmountLabel.frame.origin.y = referAmountValueLabel.frame.origin.y - referAmountValueLabel.frame.height - 4
        
        discountAmountValueLabel.frame.size.width = frameSize.width - splitterPosition - 12
        discountAmountValueLabel.frame.size.height = 24
        discountAmountValueLabel.frame.origin.x = splitterPosition + 4
        discountAmountValueLabel.frame.origin.y = referAmountValueLabel.frame.origin.y - referAmountValueLabel.frame.height - 4
        
        totalAmountLabel.frame.size.width = splitterPosition - 8
        totalAmountLabel.frame.size.height = 24
        totalAmountLabel.frame.origin.x = 8
        totalAmountLabel.frame.origin.y = discountAmountValueLabel.frame.origin.y - discountAmountValueLabel.frame.height - 4
        
        totalAmountValueLabel.frame.size.width = frameSize.width - splitterPosition - 12
        totalAmountValueLabel.frame.size.height = 24
        totalAmountValueLabel.frame.origin.x = splitterPosition + 4
        totalAmountValueLabel.frame.origin.y = discountAmountValueLabel.frame.origin.y - discountAmountValueLabel.frame.height - 4
        
        serviceDetailsTable.frame.size.width = frameSize.width
        serviceDetailsTable.frame.size.height = totalAmountValueLabel.frame.origin.y - 8
        serviceDetailsTable.frame.origin.x = 0
        serviceDetailsTable.frame.origin.y = 0
        // serviceDetailsTable.backgroundColor = UIColor.brown
        
    }
    
    func loadServiceDetails(serviceId:Int) {
        APIService.getServiceDetails(serviceId: service?.serviceId ?? 0, handler: { (results, message) in
            self.serviceDetails.removeAll()
            if results != nil {
                for item in results! {
                    self.serviceDetails.append(item)
                }
            }
            self.serviceDetailsTable.reloadData()
            self.updateTotalPrice()
        })
    }
    
    @objc func addToCart() {
        var hasItemSelected = false
        for item in serviceDetails {
            if item.selected {
                hasItemSelected = true
                break
            }
        }
        if hasItemSelected {
            let cartItem = CartItem()
            cartItem.service = self.service
            for item in serviceDetails {
                if item.selected {
                    cartItem.serviceDetails.append(item)
                }
            }
            let serviceId = cartItem.service?.serviceId ?? 0
            if Cart.cartItemServiceExisted(serviceId: serviceId) {
                let alert = UIAlertController(
                    title: "Thêm vào giỏ hàng",
                    message: "Dịch vụ đã tồn tại trong giỏ hàng!\r\nBạn có muốn cập nhật lại giỏ hàng?",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Có", style: .default, handler: {(alert: UIAlertAction!) in
                    // Add cart item
                    Cart.removeCartItemService(serviceId: serviceId)
                    Cart.cartItems.append(cartItem)
                    self.clearCheckStatus()
                    
                    // Update cart button badge
                    self.cartButton.badge = Cart.getItemsCount() > 0 ? "\(Cart.getItemsCount())" : nil
                }))
                alert.addAction(UIAlertAction(title: "Không", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                // Add cart item
                Cart.cartItems.append(cartItem)
                self.clearCheckStatus()
                
                // Show success message
                let alert = UIAlertController(title: "Thêm vào giỏ hàng", message: "Thêm sản phẩm/dịch vụ vào giỏ hàng thành công!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                // Update cart button badge
                self.cartButton.badge = Cart.getItemsCount() > 0 ? "\(Cart.getItemsCount())" : nil
            }
        } else {
            // No item selectd
            let alert = UIAlertController(title: "Thêm vào giỏ hàng", message: "Vui lòng chọn dịch vụ yêu cầu!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
            }
    
    func clearCheckStatus() {
        for item in serviceDetails {
            item.selected  = false
        }
        self.serviceDetailsTable.reloadData()
    }
    
    @objc func toggleCheckAll() {
        var wasCheckAll = true
        for item in serviceDetails {
            if item.selected == false {
                wasCheckAll = false
                break
            }
        }
        for item in serviceDetails {
            item.selected = !wasCheckAll
        }
        self.serviceDetailsTable.reloadData()
        self.updateTotalPrice()
    }
    
    func updateTotalPrice() {
        var total = Double(0)
        var discount = Double(0)
        var refer = Double(0)
        for item in serviceDetails {
            if item.selected {
                total += item.priceOriginal * Double(item.quantity)
                if item.price < item.priceOriginal && item.priceOriginal > 0 {
                    discount += (item.priceOriginal - item.price) * Double(item.quantity)
                }
            }
        }
        refer = total - discount
        
        let formatter = NumberFormatter()
        
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        
        self.totalAmountValueLabel.text = "\(formatter.string(from: total as NSNumber) ?? "0")Đ"
        self.discountAmountValueLabel.text = "\(formatter.string(from: discount as NSNumber) ?? "0")Đ"
        self.referAmountValueLabel.text = "\(formatter.string(from: refer as NSNumber) ?? "0")Đ"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = serviceDetails[indexPath.row]
        let formatter = NumberFormatter()
        
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        
        cell.frame.size.width = tableView.frame.width
        cell.frame.size.height = CELL_HEIGHT
        cell.selectionStyle = .none
        // cell.backgroundColor = UIColor.cyan
        
        let titleLabel = UILabel()
        titleLabel.text = item.itemName
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.frame.origin.x = 8
        titleLabel.frame.origin.y = 16
        titleLabel.frame.size.width = cell.frame.width - 16
        titleLabel.frame.size.height = item.itemName?.height(withConstrainedWidth: titleLabel.frame.width , font: titleLabel.font) ?? 24
        cell.addSubview(titleLabel)
        
        let priceLabel = UILabel()
        priceLabel.text = "Giá: "
        priceLabel.textColor = Colors.darkGray
        priceLabel.font = UIFont.systemFont(ofSize: 15)
        priceLabel.frame.origin.x = 8
        priceLabel.frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.height + 4
        priceLabel.sizeToFit()
        cell.addSubview(priceLabel)
        
        let priceValueLabel = UILabel()
        priceValueLabel.text = "\(formatter.string(from: item.price as NSNumber) ?? "0")Đ"
        priceValueLabel.font = UIFont.systemFont(ofSize: 15)
        priceValueLabel.textColor = Colors.pink
        priceValueLabel.frame.origin.x = priceLabel.frame.origin.x + priceLabel.frame.width + 4
        priceValueLabel.frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.height + 4
        priceValueLabel.sizeToFit()
        cell.addSubview(priceValueLabel)
        
        // Has discount?
        if item.price < item.priceOriginal && item.priceOriginal > 0 {
            
            let discount = ((item.priceOriginal - item.price)/item.priceOriginal) * 100
            
            let priceOrginalValueLabel = UILabel()
            priceOrginalValueLabel.text = "\(formatter.string(from: item.priceOriginal as NSNumber) ?? "0")Đ"
            priceOrginalValueLabel.font = UIFont.systemFont(ofSize: 15)
            priceOrginalValueLabel.textColor = Colors.darkGray
            priceOrginalValueLabel.frame.origin.x = priceValueLabel.frame.origin.x + priceValueLabel.frame.width + 4
            priceOrginalValueLabel.frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.height + 4
            priceOrginalValueLabel.sizeToFit()
            cell.addSubview(priceOrginalValueLabel)
            
            let lineThrough = UIView()
            lineThrough.backgroundColor = UIColor.darkGray
            lineThrough.frame.origin.x = priceOrginalValueLabel.frame.origin.x
            lineThrough.frame.origin.y = priceOrginalValueLabel.frame.origin.y + priceOrginalValueLabel.frame.height/2
            lineThrough.frame.size.width = priceOrginalValueLabel.frame.width
            lineThrough.frame.size.height = 1
            
            cell.addSubview(lineThrough)
            
            let discountValueLabel = UILabel()
            discountValueLabel.text = "-\(formatter.string(from: discount as NSNumber) ?? "0")%"
            discountValueLabel.font = UIFont.systemFont(ofSize: 15)
            discountValueLabel.textColor = Colors.red
            discountValueLabel.frame.origin.x = priceOrginalValueLabel.frame.origin.x + priceOrginalValueLabel.frame.width + 4
            discountValueLabel.frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.height + 4
            discountValueLabel.sizeToFit()
            cell.addSubview(discountValueLabel)
        }
        
        let selectStatusImage = UIImageView()
        let imageSize = CGSize(width: 25, height: 25)
        selectStatusImage.image = item.selected ? UIImage(named: "ic_checked") : UIImage(named: "ic_unchecked")
        selectStatusImage.frame.size.width = imageSize.width
        selectStatusImage.frame.size.height = imageSize.height
        selectStatusImage.frame.origin.x = cell.frame.width - imageSize.width - 18
        selectStatusImage.frame.origin.y = (cell.frame.height - imageSize.height) / 2
        cell.addSubview(selectStatusImage)
        
        let seperator = UIView()
        seperator.backgroundColor = Colors.lightGray
        seperator.frame.origin.x = 8
        seperator.frame.origin.y = priceValueLabel.frame.origin.y + priceValueLabel.frame.height + 4
        seperator.frame.size.width = cell.frame.width - 16
        seperator.frame.size.height = 1
        cell.addSubview(seperator)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select index \(indexPath.row)")
        self.serviceDetails[indexPath.row].selected = !self.serviceDetails[indexPath.row].selected
        self.serviceDetailsTable.reloadData()
        self.updateTotalPrice()
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
