//
//  NotificationViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 21.02.2021.
//  Copyright © 2021 MedicinPost. All rights reserved.
//

import UIKit
import Parse
import JGProgressHUD

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var notifications = [PFObject]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_notification") as! NotificationTableViewCell
        
        if indexPath.row < notifications.count{
            
            let obj = notifications[indexPath.row]
            let title = obj["Title"] as? String
            let desc = obj["Desc"] as? String
            
            cell.title.text = title
            cell.desc.text = desc
            
        }
        
        
        return cell
    }
    
    var selectedNotification: PFObject?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedNotification = self.notifications[indexPath.row]
        
        self.performSegue(withIdentifier: "segue_notification_details", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue_notification_details" {
            
            let destinationVC = segue.destination as! NotificationDetailsViewController
            destinationVC.notification = self.selectedNotification
        }
        
    }
    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.rowHeight = 90
        self.retrieveNotifications()
    }
    
    func retrieveNotifications(){
        
        self.showLoadingDialog()
        self.notifications = [PFObject]()
        
        let user = PFUser.current()
        let query = PFQuery(className: "Notifications")
        query.whereKey("Receiver", equalTo: user)
        query.findObjectsInBackground { (notifications: [PFObject]?, error:Error?) in
            
            
            self.dismissLoadingDialog()
            
            if notifications != nil {
                
                if notifications!.count > 0 {
                    
                    for ntfcn in notifications! {
                        
                        print(ntfcn["Title"])
                        self.notifications.append(ntfcn)
                        
                    }
                    
                    self.table.reloadData()
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
    let hud = JGProgressHUD()
    
    func showLoadingDialog(){
        
        hud.textLabel.text = ""
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.show(in: self.view)
        
    }
    
    
    func dismissLoadingDialog(){
        
        hud.dismiss()
        
    }
    
    func showSuccessDialog(){
        
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: self.view)
        hud.textLabel.text = "Başarılı"
        hud.dismiss(afterDelay: 1.0)
        
        
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
        closeAction.image = UIImage(named: "tick")
        closeAction.backgroundColor = .purple
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Temizle", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.deleteNotification(ntf: self.notifications[indexPath.row])
            success(true)
        })
        modifyAction.image = UIImage(named: "hammer")
        modifyAction.backgroundColor = .gray
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    
    func deleteNotification(ntf: PFObject){
        
        self.showLoadingDialog()
        
        ntf.deleteInBackground { (result: Bool, error: Error?) in
            
            if result {
                self.showSuccessDialog()
                self.retrieveNotifications()
            }else{
                self.dismissLoadingDialog()
            }
            
        }
        
    }
    
    
}
