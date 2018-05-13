//
//  MessageViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/14/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let PAGE_SIZE = 10
    
    var messageTable: UITableView!
    
    var messages:[Message] = []
    var maxRows:Int = 0
    var isLoading:Bool = false
    var phone:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "Thông báo"
        self.view.backgroundColor = Colors.white
        
        // Create table view
        self.messageTable = UITableView()
        self.messageTable.frame.origin.x = 0
        self.messageTable.frame.origin.y = 0
        self.messageTable.frame.size = self.view.bounds.size
        self.messageTable.dataSource = self
        self.messageTable.delegate = self
        self.messageTable.separatorStyle = .none
        self.view.addSubview(self.messageTable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if GlobalCache.logonUser != nil {
            // Load message
            phone = GlobalCache.logonUser?.phone ?? ""
            loadMoreMessages(phone: phone, skip: messages.count, take: PAGE_SIZE)
        } else {
            // Show login
            let backBtn = UIBarButtonItem()
            backBtn.title = ""
            self.navigationItem.backBarButtonItem = backBtn
            
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadMoreMessages(phone:String, skip:Int, take:Int) {
        if self.isLoading == false {
            self.isLoading = true
            APIService.getMessages(phone: phone, skip: skip, take: take, handler: { (results, maxRows, message) in
                if results != nil {
                    for message in results! {
                        self.messages.append(message)
                    }
                }
                self.maxRows = maxRows
                self.messageTable.reloadData()
                self.isLoading = false
            })
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.messageTable.frame.size = size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = messages[indexPath.row]
        
        // Configure the cell...
        let cellW = cell.frame.width
        let cellH = cell.frame.height
        
        // Create BG frame
        let cellBG = UIView(frame: CGRect(x: 1, y: 1, width: cellW-2, height: cellH-1))
        cellBG.backgroundColor = UIColor.white
        cellBG.layer.cornerRadius = 4
        cell.addSubview(cellBG)
        cell.backgroundColor = UIColor.clear
        
        // Create icon
        let iconImageView = UIImageView(image: UIImage(named: "ic_bell"))
        iconImageView.frame.origin.x = 16
        iconImageView.frame.origin.y = 8
        cellBG.addSubview(iconImageView)
        
        
        // Create menu label
        let titleLabel = UILabel(frame: CGRect(
            x: 8 + iconImageView.frame.origin.x + iconImageView.frame.width,
            y: 8,
            width: cellBG.frame.width - iconImageView.frame.width - 32,
            height: 24))
        titleLabel.text = item.title ?? "Untitled"
        switch(item.status) {
        case Message.STATUS_UNREAD:
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
            break
        case Message.STATUS_READ:
            titleLabel.textColor = UIColor.gray
            titleLabel.font = UIFont.systemFont(ofSize: 15)
            break
        default:
            titleLabel.textColor = UIColor.gray
            titleLabel.font = UIFont.systemFont(ofSize: 15)
            break
        }
        cellBG.addSubview(titleLabel)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = messages.count - 1
        if indexPath.row == lastItem && messages.count < maxRows && !isLoading {
            print("Load more...")
            // Load more orders
            loadMoreMessages(phone: self.phone, skip: messages.count, take: PAGE_SIZE)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        let message = messages[indexPath.row]
        let vc = MessageDetailsViewController()
        vc.message = message
        self.navigationController?.pushViewController(vc, animated: true)
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
