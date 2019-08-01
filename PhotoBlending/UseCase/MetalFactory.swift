//
//  MetalFactory.swift
//  PhotoBlending
//
//  Created by New User on 31/7/19.
//  Copyright © 2019 New User. All rights reserved.
//

import Foundation
import MetalKit
import Metal

struct Vertex:Decodable{
    
    var x,y,z: Float     // position data
    //    var r,g,b,a: Float   // color data
    var s,t: Float       // texture coordinates
    
    func floatBuffer() -> [Float] {
        return [x,y,z,s,t]
    }
    
};


class MetalFactory {
    
    class func loadVertexData(metalDevice:MTLDevice) -> (MTLBuffer?,Int){
        
        let va = Vertex(x: -1.0, y: 1.0, z: 0.0, s: 0.0, t: 0.0)
        let vb = Vertex(x: 1.0, y: 1.0, z: 0.0, s: 1.0, t: 0.0)
        let vc = Vertex(x: -1.0, y: -1.0, z: 0.0, s: 0.0, t: 1.0)
        let vd = Vertex(x: 1.0, y: -1.0, z: 0.0, s: 1.0, t: 1.0)
        
        let indices = [va,vc,vb,
                       vc,vd, vb
        ]
        
        var vertices = [Float]()
        
        var i = 0
        for v in indices {
            vertices.insert(contentsOf: v.floatBuffer(), at: i)
            i = i+5
            
        }
        
        
        let bufferSize = vertices.count * MemoryLayout.size(ofValue: vertices[0])
        
        let vertexBuffer = metalDevice.makeBuffer(bytes: vertices, length: bufferSize, options: [])
        
        vertexBuffer?.label = "vertices"
        return (vertexBuffer,indices.count)
    }
    
    class func build(vertexFunction:MTLFunction,fragmentFunction:MTLFunction)->MTLRenderPipelineDescriptor{
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.depthAttachmentPixelFormat = MTLPixelFormat.depth32Float
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        
        pipelineDescriptor.colorAttachments[0].rgbBlendOperation = MTLBlendOperation.add
        pipelineDescriptor.colorAttachments[0].alphaBlendOperation = MTLBlendOperation.add
        
        pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactor.one
        pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactor.one
        
        pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactor.oneMinusSourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactor.oneMinusSourceAlpha
        
    
        
        return pipelineDescriptor
    }
}
