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

#endif /* blending_h */
