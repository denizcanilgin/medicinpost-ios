//
//  ViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 9.12.2020.
//  Copyright © 2020 MedicinPost. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var tf_phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        PFUser.logOut()
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier != "segue_codesent" {
            
            return
            
        }
        
        let phoneNum = tf_phoneNumber.text
        
        if phoneNum == nil {
            return
        }
        
        if phoneNum!.count < 5 {
            
            showDialog(title: "Hata", message: "Lütfen geçerli bir telefon numarası giriniz.")
            
            return
        }
        
        if !phoneNum!.contains("+") {
            
            showDialog(title: "Hata", message: "Lütfen geçerli bir telefon numarası giriniz.")
            
            return
        }
        
        let trimmed = phoneNum?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let destinationVC = segue.destination as! EnterVerCodeViewController
        destinationVC.phoneNumber = trimmed
    }
    
    @IBAction func sendVerCodeAction(_ sender: Any) {
        
        self.sendVerCode(phoneNumber:tf_phoneNumber.text ?? "")
        
    }
    
    func sendVerCode(phoneNumber:String){
         
//                 do { try Auth.auth().signOut() }
//                 catch { print("already logged out") }
         
         PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
             if let error = error {
                 self.showDialog(title: "Hata", message: error.localizedDescription)
                 return
             }else{
                   UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.performSegue(withIdentifier: "segue_codesent", sender: nil)
                 let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                                       print(verificationID)
             }
           
                      
//                         self.startNewVC()

         }
         
     }
    
    func showDialog(title:String, message:String){
          
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          
          alert.addAction(UIAlertAction(title: "Anladım", style: .default, handler: { action in
//              self.tfPhoneNumber.text = ""
          }))
          
          
          self.present(alert, animated: true)
          
      }
      


}

