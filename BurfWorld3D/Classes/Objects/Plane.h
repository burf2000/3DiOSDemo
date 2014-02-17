//
//  Plane.h
//  BurfWorld3D
//
//  Created by snrb on 29/01/2014.
//  Copyright (c) 2014 Compsoft. All rights reserved.
//

#import "Object3D.h"

@interface Plane : Object3D
{
}

- (void)setup;
- (void)draw:(float)eyeOffset;
- (void)tearDown;

@end
