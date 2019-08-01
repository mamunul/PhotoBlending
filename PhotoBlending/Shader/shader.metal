//
//  shader.metal
//  PhotoBlending
//
//  Created by New User on 31/7/19.
//  Copyright © 2019 New User. All rights reserved.
//

#include "blending.h"
#include <metal_stdlib>
using namespace metal;


vertex VertexOut basic_vertex(const device VertexIn* vertices [[buffer(0)]],uint vid [[vertex_id]]){
    
    VertexOut vertexOut;
    vertexOut.vertexCoordinate = float4(vertices[vid].vertexCoordinate,1.0);
    vertexOut.textureCoordinate = vertices[vid].textureCoordinate;
    
    return vertexOut;
}

fragment float4 basic_fragment(const VertexOut vertices [[stage_in]],
                               texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                               float4 lastColor [[ color(0)]], const device float *blendMode [[ buffer(0) ]]){
    
    constexpr sampler textureSampler(coord::normalized,
                        address::repeat,
                        filter::linear);
    
    return textureBackground.sample(textureSampler,vertices.textureCoordinate);
}

fragment float4 overlay(const VertexOut vertices [[stage_in]],
                               texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                               float4 lastColor [[ color(0)]],const device float *transparency[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::repeat,
                                     filter::linear);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendOverlay( backgroundColor,  foregroundColor,  transparency[0]);
 
    return float4(blendColor,1.0);
}

fragment float4 screen(const VertexOut vertices [[stage_in]],
                        texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                        float4 lastColor [[ color(0)]],const device float *transparency[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::repeat,
                                     filter::linear);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendScreen( backgroundColor,  foregroundColor,  transparency[0]);
    
    return float4(blendColor,1.0);
}


fragment float4 softLight(const VertexOut vertices [[stage_in]],
                        texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                        float4 lastColor [[ color(0)]],const device float *transparency[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::repeat,
                                     filter::linear);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendSoftLight( backgroundColor,  foregroundColor,  transparency[0]);
    
    return float4(blendColor,1.0);
}



fragment float4 darken(const VertexOut vertices [[stage_in]],
                        texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                        float4 lastColor [[ color(0)]],const device float *transparency[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::repeat,
                                     filter::linear);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendDarken( backgroundColor,  foregroundColor,  transparency[0]);
    
    return float4(blendColor,1.0);
}
