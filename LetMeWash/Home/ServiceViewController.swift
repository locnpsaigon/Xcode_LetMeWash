//
//  ServiceViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 12/28/17.
//  Copyright © 2017 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class ServiceViewController: UITableViewController {

    var cartButton:BadgeButton!
    
    var group:ServiceGroup? = nil
    var services:[Service] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = group?.groupName ?? "Dịch vụ"
        self.view.backgroundColor = Colors.white
        
        // Create cart badge button
        self.cartButton = BadgeButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        self.cartButton.setImage(UIImage(named: "ic_cart")?.withRenderingMode(.automatic), for: .normal)
        self.cartButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        self.cartButton.badgeBackgroundColor = Colors.cyan
        self.cartButton.badgeTextColor = Colors.white
        self.cartButton.badge = nil
        self.cartButton.addTarget(self, action: #selector(showCart), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        // Hide empty row seperator
        // self.tableView.tableFooterView = UIView(frame: .zero)
        
        // Load services
        APIService.getServices(groupId: group?.groupId ?? 0, handler: {(results, message) in
            print(message)
            if results != nil {
                self.services.removeAll()
                for item in results! {
                    self.services.append(item)
                }
                self.tableView.reloadData()
            }
        })
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceViewCell

        // Configure the cell...
        let item = services[indexPath.row]
        
        cell.nameLabel.text = item.serviceName ?? ""
        cell.descriptionLabel.text = item.description ?? ""
        if item.iconUrl != nil {
            cell.iconImage.downloadedFrom(link: item.iconUrl ?? "")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        let vc = ServiceDetailsViewController()
        let service = services[indexPath.row]
        vc.service = service
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
