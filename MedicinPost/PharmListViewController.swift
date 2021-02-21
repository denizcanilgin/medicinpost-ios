//
//  PharmListViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 21.12.2020.
//  Copyright © 2020 MedicinPost. All rights reserved.
//

import UIKit
import Parse
import Kingfisher
import SkeletonView
import JGProgressHUD


class PharmListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    
    var pharms = [PFObject]()
    var selectedPharm:PFObject!
    
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var buttonContinue: UIButton!
    
    @IBAction func buttonNotifications(_ sender: Any) {
        
        self.performSegue(withIdentifier: "segue_notifications", sender: nil)
        
    }
    
    @IBAction func buttonProfileAction(_ sender: Any) {
        
        performSegue(withIdentifier: "segue_fillprofile", sender: nil)
        
    }
    @IBAction func buttonContinueAction(_ sender: Any) {
        
        retrieveUserProfile() //to check profile fillment
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue_order"{
            let destinationVC = segue.destination as! OrderViewController
            destinationVC.selectedPharm = self.selectedPharm
        }else if segue.identifier == "segue_fillprofile" {
            let destinationVC = segue.destination as! ProfileViewController
            destinationVC.senderVC = "PharmList"
            
        }
        
        
        
        
    }
    
    func checkIsProfileFilled(user: PFObject){
        
        let first_name = user["first_name"] as? String
        let last_name = user["last_name"] as? String
        let address = user["address"] as? String
        
        if (first_name == nil) || (last_name == nil) || (address == nil){
            performSegue(withIdentifier: "segue_fillprofile", sender: nil)
            return
        }
        
        if (first_name!.count < 3) || (last_name!.count < 3) || (address!.count < 3)
        {
            //Profile is not filled
            performSegue(withIdentifier: "segue_fillprofile", sender: nil)
        }else{
            
            performSegue(withIdentifier: "segue_order", sender: nil)
            
        }
        
        
        
    }
    
    var user = PFObject(className: "nil")
    
    func retrieveUserProfile(){
        
        self.showLoadingDialog()
        
        let retrievedCurrentUser = PFUser.current()
        let phoneNumber = retrievedCurrentUser?.username
        let query : PFQuery = PFUser.query()!
        
        print("beforeQuery: " + phoneNumber!)
        
        query.whereKey("username", equalTo: phoneNumber!)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            self.dismissLoadingDialog()
            
            if objects != nil {
                
                if objects!.count > 0 {
                    
                    self.user = objects![0]
                    self.checkIsProfileFilled(user: self.user)
                    
                }else{
                    
                    print("error" + " item count is zero ")
                    
                }
                
            }else{
                
                print("error" + error!.localizedDescription as String)
                
            }
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 120
        table.rowHeight = 120
        
        table.isSkeletonable = true
        table.skeletonCornerRadius = 25
        table.showAnimatedSkeleton()
        buttonContinue.isHidden = true
        
        retrievePharmacies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell_pharma"
    }
    
    func retrievePharmacies(){
        
        let query = PFQuery(className:"Pharmacy")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                for object in objects {
                    print(object.objectId as Any)
                    self.pharms.append(object)
                    
                    
                    //                   self.table.reloadData()
                }
                
                self.table.stopSkeletonAnimation()
                self.table.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                
                
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pharms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_pharma") as! PharmacyTableViewCell
        
        if indexPath.row < pharms.count{
            
            let obj = pharms[indexPath.row]
            let title = obj["Title"] as? String
            cell.lb_pharmTitle.text = title
            
            var logo_url = obj["LogoUrl"] as? String ?? "https://parsefiles.back4app.com/TKPN7Gdg11JYVDj6oAACtPaxPTQMUJLSNtoX54qq/d3acbec28fe756da02a9e21a4e6b3a57_pharmlogo.png"
            
            if logo_url.count < 5{
                logo_url = "https://parsefiles.back4app.com/TKPN7Gdg11JYVDj6oAACtPaxPTQMUJLSNtoX54qq/d3acbec28fe756da02a9e21a4e6b3a57_pharmlogo.png"
            }
            let url = URL(string: logo_url)
            cell.iv_pharmLogo.kf.setImage(with: url)
            
            
            
            let frame = CGRect(x: 10, y: 10, width: 128, height: 128)
            cell.iv_pharmLogo.frame = frame
            
            
            
        }
        
        
        return cell
    }
    
    
    let hud = JGProgressHUD()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(pharms[indexPath.row])
        buttonContinue.isHidden = false
        selectedPharm = pharms[indexPath.row]
    }
    
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
        hud.textLabel.text = "Kaydedildi"
        hud.dismiss(afterDelay: 1.0)
        
        
    }
    
}


