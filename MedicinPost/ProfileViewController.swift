//
//  ProfileViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 1.01.2021.
//  Copyright © 2021 MedicinPost. All rights reserved.
//

import UIKit
import Parse
import JGProgressHUD


class ProfileViewController: ViewController {
    
    @IBOutlet weak var tf_firstName: UITextField!
    @IBOutlet weak var tf_lastName: UITextField!
    @IBOutlet weak var tf_phoneNum: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_address: UITextField!
    @IBAction func bt_saveAction(_ sender: Any) {
        self.saveProfile()
    }
    
    
    public var senderVC: String = ""
    
    @IBAction func bt_continueOrderButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "segue_pharmlist_from_profile", sender: nil)
        
    }
    
    @IBOutlet weak var bt_continueOrderButton: UIButton!
    
    var user: PFObject = PFUser.current()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveAndFillTheProfileFields()
        
        self.tf_phoneNum.isUserInteractionEnabled = false
        self.tf_phoneNum.alpha = 0.5
        self.bt_continueOrderButton.alpha = 0
        self.bt_continueOrderButton.isUserInteractionEnabled = false
    
        
    }
    
    func retrieveAndFillTheProfileFields(){
        
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
                    let first_name = self.user["first_name"] as? String
                    let last_name = self.user["last_name"] as? String
                    let phone_number = self.user["phone"] as? String
                    let username = self.user["username"] as? String
                    let object_id = self.user.objectId
                    let address = self.user["address"] as? String
                    let email = self.user["email"] as? String
                    
                    self.tf_firstName.text = first_name
                    self.tf_lastName.text = last_name
                    self.tf_phoneNum.text = phone_number
                    self.tf_address.text = address
                    self.tf_email.text = email
                    
                }else{
                    
                    print("error" + " item count is zero ")
                    
                }
                
            }else{
                
                print("error" + error!.localizedDescription as String)
                
            }
            
            
        }
        
        
        
    }
    
    func saveProfile(){
        
        self.showLoadingDialog()
                
        let first_name = self.tf_firstName.text
        let last_name = self.tf_lastName.text
        let phoneNum = self.tf_phoneNum.text
        let address = self.tf_address.text
        let email = self.tf_email.text
        
        user["first_name"] = first_name
        user["last_name"] = last_name
        user["address"] = address
        user["email"] = email

        user.saveInBackground { (isSuccess: Bool,error: Error?) in
            
            
            if isSuccess {
                
                print("başarıyla kaydedildi!")
                self.showSuccessDialog()
                
                if self.checkInputs() {
                    
                    self.bt_continueOrderButton.alpha = 1
                    self.bt_continueOrderButton.isUserInteractionEnabled = true
                    
                }else{
                    
                    self.bt_continueOrderButton.alpha = 0
                                       self.bt_continueOrderButton.isUserInteractionEnabled = false
                    
                }
                
            }else {
                
                
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
        hud.textLabel.text = "Kaydedildi"
        hud.dismiss(afterDelay: 1.0)


    }
    
    func checkInputs() -> Bool{
        
              let first_name = self.tf_firstName.text
              let last_name = self.tf_lastName.text
              let phoneNum = self.tf_phoneNum.text
              let address = self.tf_address.text
              let email = self.tf_email.text
        
        var isProfileFilled = true;
        
        if first_name!.count < 3 {
            isProfileFilled = false
        }else if last_name!.count < 3 {
            isProfileFilled = false
        }else if address!.count < 3 {
            isProfileFilled = false
        }else if email!.count < 3{
            isProfileFilled = false
        }
        
        return isProfileFilled
        
    }
    
}
