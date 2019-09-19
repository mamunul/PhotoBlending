//
//  common.h
//  PhotoBlending
//
//  Created by New User on 31/7/19.
//  Copyright © 2019 New User. All rights reserved.
//

#ifndef blending_h
#define blending_h

#include <metal_stdlib>
using namespace metal;


struct VertexIn{
    packed_float3 vertexCoordinate;//must be packed for buffer
    packed_float2 textureCoordinate;
} ;

struct VertexOut{
    float4 vertexCoordinate [[position]];
    float2 textureCoordinate;
    
};

float blendOverlay(float base, float blend);
float3 blendOverlay(float3 base, float3 blend);
float3 blendOverlay(float3 base, float3 blend, float opacity);

float3 blendNormal(float3 base, float3 blend);
float3 blendNormal(float3 base, float3 blend, float opacity);

float blendDarken(float base, float blend);
float3 blendDarken(float3 base, float3 blend);
float3 blendDarken(float3 base, float3 blend, float opacity);

float blendSoftLight(float base, float blend);
float3 blendSoftLight(float3 base, float3 blend);
float3 blendSoftLight(float3 base, float3 blend, float opacity);

float blendScreen(float base, float blend);
float3 blendScreen(float3 base, float3 blend);
float3 blendScreen(float3 base, float3 blend, float opacity);

float blendReflect(float base, float blend);
float3 blendReflect(float3 base, float3 blend);
float3 blendReflect(float3 base, float3 blend, float opacity);

float blendColorBurn(float base, float blend);
float3 blendColorBurn(float3 base, float3 blend);
float3 blendColorBurn(float3 base, float3 blend, float opacity);

float blendColorDodge(float base, float blend);
float3 blendColorDodge(float3 base, float3 blend);
float3 blendColorDodge(float3 base, float3 blend, float opacity);

float3 blendDifference(float3 base, float3 blend);
float3 blendDifference(float3 base, float3 blend, float opacity);

float3 blendExclusion(float3 base, float3 blend);
float3 blendExclusion(float3 base, float3 blend, float opacity);

float3 blendGlow(float3 base, float3 blend);
float3 blendGlow(float3 base, float3 blend, float opacity);

float3 blendHardLight(float3 base, float3 blend);
float3 blendHardLight(float3 base, float3 blend, float opacity);

float blendLighten(float base, float blend);
float3 blendLighten(float3 base, float3 blend);
float3 blendLighten(float3 base, float3 blend, float opacity);

float blendLinearBurn(float base, float blend);
float3 blendLinearBurn(float3 base, float3 blend);
float3 blendLinearBurn(float3 base, float3 blend, float opacity);

float blendLinearDodge(float base, float blend);
float3 blendLinearDodge(float3 base, float3 blend);
float3 blendLinearDodge(float3 base, float3 blend, float opacity);

float blendLinearLight(float base, float blend);
float3 blendLinearLight(float3 base, float3 blend);
float3 blendLinearLight(float3 base, float3 blend, float opacity);

float3 blendNegation(float3 base, float3 blend);
float3 blendNegation(float3 base, float3 blend, float opacity);

float3 blendPhoenix(float3 base, float3 blend);
float3 blendPhoenix(float3 base, float3 blend, float opacity);

float blendPinLight(float base, float blend);
float3 blendPinLight(float3 base, float3 blend);
float3 blendPinLight(float3 base, float3 blend, float opacity);

float blendVividLight(float base, float blend);
float3 blendVividLight(float3 base, float3 blend);
float3 blendVividLight(float3 base, float3 blend, float opacity);

float blendHardMix(float base, float blend);
float3 blendHardMix(float3 base, float3 blend);
float3 blendHardMix(float3 base, float3 blend, float opacity);

float blendSubstract(float base, float blend);
float3 blendSubstract(float3 base, float3 blend);
float3 blendSubstract(float3 base, float3 blend, float opacity);

float blendSubtract(float base, float blend);
float3 blendSubtract(float3 base, float3 blend);
float3 blendSubtract(float3 base, float3 blend, float opacity);

#endif /* blending_h */
