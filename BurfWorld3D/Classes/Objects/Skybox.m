//
//  Skybox.m
//  BurfWorld3D
//
//  Created by snrb on 28/01/2014.
//  Copyright (c) 2014 Compsoft. All rights reserved.
//

#import "Skybox.h"

@implementation Skybox

GLfloat gCubeMapVertexData[288] =
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,
    //                     normalX, normalY, normalZ,
    //                                                 U,   V,
    -1.000000f, -1.000000f, 1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.000108f, 0.250021f,
    -1.000000f, -1.000000f, -1.000000f,  1.000000f, 1.000000f, 1.000000f, 0.000108f, 0.499978f,
    -1.000000f, 1.000000f, -1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.250064f, 0.499978f,
    
    -1.000000f, 1.000000f, 1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.250064f, 0.250022f,
    -1.000000f, 1.000000f, -1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.250064f, 0.499978f,
    1.000000f, 1.000000f, -1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.500020f, 0.499978f,
    
    1.000000f, 1.000000f, 1.000000f,     1.000000f, 1.000000f, 1.000000f, 0.500021f, 0.250022f,
    1.000000f, 1.000000f, -1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.500020f, 0.499978f,
    1.000000f, -1.000000f, -1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.749977f, 0.499979f,
    
    1.000000f, -1.000000f, -1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.749977f, 0.499979f,
    -1.000000f, -1.000000f, -1.000000f,  1.000000f, 1.000000f, 1.000000f, 0.999935f, 0.499979f,
    1.000000f, -1.000000f, 1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.749977f, 0.250022f,
    
    -1.000000f, -1.000000f, -1.000000f,  1.000000f, 1.000000f, 1.000000f, 0.250063f, 0.749934f,
    1.000000f, -1.000000f, -1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.500019f, 0.749935f,
    1.000000f, 1.000000f, -1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.500020f, 0.499978f,
    
    1.000000f, -1.000000f, 1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.500021f, 0.000066f,
    -1.000000f, -1.000000f, 1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.250065f, 0.000065f,
    -1.000000f, 1.000000f, 1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.250064f, 0.250022f,
    
    -1.000000f, 1.000000f, 1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.250064f, 0.250022f,
    -1.000000f, -1.000000f, 1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.000108f, 0.250021f,
    -1.000000f, 1.000000f, -1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.250064f, 0.499978f,
    
    1.000000f, 1.000000f, 1.000000f,     1.000000f, 1.000000f, 1.000000f, 0.500021f, 0.250022f,
    -1.000000f, 1.000000f, 1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.250064f, 0.250022f,
    1.000000f, 1.000000f, -1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.500020f, 0.499978f,
    
    1.000000f, -1.000000f, 1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.749977f, 0.250022f,
    1.000000f, 1.000000f, 1.000000f,     1.000000f, 1.000000f, 1.000000f, 0.500021f, 0.250022f,
    1.000000f, -1.000000f, -1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.749977f, 0.499979f,
    
    1.000000f, -1.000000f, 1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.749977f, 0.250022f,
    -1.000000f, -1.000000f, -1.000000f,  1.000000f, 1.000000f, 1.000000f, 0.999935f, 0.499979f,
    -1.000000f, -1.000000f, 1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.999935f, 0.250022f,
    
    -1.000000f, 1.000000f, -1.000000f,   1.000000f, 1.000000f, 1.000000f, 0.250064f, 0.499978f,
    -1.000000f, -1.000000f, -1.000000f,  1.000000f, 1.000000f, 1.000000f, 0.250063f, 0.749934f,
    1.000000f, 1.000000f, -1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.500020f, 0.499978f,
    
    1.000000f, 1.000000f, 1.000000f,     1.000000f, 1.000000f, 1.000000f, 0.500021f, 0.250022f,
    1.000000f, -1.000000f, 1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.500021f, 0.000066f,
    -1.000000f, 1.000000f, 1.000000f,    1.000000f, 1.000000f, 1.000000f, 0.250064f, 0.250022f
};

- (void)setupWithTexture:(NSString *)texture
{
    // Load vertex array object for skybox:
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeMapVertexData), gCubeMapVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));
    
    glBindVertexArrayOES(0);

    _texture = [Object3D setupTexture:texture];
}

- (BOOL)loadSkyboxShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"SkyboxShader" ofType:@"vsh"];
    if (![Object3D compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"SkyboxShader" ofType:@"fsh"];
    if (![Object3D compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribColor, "color");
    // TODO: specify uniform color for "color" instead of using vertex data
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "textureCoordinate");
    
    // Link program.
    if (![Object3D linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (void)draw
{
    // Draw skybox:
    glBindTexture(GL_TEXTURE_2D, _texture);
    glBindVertexArrayOES(_vertexArray);
    glUseProgram(_program);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _skyboxModelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _skyboxNormalMatrix.m);
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

- (void)tearDown
{
    [super tearDown];
    
    glDeleteTextures(1, &_texture);
}

@end
