//
//  Intro4ViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 29.12.2020.
//  Copyright © 2020 MedicinPost. All rights reserved.
//

import UIKit

class Intro4ViewController: UIViewController {

    @IBAction func buttonNext(_ sender: Any) {
        performSegue(withIdentifier: "segue_introEND", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
