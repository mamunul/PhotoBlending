//
//  Blending.swift
//  PhotoBlending
//
//  Created by New User on 31/7/19.
//  Copyright © 2019 New User. All rights reserved.
//

import Foundation

enum BlendingMode:Int,CaseIterable{
    case overlay
    case screen
    case softLight
    case darken
    
    
    func getFragmentName()->String{
        switch self {
        case .overlay:
            return "overlay"
        case .darken:
            return "screen"
        case .screen:
            return "softLight"
        case .softLight:
            return "darken"
        default:
            return "basic_fragment"
        }
    }
    
    static func getCount()->Int{
        return self.allCases.count
    }
}
