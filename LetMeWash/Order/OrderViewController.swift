//
//  OrderViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/9/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class OrderViewController: UITableViewController {
    
    let PAGE_SIZE = 50
    
    @IBOutlet var orderTable: UITableView!
    
    var orders:[Order] = []
    var maxRows:Int = 0
    var isLoading:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "Đơn hàng"
        self.view.backgroundColor = Colors.lightGray
        
        self.orderTable.dataSource = self
        self.orderTable.delegate = self
        self.orderTable.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Remove current orders
        self.orders.removeAll()
        self.orderTable.reloadData()
        
        // Load more orders
        if GlobalCache.logonUser != nil {
            let phone = GlobalCache.logonUser?.phone ?? ""
            self.loadMoreOrders(phone: phone, skip: 0, take: PAGE_SIZE)
        } else {
            showLogin()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Show tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show tab bar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showLogin() {
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMoreOrders(phone:String, skip:Int, take:Int) {
        if self.isLoading == false {
            self.isLoading = true
            APIService.getOrders(phone: phone, skip: skip, take: take, handler: { (results, maxRows, message) in
                if results != nil {
                    for item in results! {
                        self.orders.append(item)
                    }
                }
                self.maxRows = maxRows
                self.orderTable.reloadData()
                self.isLoading = false
            })
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
        return orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = orders[indexPath.row]
        let formatter = NumberFormatter()
        let dateFormatter = DateFormatter()
        
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        
        cell.selectionStyle = .none
        
        // set cell frame
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        // Background frame
        let cellBG = UIView(frame: CGRect(x: 8, y: 8, width: cell.frame.width - 16, height: cell.frame.height - 8))
        cellBG.backgroundColor = UIColor.white
        cellBG.layer.cornerRadius = 8
        cellBG.layer.borderWidth = 1
        cellBG.layer.borderColor = Colors.lightGray.cgColor
        cell.addSubview(cellBG)
        
        // Header BG
        let cellBGWidth = cellBG.frame.width
        // let cellBGHeight = cellBG.frame.height

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: cellBGWidth, height: 32))
        //headerView.backgroundColor = UIColor(colorLiteralRed: 87/255, green: 180/255, blue: 204/255, alpha: 1.0)
        let rectShape = CAShapeLayer()
        rectShape.path = UIBezierPath(
            roundedRect: headerView.bounds,
            byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: 8, height: 8)).cgPath
        headerView.layer.backgroundColor = UIColor(rgb: 0x57B4CC).cgColor
        headerView.layer.mask = rectShape
        cellBG.addSubview(headerView)
        
        // Order No
        let orderNoLabel = UILabel(frame: CGRect(x: 4, y: 4, width: cellBGWidth/2 - 8, height: 24))
        orderNoLabel.text = "ĐH: #\(item.orderId)"
        orderNoLabel.textColor = UIColor.white
        orderNoLabel.font = orderNoLabel.font.withSize(14)
        cellBG.addSubview(orderNoLabel)
        
        // Order Date
        let orderDate = Converter.getDate(dateString: item.date!)
        let orderDateLabel = UILabel(frame: CGRect(x: cellBGWidth/2 + 4, y: 4, width: cellBGWidth/2 - 8, height: 24))
        orderDateLabel.text = orderDate != nil ? dateFormatter.string(from: orderDate!) : "-"
        orderDateLabel.font = orderDateLabel.font.withSize(14)
        orderDateLabel.textAlignment = .right
        orderDateLabel.textColor = UIColor.white
        cellBG.addSubview(orderDateLabel)
        
        // Title
        let titleLabel = UILabel(frame: CGRect(x: 4, y: 4 + orderNoLabel.frame.origin.y + orderNoLabel.frame.height, width: cellBGWidth - 8, height: 24))
        titleLabel.text = item.title
        titleLabel.font = titleLabel.font.withSize(14)
        titleLabel.textColor = UIColor.darkGray
        cellBG.addSubview(titleLabel)
        
        // Price
        let amountLabel = UILabel(frame: CGRect(x: 4, y: 4 + titleLabel.frame.origin.y + titleLabel.frame.height, width: cellBGWidth/2 - 8, height: 24))
        amountLabel.text = formatter.string(from: NSNumber(value: item.amount))! + "Đ"
        amountLabel.font = amountLabel.font.withSize(14)
        amountLabel.textColor = UIColor(rgb: 0xFF4081)
        cellBG.addSubview(amountLabel)
        
        // Status
        let statusLabel = UILabel(frame: CGRect(x: cellBGWidth/2 - 8, y: amountLabel.frame.origin.y, width: cellBGWidth/2 - 8, height: 24))
        statusLabel.font = statusLabel.font.withSize(14)
        statusLabel.textAlignment = .right
        switch item.status {
        case Order.STATUS_OPENED:
            statusLabel.text = "Đang mở"
            statusLabel.textColor = Colors.gray
            
        case Order.STATUS_PENDING:
            statusLabel.text = "Đã tiếp nhận"
            statusLabel.textColor = Colors.green
            
        case Order.STATUS_PROCESSING:
            statusLabel.text = "Đang xử lý"
            statusLabel.textColor = Colors.red
            
        case Order.STATUS_FINSIHED:
            statusLabel.text = "Đã hoàn tất"
            statusLabel.textColor = Colors.blue
            
        case Order.STATUS_CLOSED:
            statusLabel.text = "Đã đóng"
            statusLabel.textColor = Colors.gray
            
        default:
            statusLabel.text = "Đã đóng"
            statusLabel.textColor = Colors.gray
        }
        cellBG.addSubview(statusLabel)
        cellBG.frame.size.height = statusLabel.frame.origin.y + statusLabel.frame.height + 8
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        let vc = OrderDetailsViewController()
        vc.order = orders[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = orders.count - 1
        if indexPath.row == lastItem && orders.count < maxRows && !isLoading {
            // Load more orders
            let phone = GlobalCache.logonUser?.phone ?? ""
            loadMoreOrders(phone: phone, skip: orders.count, take: PAGE_SIZE)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
