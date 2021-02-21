//
//  NotificationDetailsViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 21.02.2021.
//  Copyright © 2021 MedicinPost. All rights reserved.
//

import UIKit
import JGProgressHUD
import Parse

class NotificationDetailsViewController: UIViewController {
    
    public var notification: PFObject?
   
    @IBOutlet weak var ll_desc: UILabel!
    @IBOutlet weak var ll_title: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ntfTitle = notification?["Title"] as? String
        let ntfDesc = notification?["Desc"] as? String
        
        ll_title.text = ntfTitle
        ll_desc.text = ntfDesc

    }
    



}
