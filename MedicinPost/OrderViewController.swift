//
//  OrderViewController.swift
//  MedicinPost
//
//  Created by Deniz Can Ilgın on 28.12.2020.
//  Copyright © 2020 MedicinPost. All rights reserved.
//

import UIKit
import Parse
import Kingfisher
import BLTNBoard
import M13Checkbox

class OrderViewController: ViewController {
    
    var selectedPharm:PFObject!
    var parseImageFile:PFFileObject?
    
    @IBOutlet weak var pharmView: UIView!
    @IBOutlet weak var pharmTitle: UILabel!
    @IBOutlet weak var pharmLogo: UIImageView!
    @IBOutlet weak var orderNote: UITextField!
    @IBOutlet weak var buttonPickImageOutler: UIButton!
    
    @IBAction func buttonPickImage(_ sender: UIButton) {
        
        boardManager.showBulletin(above: self)
        
    }
    @IBAction func buttonContinue(_ sender: Any) {
        
        if parseImageFile == nil {
            
            showAlertDialog(title: "Reçete eksik!", msg: "Lütfen reçetenin fotoğrafını çekin veya galeriden seçin.")
            return
        }
        
        performSegue(withIdentifier: "segue_confirmorder", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ConfirmOrderViewController
        destinationVC.orderNote = self.orderNote.text
        destinationVC.selectedPharm = self.selectedPharm
        destinationVC.orderImage = self.parseImageFile
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        self.navigationController?.title = "asdasd"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let title = selectedPharm["Title"] as? String
        pharmTitle.text = title
        
        var logo_url = selectedPharm["LogoUrl"] as? String ?? "https://parsefiles.back4app.com/TKPN7Gdg11JYVDj6oAACtPaxPTQMUJLSNtoX54qq/d3acbec28fe756da02a9e21a4e6b3a57_pharmlogo.png"
        
        if logo_url.count < 5{
            logo_url = "https://parsefiles.back4app.com/TKPN7Gdg11JYVDj6oAACtPaxPTQMUJLSNtoX54qq/d3acbec28fe756da02a9e21a4e6b3a57_pharmlogo.png"
        }
        let url = URL(string: logo_url)
        pharmLogo.kf.setImage(with: url)
        
        
        
        let frame = CGRect(x: 10, y: 10, width: 52, height: 52)
        pharmLogo.frame = frame
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        print(image.size)
        let imageData = image.pngData()
        let imageFile = PFFileObject(name:"image.png", data:imageData!)
        self.parseImageFile = imageFile
        buttonPickImageOutler.setImage(UIImage(named:"checkmarkgreen"), for: .normal)
        
    }
    
    
    private lazy var boardManager: BLTNItemManager = {
        
        let item = BLTNPageItem(title: "Reçetenin")
        item.actionButtonTitle = "Fotoğrafını Çekin"
        item.alternativeButtonTitle = "Galeriden Seçin"
        item.descriptionText = "Reçetenin fotoğrafı yalnızca sipariş verdiğiniz eczaneye iletilecek olup uçtan uca şifrelenmektedir."
        
    
        
        item.actionHandler = { action in self.takePhotoWithCamera()}
        item.alternativeHandler = {action in self.pickImageFromGallery()}
        
        
        return BLTNItemManager(rootItem: item)
    }()
    
    
    
    
}

extension OrderViewController:
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    // MARK:- Image Helper Methods
    func takePhotoWithCamera() {
        boardManager.dismissBulletin()
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func pickImageFromGallery(){
        boardManager.dismissBulletin()
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func showAlertDialog(title:String,msg:String){
           
           let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)

           alert.addAction(UIAlertAction(title: "Anladım", style: .default, handler: nil))

           self.present(alert, animated: true)
           
       }
    
}
