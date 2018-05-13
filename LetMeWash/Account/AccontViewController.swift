//
//  AccontViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/14/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class AccontViewController: UITableViewController, UITabBarDelegate {

    @IBOutlet var menuTable: UITableView!
    
    var welcomeMenu:MenuItem!
    var messageListMenu:MenuItem!
    var orderListMenu:MenuItem!
    var changePassMenu:MenuItem!
    var loginMenu:MenuItem!
    
    var menuItems:[MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "Tài khoản"
        self.view.backgroundColor = Colors.white
        
        self.menuTable.dataSource  = self
        self.menuTable.delegate  = self
        self.menuTable.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // init menus
        welcomeMenu = MenuItem(id: "MENU_WELCOME", name: "Xin chào!", icon: "")
        messageListMenu = MenuItem(id: "MENU_MESSAGE_LIST", name: "Thông báo của tôi", icon: "ic_bell")
        orderListMenu = MenuItem(id: "MENU_ORDER_LIST", name: "Đơn hàng của tôi", icon: "ic_order")
        changePassMenu = MenuItem(id: "MENU_CHANGE_PASS", name: "Đổi mật khẩu", icon: "ic_password")
        loginMenu = MenuItem(id: "MENU_LOGIN", name: "Đăng nhập", icon: "ic_login")
        
        menuItems.removeAll()
        
        if GlobalCache.logonUser != nil {
            welcomeMenu.name = "Xin chào, \(GlobalCache.logonUser?.fullname ?? "Xin chào, Guest")"
            loginMenu.name = "Đăng xuất"
            loginMenu.icon = "ic_logout"
            menuItems.append(contentsOf: [welcomeMenu, messageListMenu, orderListMenu, changePassMenu, loginMenu])
            
        } else {
            welcomeMenu.name = "Xin chào, Guest"
            menuItems.append(contentsOf: [welcomeMenu, loginMenu])
        }
        self.menuTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Show tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showMessages() {
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        let vc = MessageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showOrders() {
        self.tabBarController?.selectedIndex = 1
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func showChangePass() {
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        let vc = ChangePassViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showLogin() {
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
        return menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountMenuCell", for: indexPath)
        let item = menuItems[indexPath.row]
        
        // Configure the cell...
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let cellW = cell.frame.width
        let cellH = cell.frame.height

        // Create BG frame
        let cellBG = UIView(frame: CGRect(x: 1, y: 1, width: cellW-2, height: cellH-1))
        cellBG.backgroundColor = UIColor.white
        cellBG.layer.cornerRadius = 4
        cell.addSubview(cellBG)
        
        // Create icon
        let iconImageView = UIImageView(image: UIImage(named: item.icon ?? "ic_question_mark"))
        iconImageView.frame.origin.x = 16
        iconImageView.frame.origin.y = 8
        cellBG.addSubview(iconImageView)
        
        // Create menu label
        let menuLabel = UILabel(frame: CGRect(
            x: 8 + iconImageView.frame.origin.x + iconImageView.frame.width,
            y: 8,
            width: cellBG.frame.width - iconImageView.frame.width - 32,
            height: 24))
        menuLabel.text = item.name
        menuLabel.font = UIFont.systemFont(ofSize: 15)
        cellBG.addSubview(menuLabel)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select row at \(indexPath.row)")
        
        let selectedMenu = menuItems[indexPath.row]
        
        switch selectedMenu.id {
        case "MENU_MESSAGE_LIST":
            showMessages()
            break
            
        case "MENU_ORDER_LIST":
            showOrders()
            break
            
        case "MENU_CHANGE_PASS":
            showChangePass()
            break
            
        case "MENU_LOGIN":
            // Signout
            GlobalCache.logonUser = nil
            
            // Signin
            showLogin()
            
            break
            
        default:
            print("No action")
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
