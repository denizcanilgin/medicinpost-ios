//
//  ConfirmOrderViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 28.12.2020.
//  Copyright © 2020 MedicinPost. All rights reserved.
//

import UIKit
import Parse

class ConfirmOrderViewController: ViewController {
    

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
        
        ll_note.text = "  " + orderNote!
        
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


}
