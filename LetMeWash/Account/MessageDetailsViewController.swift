//
//  MessageDetailsViewController.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/16/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class MessageDetailsViewController: UIViewController {

    
    var scrollView:UIScrollView!
    var titleLabel:UILabel!
    var dateLabel:UILabel!
    var seperatorView:UIView!
    var messageLabel:UILabel!
    
    var message:Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Chi tiết thông báo"
        self.view.backgroundColor = Colors.white
        
        initControls()
        
        // Show message
        if self.message != nil {
            showMessage(message: self.message!)
            updateMessageStatus(messageId: self.message?.messageId ?? 0, status: Message.STATUS_READ)
        }
        
        // Relayout
        relayoutControls(frameSize: self.view.bounds.size)
    }
    
    func initControls() {
        
        scrollView = UIScrollView()
        // scrollView.backgroundColor = UIColor.brown
        self.view.addSubview(scrollView)
        
        titleLabel = UILabel()
        titleLabel.text = "-"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        scrollView.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.text = "-"
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = UIColor.gray
        scrollView.addSubview(dateLabel)
        
        seperatorView = UIView()
        seperatorView.backgroundColor = UIColor.lightGray
        scrollView.addSubview(seperatorView)
        
        messageLabel = UILabel()
        messageLabel.text = "-"
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        
        scrollView.addSubview(messageLabel)
    }
    
    func relayoutControls(frameSize: CGSize) {
        
        // ScrollView
        scrollView.frame.origin.x = 0
        scrollView.frame.origin.y = 0
        scrollView.frame.size.width = frameSize.width
        scrollView.frame.size.height = frameSize.height
        
        titleLabel.frame.origin.x = 8
        titleLabel.frame.origin.y = 8
        titleLabel.frame.size.width = frameSize.width - 16
        let title = titleLabel.text ?? ""
        titleLabel.frame.size.height = title.height(withConstrainedWidth: frameSize.width - 16, font: titleLabel.font)
        
        dateLabel.frame.origin.x = 8
        dateLabel.frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.height + 4
        dateLabel.frame.size.width = frameSize.width - 16
        let date = dateLabel.text ?? ""
        dateLabel.frame.size.height = date.height(withConstrainedWidth: frameSize.width  - 16, font: dateLabel.font)
        
        seperatorView.frame.origin.x = 8
        seperatorView.frame.origin.y = dateLabel.frame.origin.y + dateLabel.frame.height + 4
        seperatorView.frame.size.width = frameSize.width - 16
        seperatorView.frame.size.height = 1
        
        messageLabel.frame.origin.x = 8
        messageLabel.frame.origin.y = seperatorView.frame.origin.y + seperatorView.frame.height + 4
        messageLabel.frame.size.width = frameSize.width - 16
        let message = messageLabel.text ?? ""
        messageLabel.frame.size.height = message.height(withConstrainedWidth: frameSize.width - 16, font: messageLabel.font)
        
        
        // Set srollview Content size
        scrollView.contentSize.height = messageLabel.frame.origin.y + messageLabel.frame.height + 8
    }
    
    func showMessage(message:Message) {
        let dateFormatter = DateFormatter()
        
        let title = message.title ?? "{Tiêu đề rỗng}"
        let date = Converter.getDate(dateString: message.date ?? "")
        let message = message.message ?? "{Thông điệp rỗng}"
        
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        
        titleLabel.text = title
        dateLabel.text = date != nil ? "Thời gian: \(dateFormatter.string(from: date!))" : "Thời gian: -"
        messageLabel.text = message
    }
    
    func updateMessageStatus(messageId:Int, status:Int) {
        APIService.updateMessageStatus(messageId: messageId, status: status, handler: {(returnCode, returnMessage) in
            // do nothing
        })
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
