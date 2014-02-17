//
//  Plane.m
//  BurfWorld3D
//
//  Created by snrb on 29/01/2014.
//  Copyright (c) 2014 Compsoft. All rights reserved.
//

#import "Plane.h"

@implementation Plane

GLfloat gPlaneVertexData[36] =
{
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
};

- (void)setup;
{
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gPlaneVertexData), gPlaneVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    
    //glEnableVertexAttribArray(GLKVertexAttribColor);
    //glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    
//    glEnableVertexAttribArray(GLKVertexAttribColor);
//    glVertexAttribPointer(GLKVertexAttribColor
    //glEnableVertexAttribArray(GLKVertexAttribColor);

    
    glBindVertexArrayOES(0);
    
}

- (void)draw:(float)eyeOffset
{
    // Calculate the per-eye model view matrix:
    GLKMatrix4 temp = GLKMatrix4MakeTranslation(eyeOffset, 0.0f, 0.0f);
    GLKMatrix4 eyeBaseModelViewMatrix = GLKMatrix4Multiply(temp, self.baseModelViewMatrix);
    
    if (_texture)
    {
        glBindTexture(GL_TEXTURE_2D, _texture);
    }
    
    glBindVertexArrayOES(_vertexArray);
    
    glUseProgram(_program);
    
    self.modelViewMatrix = GLKMatrix4MakeTranslation(self.position.x,self.position.y, self.position.z );//(float)x, (float)y, -1.5f)
    self.modelViewMatrix = GLKMatrix4Scale(self.modelViewMatrix, self.scale.x, self.scale.y, self.scale.z);
    self.modelViewMatrix = GLKMatrix4Multiply(eyeBaseModelViewMatrix, self.modelViewMatrix);
    
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(self.modelViewMatrix), NULL);
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(self.projectionMatrix, self.modelViewMatrix);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);
    
    _colorSlot = glGetUniformLocation(_program, "color");
    GLfloat color[] = {
        self.color.x, self.color.y, self.color.z, 1.0f};
    glUniform4fv(_colorSlot, 1, color);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
}
- (void)tearDown
{
    [super tearDown];
}


@end
