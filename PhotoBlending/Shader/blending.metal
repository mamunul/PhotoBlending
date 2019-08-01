//
//  common.metal
//  PhotoBlending
//
//  Created by New User on 31/7/19.
//  Copyright © 2019 New User. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include "blending.h"

float blendOverlay(float base, float blend) {
    return base<0.5?(2.0*base*blend):(1.0-2.0*(1.0-base)*(1.0-blend));
}

float3 blendOverlay(float3 base, float3 blend) {
    return float3(blendOverlay(base.r,blend.r),blendOverlay(base.g,blend.g),blendOverlay(base.b,blend.b));
}

float3 blendOverlay(float3 base, float3 blend, float opacity) {
    
    return (blendOverlay(base, blend) * opacity + base * (1.0 - opacity));
}

float3 blendNormal(float3 base, float3 blend) {
    return blend;
}

float3 blendNormal(float3 base, float3 blend, float opacity) {
    return (blendNormal(base, blend) * opacity + base * (1.0 - opacity));
}


float blendDarken(float base, float blend) {
    return min(blend,base);
}

float3 blendDarken(float3 base, float3 blend) {
    return float3(blendDarken(base.r,blend.r),blendDarken(base.g,blend.g),blendDarken(base.b,blend.b));
}

float3 blendDarken(float3 base, float3 blend, float opacity) {
    return (blendDarken(base, blend) * opacity + base * (1.0 - opacity));
}

float blendSoftLight(float base, float blend) {
    return (blend<0.5)?(2.0*base*blend+base*base*(1.0-2.0*blend)):(sqrt(base)*(2.0*blend-1.0)+2.0*base*(1.0-blend));
}

float3 blendSoftLight(float3 base, float3 blend) {
    return float3(blendSoftLight(base.r,blend.r),blendSoftLight(base.g,blend.g),blendSoftLight(base.b,blend.b));
}

float3 blendSoftLight(float3 base, float3 blend, float opacity) {
    return (blendSoftLight(base, blend) * opacity + base * (1.0 - opacity));
}

float blendScreen(float base, float blend) {
    return 1.0-((1.0-base)*(1.0-blend));
}

float3 blendScreen(float3 base, float3 blend) {
    return float3(blendScreen(base.r,blend.r),blendScreen(base.g,blend.g),blendScreen(base.b,blend.b));
}

float3 blendScreen(float3 base, float3 blend, float opacity) {
    return (blendScreen(base, blend) * opacity + base * (1.0 - opacity));
}
