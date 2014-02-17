//
//  Shader.fsh
//  shitOP
//
//  Created by snrb on 28/01/2014.
//  Copyright (c) 2014 Compsoft. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
