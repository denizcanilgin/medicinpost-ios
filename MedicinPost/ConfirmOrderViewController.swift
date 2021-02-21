//
//  ConfirmOrderViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 28.12.2020.
//  Copyright © 2020 MedicinPost. All rights reserved.
//

import UIKit
import Parse
import JGProgressHUD

class ConfirmOrderViewController: ViewController {
    
    
    @IBOutlet weak var ll_address: UILabel!
    @IBOutlet weak var ll_contactPerson: UILabel!
    @IBOutlet weak var ll_phoneNumber: UILabel!
    @IBOutlet weak var iv_orderImage: UIImageView!
    @IBOutlet weak var ll_note: UILabel!
    var orderNote:String?
    var selectedPharm:PFObject?
    var orderImage:PFFileObject?
    var indicator: UIActivityIndicatorView!
    
    @IBAction func buttonConfirm(_ sender: Any) {
        
        uploadOrder()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoading()
        
        if orderNote != nil && ll_note != nil{
            ll_note.text = "  " + orderNote!
        }
        if PFUser.current() != nil {
            
            if PFUser.current()!["PhoneNumber"] != nil {
                
                ll_phoneNumber.text = PFUser.current()!["PhoneNumber"] as? String
                
                
                
                
            }
            
        }
        
        
        
        self.orderImage?.getDataInBackground { (imageData: Data?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let imageData = imageData {
                let image = UIImage(data:imageData)
                self.iv_orderImage.image = image
            }
        }
        
        self.retrieveUserProfile()
        
    }
    
    
    func uploadOrder(){
        
        self.indicator.startAnimating()
        
        let currentUser = PFUser.current()
        let order = PFObject(className:"Order")
        if currentUser != nil {order["User"] = currentUser}
        order["Pharmacy"] = selectedPharm
        order["Note"] = orderNote
        if orderImage != nil { order["Image"] = orderImage
            let imageUrl = orderImage?.url
            if imageUrl != nil { order["ImageUrl"] = imageUrl}}
        order.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
                self.performSegue(withIdentifier: "segue_ordercompleted", sender: nil)
            } else {
                // There was a problem, check error.description
                
                let errorMsg = error?.localizedDescription ?? "Bir hata meydana geldi!"
                
                self.showAlertDialog(title: "Hata", msg: errorMsg )
                
            }
            
            self.indicator.stopAnimating()
        }
        
    }
    
    func showAlertDialog(title:String,msg:String){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Anladım", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func initLoading(){
        
        indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
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
                    self.fillUserBasedOrderDetails(user: self.user)
                    
                }else{
                    
                    print("error" + " item count is zero ")
                    
                }
                
            }else{
                
                print("error" + error!.localizedDescription as String)
                
            }
            
            
        }
        
    }
    
    let hud = JGProgressHUD()
    
    
    func fillUserBasedOrderDetails(user:PFObject){
        
        let first_name = self.user["first_name"] as? String
        let last_name = self.user["last_name"] as? String
        let phone_number = self.user["phone"] as? String
        let username = self.user["username"] as? String
        let object_id = self.user.objectId
        let address = self.user["address"] as? String
        let email = self.user["email"] as? String
        
        let full_name = first_name! + last_name!
        
        self.ll_address.text = "  " + address!
        self.ll_contactPerson.text = "  " +  full_name
        self.ll_phoneNumber.text = "  " +  phone_number!
        
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
