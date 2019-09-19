//
//  BlendingMetalViewController.swift
//  PhotoBlending
//
//  Created by New User on 21/7/19.
//  Copyright © 2019 New User. All rights reserved.
//

import UIKit
import MetalKit

class BlendingMetalViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var metalView: MTKView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    let metalRenderer = MetalRenderer()
    var foregroundImage:UIImage?
    var backgroundImage:UIImage?
    let pickerViewDataSource = PickerViewDataSource()
    
    var pinchGesture:UIPinchGestureRecognizer?
    var panGesture:UIPanGestureRecognizer?
    var transparency:Float = 1.0
    var zoomBackground:Float = 1.0
    var zoomForeground:Float = 1.0
    
    var moveBackground:CGPoint = CGPoint.zero
    var moveForeground:CGPoint = CGPoint.zero
    
    enum ImageIndex{
        case background
        case foreground
    }
    
    var selectedImageIndex = ImageIndex.background
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Do any additional setup after loading the view.
        self.setUpPickerView()
        self.setupMetaView()
        self.setupRenderer()
        metalView.device = metalRenderer?.metalDevice!
        
        pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(BlendingMetalViewController.pinchRecognized(pinch:)))
        self.view.addGestureRecognizer(self.pinchGesture!)
        
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(BlendingMetalViewController.panRecognized(pan:)))
        self.view.addGestureRecognizer(self.panGesture!)
   
    }
    
    @IBAction func panRecognized(pan: UIPanGestureRecognizer) {
        
        guard pan.view != nil else {return}
        
        let translation = pan.translation(in: metalView)
        
        if selectedImageIndex == .background {
            moveBackground = CGPoint(x: translation.x, y: translation.y)

        }else{
            moveForeground = CGPoint(x: translation.x, y: translation.y)
        }
        updateRender()
        
    }
    @IBAction func pinchRecognized(pinch: UIPinchGestureRecognizer) {

        let pinchValue = 1/Float(pinch.scale)
        
        if selectedImageIndex == .background{
            zoomBackground = pinchValue
        }else{
            zoomForeground = pinchValue
        }
        updateRender()
    }
    
    func updateRender(){
        let x1 = Float(moveBackground.x)/(Float(view.frame.size.width))
        let y1 = Float(moveBackground.y)/(Float(view.frame.size.height))
        let x2 = Float(moveForeground.x)/Float(view.frame.size.width)
        let y2 = Float(moveForeground.y)/Float(view.frame.size.height)
        metalRenderer?.update(transparency: [transparency,zoomBackground,zoomForeground,-x1,-y1,-x2,-y2])
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedImageIndex = .background
        case 1:
            selectedImageIndex = .foreground
            
        default:
            selectedImageIndex = .background
        }
    }
    
    func setUpPickerView(){
        
        pickerView.dataSource = pickerViewDataSource
        pickerView.delegate = self
    }
    
    func setupRenderer(){
        metalRenderer?.setup()
        metalRenderer?.update(imageBackground: (backgroundImage?.cgImage)!, imageForeground: (foregroundImage?.cgImage)!)
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

}

extension BlendingMetalViewController{
    
    @IBAction func swapButtonEvent(_ sender: Any) {
        
        let tempImage = foregroundImage
        foregroundImage = backgroundImage
        backgroundImage = tempImage
        metalRenderer?.update(imageBackground: (backgroundImage?.cgImage)!, imageForeground: (foregroundImage?.cgImage)!)
    }
    
    @IBAction func colorButtonEvent(_ sender: Any) {
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        
        transparency = (sender as! UISlider).value
//        metalRenderer?.update(transparency: [transparency,zoomBackground,zoomForeground])
        updateRender()
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->String?{
        
        return (BlendingMode.init(rawValue: row)?.getFragmentName())!
        
    }
}
