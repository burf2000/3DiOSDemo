//
//  Skybox.h
//  BurfWorld3D
//
//  Created by snrb on 28/01/2014.
//  Copyright (c) 2014 Compsoft. All rights reserved.
//

#import "Object3D.h"

@interface Skybox : Object3D
{
}

@property (nonatomic, assign) GLKMatrix4 skyboxModelViewProjectionMatrix;
@property (nonatomic, assign) GLKMatrix3 skyboxNormalMatrix;

- (void)draw;
- (void)setupWithTexture:(NSString *)texture;
- (BOOL)loadSkyboxShaders;
- (void)tearDown;

@end
