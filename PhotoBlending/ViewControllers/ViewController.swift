//
//  ViewController.swift
//  PhotoBlending
//
//  Created by New User on 14/7/19.
//  Copyright © 2019 New User. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var foregroundImageView: UIImageView!
    var imagePicker:UIImagePickerController?
    var imageA:UIImage?
    var imageB:UIImage?
    enum ImageNo{
        case image_a
        case image_b
    }
    var imagePosition:ImageNo?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = .savedPhotosAlbum
        
    }
    
    @IBAction func chooseImage1Action(_ sender: Any) {
        imagePosition = .image_a
        self.openImagePickerViewController()
    }
    
    @IBAction func chooseImage2Action(_ sender: Any) {
        imagePosition = .image_b
        self.openImagePickerViewController()
    }
    
    @IBAction func goToBlendView(_ sender: Any) {
        if let blendingViewController = self.storyboard?.instantiateViewController(withIdentifier: "metalViewController") as? BlendingMetalViewController{
            blendingViewController.imageBackground = imageA
            blendingViewController.imageForeground = imageB
            
            self.navigationController?.present(blendingViewController, animated: true)
        }
    }
    
    func openImagePickerViewController(){
        self.present(imagePicker!, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return
        }
       
        if imagePosition == .image_a {
            imageA = image
            backgroundImageView.image = imageA
        }else{
            imageB = image
            foregroundImageView.image = imageB
        }
        
        imagePicker?.dismiss(animated: true)
    }
}

