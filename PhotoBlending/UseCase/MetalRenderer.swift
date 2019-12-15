//
//  MetalRenderer.swift
//  PhotoBlending
//
//  Created by New User on 23/7/19.
//  Copyright © 2019 New User. All rights reserved.
//

import UIKit
import MetalKit
import Metal

class MetalRenderer {
    
    var metalDevice:MTLDevice?
    var metalLibrary:MTLLibrary?
    var commandQueue:MTLCommandQueue?
    var renderPipelineState:MTLRenderPipelineState?
    var fragmentFunction:MTLFunction?
    var vertexFunction:MTLFunction?
    var vertexBuffer:MTLBuffer?
    var indexCount = 0
    var transparency:[Float] = [0.0,1.0,1.0,0.0,0.0,0.0,0.0]
    var renderPipelineDescriptor:MTLRenderPipelineDescriptor?
    var textureBackground:MTLTexture?
    var textureForeground:MTLTexture?
    var blendingMode:[Int] = [0]
    var metalView:MTKView?
    
    init?() {
        metalDevice = MTLCreateSystemDefaultDevice()
        metalLibrary = metalDevice?.makeDefaultLibrary()
        commandQueue = metalDevice?.makeCommandQueue()
        
        guard metalDevice != nil, metalLibrary != nil,commandQueue != nil else {
            return nil
        }
    }

    
    func setup(){
        
        fragmentFunction = metalLibrary?.makeFunction(name: "basic_fragment")
        vertexFunction = metalLibrary?.makeFunction(name: "basic_vertex")
        
        renderPipelineDescriptor = MetalFactory.build(mtkView: self.metalView!, vertexFunction: vertexFunction!, fragmentFunction: fragmentFunction!)
        
        (vertexBuffer,indexCount) = MetalFactory.loadVertexData(metalDevice: metalDevice!)
        
        do{
            renderPipelineState = try metalDevice!.makeRenderPipelineState(descriptor: renderPipelineDescriptor!)
        }catch{
            print(error)
        }
        
    }
    
    func update(imageBackground:CGImage, imageForeground:CGImage){
        let textureLoaderOptions = [
            MTKTextureLoader.Option.textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue),
            MTKTextureLoader.Option.textureStorageMode: NSNumber(value: MTLStorageMode.`private`.rawValue)
        ]
        do{
            textureBackground = try MTKTextureLoader.init(device: metalDevice!).newTexture(cgImage: imageBackground, options: textureLoaderOptions)
            textureForeground = try MTKTextureLoader.init(device: metalDevice!).newTexture(cgImage: imageForeground, options: textureLoaderOptions)
        }catch{
            
        }
    }
    
    func update(imageForeground:CGImage,imageDepth:CGImage){
        
    }
    
    func update(transparency:[Float]){
        self.transparency = transparency
    }
    
    func update(blending:BlendingMode){
//        blendingMode = [blending.rawValue]
        
        update(fragmentShader: blending.getFragmentName())

    }
    
    func update(fragmentShader:String){
        fragmentFunction = metalLibrary?.makeFunction(name: fragmentShader)
        renderPipelineDescriptor?.fragmentFunction = fragmentFunction
        
        do{
            renderPipelineState = try metalDevice!.makeRenderPipelineState(descriptor: renderPipelineDescriptor!)
        }catch{
           
        }
        
    }
 
    
    func render(){
        let commandBuffer = commandQueue?.makeCommandBuffer()
        
        let (depth,stencil) = MetalFactory.allocateDepthStencilTextures(device: self.metalDevice!, metalKitView: metalView!)
        let renderPassDescriptor = metalView!.currentRenderPassDescriptor
        renderPassDescriptor!.depthAttachment.texture = depth
        renderPassDescriptor!.stencilAttachment.texture = stencil
        
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState!)
        renderCommandEncoder?.setFragmentBytes(transparency, length: MemoryLayout<Float>.size * transparency.count, index: 0)
        renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.setFragmentTexture(textureBackground, index: 0)
        renderCommandEncoder?.setFragmentTexture(textureForeground, index: 1)
        renderCommandEncoder?.drawPrimitives(type: MTLPrimitiveType.triangle, vertexStart: 0, vertexCount: indexCount)
        
        renderCommandEncoder?.endEncoding()
        
        if let drawable = metalView?.currentDrawable {
            commandBuffer?.present(drawable)
        }
        
        commandBuffer?.addCompletedHandler({ (commandBuffer) in
            
            
        })
        commandBuffer?.commit()
        
    }

}
