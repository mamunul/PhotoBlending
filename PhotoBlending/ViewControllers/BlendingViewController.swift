//
//  BlendingViewController.swift
//  PhotoBlending
//
//  Created by New User on 21/7/19.
//  Copyright © 2019 New User. All rights reserved.
//

import UIKit
import CoreImage

class BlendingViewController: UIViewController {
    
    var imageForeground:UIImage?
    var imageBackground:UIImage?

    @IBOutlet weak var blendedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad() 
    }
    
    
    @IBAction func sliderValueChanged(_ sender: Any) {
   
       imageForeground = self.updateOpacity(image: imageForeground!, alpha: CGFloat((sender as! UISlider).value))
        
        self.blend()
    }
    
    
    func blend(){
    
        DispatchQueue.global().async {
            guard let image1 = CIImage(image: self.imageForeground!), let image2 = CIImage(image: self.imageBackground!) else{return}

            if let blendedImage = CIBlendKernel.overlay.apply(foreground: image1, background: image2){
                DispatchQueue.main.async {
                    self.blendedImageView.image = UIImage.init(ciImage: blendedImage)
                }
            }
        }
    }
    
    func updateOpacity(image:UIImage,alpha: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

}
