//
//  Object3D.h
//  Burf3D
//
//  Created by Simon on 13/11/2013.
//  Copyright (c) 2013 Burf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};

GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface Object3D : NSObject
{
    GLuint _program;
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _texture;
    
    GLuint _colorSlot;
}

@property GLKMatrix4 projectionMatrix;
@property GLKMatrix4 baseModelViewMatrix;
@property GLKMatrix4 modelViewMatrix;
@property GLKVector3 position, rotation, scale;
@property GLKVector4 color;
@property int objectID;

- (void)tearDown;

+ (BOOL)validateProgram:(GLuint)prog;
+ (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
+ (BOOL)linkProgram:(GLuint)prog;
+ (GLuint)setupTexture:(NSString *)fileName;


- (BOOL)loadCubeShaders;
@end
