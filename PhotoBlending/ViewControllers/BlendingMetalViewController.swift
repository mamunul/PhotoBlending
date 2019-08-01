//
//  BlendingMetalViewController.swift
//  PhotoBlending
//
//  Created by New User on 21/7/19.
//  Copyright © 2019 New User. All rights reserved.
//

import UIKit
import MetalKit

class BlendingMetalViewController: UIViewController {
    
    @IBOutlet weak var metalView: MTKView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    let metalRenderer = MetalRenderer()
    var imageForeground:UIImage?
    var imageBackground:UIImage?
    let pickerViewDataSource = PickerViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Do any additional setup after loading the view.
        self.setUpPickerView()
        self.setupMetaView()
        self.setupRenderer()
        metalView.device = metalRenderer?.metalDevice!
   
    }
    
    func setUpPickerView(){
        
        pickerView.dataSource = pickerViewDataSource
        pickerView.delegate = self
    }
    
    func setupRenderer(){
        metalRenderer?.setup()
        metalRenderer?.update(imageBackground: (imageBackground?.cgImage)!, imageForeground: (imageForeground?.cgImage)!)
        metalRenderer?.update(blending: BlendingMode.overlay)
    }
    
    func setupMetaView(){
        metalView.delegate = self
        metalView.framebufferOnly = false
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.contentScaleFactor = UIScreen.main.nativeScale
        metalView.clearColor = MTLClearColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        metalView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        metalView.preferredFramesPerSecond = 30
    }

    
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        
        let transparency = (sender as! UISlider).value
        
        metalRenderer?.update(transparency: transparency)
    }


}

extension BlendingMetalViewController:MTKViewDelegate{
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        metalRenderer?.render(metalView: view)
        
    }
}


extension BlendingMetalViewController:UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        metalRenderer?.update(blending: BlendingMode(rawValue: row)!)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->String{
        
        return (BlendingMode.init(rawValue: row)?.getFragmentName())!
        
    }
}
