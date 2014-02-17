//
//  Shader.vsh
//  shitOP
//
//  Created by snrb on 28/01/2014.
//  Copyright (c) 2014 Compsoft. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
uniform vec4 color;

varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    //vec4 diffuseColor = color;
    
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    //diffuseColor = vec4(0.4, 0.4, 1.0, 1.0);
    
    float nDotVP = max(0.7, dot(eyeNormal, normalize(lightPosition))); // 0.0
                 
    colorVarying = color * nDotVP;
    
    gl_Position = modelViewProjectionMatrix * position;
}
