//
//  EnterVerCodeViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 21.12.2020.
//  Copyright © 2020 MedicinPost. All rights reserved.
//

import UIKit
import Parse

class EnterVerCodeViewController: UIViewController {
    
    var phoneNumber:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func completePhoneAuthAction(_ sender: Any) {
        
//        self.performSegue(withIdentifier: "segue_pharmalist", sender: nil)
        checkforUser()
        
    }
    
    func checkforUser(){
        
        print("Entered Phone Numb: " + " " + phoneNumber!)
        
        var query : PFQuery = PFUser.query()!
        query.whereKey("phone", equalTo: phoneNumber)
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil{
            
                if objects != nil{
                    if objects!.count > 0 {
                        
                        print(objects![0]["phone"])
                        //A registered user with this phone number is found, go for logging in!
                        self.loginToParse(user: objects![0] as! PFUser)
                        
                        
                    }else{ self.registerToParse();   print("RESUL: " + " nil ")}
                }else {
                    self.registerToParse()
                       print("RESUL: " + " nil ")
                }
            }else{
                
                print("RESUL: " + " error " + error!.localizedDescription)

            }
        })
        
    }
    
    func loginToParse(user:PFUser){
        
        //Handle Parse Login HERE
        
        let username = user.username ?? "username"
        
        PFUser.logInWithUsername(inBackground:username, password:"24232423") {
          (user: PFUser?, error: Error?) -> Void in
          if user != nil {
            // Do stuff after successful login.
            print("BAŞARILI GİRİŞ")
            // Perform segue here
            
            self.performSegue(withIdentifier: "segue_pharmalist", sender: nil)
            
          } else {
            // The login failed. Check error to see why.
            print("HATALI GİRİŞ")
            self.showAlertDialog(title: "Hata", msg: "Bir hata meydana geldi!")

          }
        }
        
    }
    
    func registerToParse(){
        
        //Handle Parse REG HERE
        var user = PFUser()
        user.username = phoneNumber
        user.password = "24232423"
        user["open_pass"] = "24232423"
        user["phone"] = phoneNumber

        user.signUpInBackground {
          (succeeded: Bool, error: Error?) -> Void in
          if let error = error {
            let errorString = error.localizedDescription
            // Show the errorString somewhere and let the user try again.
            
              self.showAlertDialog(title: "Hata", msg: "Bir hata meydana geldi!")
            
          } else {
            // Hooray! Let them use the app now.
            
              self.performSegue(withIdentifier: "segue_pharmalist", sender: nil)
          }
        }
        
    }
    
    func showAlertDialog(title:String,msg:String){
             
             let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)

             alert.addAction(UIAlertAction(title: "Tekrar Dene", style: .default, handler: {action in
                
                self.performSegue(withIdentifier: "segue_tryagain", sender: nil)
                
             }
             
                
                
             ))

             self.present(alert, animated: true)
             
         }
    

    
}
