//
//  Intro1ViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 28.12.2020.
//  Copyright © 2020 MedicinPost. All rights reserved.
//

import UIKit

class Intro1ViewController: UIViewController {

      @IBAction func buttonNext(_ sender: Any) {
            performSegue(withIdentifier: "segue_intro2", sender: nil)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
