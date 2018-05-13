//
//  ViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 12/26/17.
//  Copyright © 2017 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var seviceGroupCollectioView: UICollectionView!
    
    var notificationButton:BadgeButton!
    
    var serviceGroups:[ServiceGroup] = []
    var itemsPerRow:CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Trang chủ"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_01")!)
        
        // Create notification badge button
        self.notificationButton = BadgeButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        self.notificationButton.setImage(UIImage(named: "ic_alarm")?.withRenderingMode(.automatic), for: .normal)
        self.notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        self.notificationButton.badgeBackgroundColor = Colors.cyan
        self.notificationButton.badgeTextColor = Colors.white
        self.notificationButton.badge = nil
        self.notificationButton.addTarget(self, action: #selector(showMessages), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        
        // Create service group collection view
        seviceGroupCollectioView.dataSource = self
        seviceGroupCollectioView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Load service groups
        APIService.getServiceGroups(handler: {(results, message) in
            print(message)
            if let groups = results {
                self.serviceGroups.removeAll();
                for item in groups {
                    self.serviceGroups.append(item)
                }
                self.seviceGroupCollectioView.reloadSections(IndexSet(integer: 0))
            }
        })
        
        // Get message summary
        if GlobalCache.logonUser != nil {
            let phone = GlobalCache.logonUser?.phone
            DispatchQueue.main.async(execute: {
                self.getMessageSummary(phone: phone!)
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Show tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.seviceGroupCollectioView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMessageSummary(phone:String) {
        APIService.getMessageSummary(phone: phone, handler: { (success, summary, message) in
            self.showMessageSummary(summary: summary)
        })
    }
    
    @objc func showMessages() {
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        let vc = MessageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showMessageSummary(summary:MessageSummary?) {
        let unread = summary?.unread ?? 0
        if unread > 0 {
            self.notificationButton.badge = "\(unread)"
        } else {
            self.notificationButton.badge = nil
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 0.95)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceGroupViewCell", for: indexPath)
        let item = serviceGroups[indexPath.row]
        var wasInitControls = false
        
        let ICON_TAG = 100
        let NAME_TAG = 101
        
        // Find controls
        for view in cell.subviews {
            if view.tag == ICON_TAG || view.tag == NAME_TAG {
                wasInitControls = true
                break
            }
        }
        
        // Create controls
        if !wasInitControls {
            let iconView = UIImageView()
            let nameLabel = UILabel()
            
            // Show service group item
            iconView.downloadedFrom(link: item.iconURL ?? "http://locnp.ddns.net/Content/images/lmw_logo.jpg")
            iconView.tag = ICON_TAG
            
            nameLabel.text = item.groupName ?? "Untitled"
            nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
            nameLabel.textColor = Colors.black
            nameLabel.textAlignment = .center
            nameLabel.tag = NAME_TAG
            
            // Positioning the controls
            iconView.frame.size = CGSize(width: 75, height: 75)
            iconView.frame.origin.x = (cell.frame.width - iconView.frame.width) / 2
            iconView.frame.origin.y = 16
            cell.addSubview(iconView)
            
            nameLabel.frame.origin.x = 4
            nameLabel.frame.origin.y = iconView.frame.origin.y + iconView.frame.height + 8
            nameLabel.frame.size.width = cell.frame.width - nameLabel.frame.origin.x * 2
            nameLabel.frame.size.height = 24
            cell.addSubview(nameLabel)
            
        } else {
            // Show service group item
            for view in cell.subviews {
                if view.tag == ICON_TAG  {
                    let iconView = view as? UIImageView
                    iconView?.downloadedFrom(link: item.iconURL ?? "http://locnp.ddns.net/Content/images/lmw_logo.jpg")
                }
                if view.tag == NAME_TAG {
                    let nameLabel = view as? UILabel
                    nameLabel?.text = item.groupName ?? "Untitled"
                }
            }
        }
        
        // Configure the cell
        cell.layer.cornerRadius = 4
        cell.backgroundColor = Colors.white.withAlphaComponent(0.9)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Select item at \(indexPath.row)")
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ServiceVC") as! ServiceViewController
        vc.group = serviceGroups[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

