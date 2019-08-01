//
//  PickerViewDataSource.swift
//  PhotoBlending
//
//  Created by New User on 1/8/19.
//  Copyright © 2019 New User. All rights reserved.
//

import Foundation
import UIKit

class PickerViewDataSource: NSObject,UIPickerViewDataSource {
    
    override init() {
        super.init()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return BlendingMode.getCount()
    }
    


    
}
