//
//  OrderCompletedViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 28.12.2020.
//  Copyright © 2020 MedicinPost. All rights reserved.
//

import UIKit

class OrderCompletedViewController: ViewController {

    

    @IBAction func buttonDone(_ sender: Any) {
        
        performSegue(withIdentifier: "segue_mainmenu", sender: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}
