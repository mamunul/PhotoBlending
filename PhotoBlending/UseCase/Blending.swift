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
    case reflect
    case colorBurn
    case colorDodge
    case difference
    case exclusion
    case glow
    case hardLight
    case lighten
    case linearBurn
    case linearDodge
    case linearLight
    case negation
    case phoenix
    case pinLight
    case vividLight
    case hardMix
    case substract
    case subtract

    
    
    func getFragmentName()->String{
        switch self {
        case .overlay:
            return "overlay"
        case .darken:
            return "darken"
        case .screen:
            return "screen"
        case .softLight:
            return "softLight"
        case .reflect:
            return "reflect"
        case .colorBurn:
            return "colorBurn"
        case .colorDodge:
            return "colorDodge"
        case .difference:
            return "difference"
        case .exclusion:
            return "exclusion"
        case .glow:
            return "glow"
        case .hardLight:
            return "hardLight"
        case .lighten:
            return "lighten"
        case .linearBurn:
            return "linearBurn"
        case .linearDodge:
            return "linearDodge"
        case .linearLight:
            return "linearLight"
        case .negation:
            return "negation"
        case .phoenix:
            return "phoenix"
        case .pinLight:
            return "pinLight"
        case .vividLight:
            return "vividLight"
        case .hardMix:
            return "hardMix"
        case .substract:
            return "substract"
        case .subtract:
            return "subtract"
        default:
            return "basic_fragment"
        }
    }
    
    static func getCount()->Int{
        return self.allCases.count
    }
}
