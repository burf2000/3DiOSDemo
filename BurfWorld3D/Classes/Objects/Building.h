//
//  Building.h
//  BurfWorld3D
//
//  Created by Simon on 02/02/2014.
//  Copyright (c) 2014 Compsoft. All rights reserved.
//

#import "Object3D.h"
#import "RenderViewController.h"

@interface Building : Object3D

@property (nonatomic, strong) NSMutableArray *cubes;
@property (nonatomic) GLKVector3 cameraPosition;
@property (nonatomic, assign) id <RenderDelegate> delegate;

@property (nonatomic) int buildingLevels;

@property (nonatomic) BOOL frontDoor;
@property (nonatomic) BOOL backDoor;

@property (nonatomic) int stairMode;

@property (nonatomic) GLKVector4 groundColour;
@property (nonatomic) GLKVector4 wallColour;
@property (nonatomic) GLKVector4 stairColour;
@property (nonatomic) GLKVector4 ceilingColour;
@property (nonatomic) GLKVector4 outerGroundColour;

@property (nonatomic) BOOL inBuilding;

- (void)setup;
- (void)draw:(float)eyeOffset;
- (void)tearDown;
- (int)checkCollison;


@end
