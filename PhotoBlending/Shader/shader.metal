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
                               float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,(vertices.textureCoordinate + moveBackground) * zoomBackground).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,(vertices.textureCoordinate + moveForeground) * zoomForeground).rgb;
    
    
    float3 blendColor = blendOverlay( backgroundColor,  foregroundColor,  transparency);
 
    return float4(blendColor,1.0);
}

float2x3 getTexture(float2 textureCoordinate,const device float *extraData,texture2d<float>  textureBackground, texture2d<float>  texureForeground ){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,(textureCoordinate + moveBackground) * zoomBackground).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,(textureCoordinate + moveForeground) * zoomForeground).rgb;
    
    return float2x3(backgroundColor,foregroundColor);
    
}

fragment float4 screen(const VertexOut vertices [[stage_in]],
                        texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                        float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float2x3 result = getTexture(vertices.textureCoordinate,extraData,textureBackground,texureForeground);

    float3 backgroundColor = result[0];// textureBackground.sample(textureSampler,(vertices.textureCoordinate + moveBackground) * zoomBackground).rgb;
    float3 foregroundColor = result[1];// texureForeground.sample(textureSampler,(vertices.textureCoordinate + moveForeground) * zoomForeground).rgb;
    
    

    
    float3 blendColor = blendScreen( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}


fragment float4 softLight(const VertexOut vertices [[stage_in]],
                        texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                        float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendSoftLight( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}



fragment float4 darken(const VertexOut vertices [[stage_in]],
                        texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                        float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendDarken( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 reflect(const VertexOut vertices [[stage_in]],
 texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
 float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendReflect( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 colorBurn(const VertexOut vertices [[stage_in]],
                 texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                 float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendColorBurn( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 colorDodge(const VertexOut vertices [[stage_in]],
                 texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                 float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendColorDodge( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 difference(const VertexOut vertices [[stage_in]],
                  texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                  float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendDifference( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 exclusion(const VertexOut vertices [[stage_in]],
                  texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                  float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendExclusion( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 glow(const VertexOut vertices [[stage_in]],
                 texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                 float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendGlow( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 hardLight(const VertexOut vertices [[stage_in]],
            texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
            float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendHardLight( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 lighten(const VertexOut vertices [[stage_in]],
                 texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                 float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendLighten( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 linearBurn(const VertexOut vertices [[stage_in]],
               texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
               float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendLinearBurn( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 linearDodge(const VertexOut vertices [[stage_in]],
                  texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                  float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendLinearDodge( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 linearLight(const VertexOut vertices [[stage_in]],
                   texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                   float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendLinearLight( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 negation(const VertexOut vertices [[stage_in]],
                   texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                   float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendNegation( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 phoenix(const VertexOut vertices [[stage_in]],
                texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendPhoenix( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 pinLight(const VertexOut vertices [[stage_in]],
               texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
               float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendPinLight( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 vividLight(const VertexOut vertices [[stage_in]],
                texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendVividLight( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 hardMix(const VertexOut vertices [[stage_in]],
                  texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                  float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendHardMix( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 substract(const VertexOut vertices [[stage_in]],
               texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
               float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendSubstract( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}

fragment float4 subtract(const VertexOut vertices [[stage_in]],
                 texture2d<float>  textureBackground     [[ texture(0) ]], texture2d<float>  texureForeground     [[ texture(1) ]],
                 float4 lastColor [[ color(0)]],const device float *extraData[[buffer(0)]]){
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_zero,
                                     filter::linear);
    
    float transparency = extraData[0];
    float zoomBackground = extraData[1];
    float zoomForeground = extraData[2];
    float2 moveBackground = float2(extraData[3],extraData[4]);
    float2 moveForeground = float2(extraData[5],extraData[6]);
    
    float3 backgroundColor = textureBackground.sample(textureSampler,vertices.textureCoordinate).rgb;
    float3 foregroundColor = texureForeground.sample(textureSampler,vertices.textureCoordinate).rgb;
    
    float3 blendColor = blendSubtract( backgroundColor,  foregroundColor,  transparency);
    
    return float4(blendColor,1.0);
}
