//
//  Building.m
//  BurfWorld3D
//
//  Created by Simon on 02/02/2014.
//  Copyright (c) 2014 Compsoft. All rights reserved.
//

#import "Building.h"
#import "Cube.h"

@implementation Building

- (void)setup
{
    self.cubes = [NSMutableArray new];
    
    float x = self.position.x;
    float y = self.position.y;
    float z = self.position.z + 1.75;
    
    float wallHeight = 5;
    float wallLength = 12;
    float wallThickness = 0.2;
    
    float doorWidth = 1.2;
    float doorHeight = 1;
    
    float stairWidth = 2.0;
    float stairHeight = 0.5;
    float stairDepth = 0.5;
    
    
    // left wall
    Cube *cube = [Cube new];
    [cube loadCubeShaders];
    [cube setup];
    cube.position = GLKVector3Make(x , y + (wallLength / 2) , z + ((wallHeight / 2) * (self.buildingLevels - 1)));
    cube.scale = GLKVector3Make(wallLength + wallThickness, wallThickness, wallHeight * self.buildingLevels);
    cube.color = self.wallColour;
    cube.objectID  = 1;
    [self.cubes addObject:cube];
    
    // right wall
    cube = [Cube new];
    [cube loadCubeShaders];
    [cube setup];
    cube.position = GLKVector3Make(x  ,y -( wallLength / 2) , z + ((wallHeight / 2) * (self.buildingLevels - 1)));
    cube.scale = GLKVector3Make(wallLength + wallThickness, wallThickness, wallHeight * self.buildingLevels);
    cube.color = self.wallColour;
    cube.objectID  = 2;
    [self.cubes addObject:cube];
    
    
    //  outerfloor
    cube = [Cube new];
    [cube loadCubeShaders];
    [cube setup];
    cube.position = GLKVector3Make(x  ,y , - 1);
    cube.scale = GLKVector3Make(wallLength + 5, wallLength + 5 , wallThickness);
    cube.color = self.outerGroundColour;
    cube.objectID  = 7;
    [self.cubes addObject:cube];
    
    if (self.backDoor)
    {
        // back wall
        cube = [Cube new];
        [cube loadCubeShaders];
        [cube setup];
        cube.position = GLKVector3Make(x + (wallLength / 2) ,y , z + doorHeight + ((wallHeight / 2) * (self.buildingLevels - 1)));
        cube.scale = GLKVector3Make(wallThickness, wallLength, (wallHeight * self.buildingLevels) - (doorHeight *2) );
        cube.color = self.wallColour;
        cube.objectID  = 3;
        [self.cubes addObject:cube];
        
        // back door
        cube = [Cube new];
        [cube loadCubeShaders];
        [cube setup];
        cube.position = GLKVector3Make(x + (wallLength / 2) ,y - ((wallLength / 4) + (doorWidth /2)) , z + ((wallHeight / 2) * (self.buildingLevels - 1)));
        cube.scale = GLKVector3Make(wallThickness, (wallLength / 2 - doorWidth), wallHeight * self.buildingLevels);
        cube.color = self.wallColour;
        cube.objectID  = 4;
        [self.cubes addObject:cube];
        
        // back door
        cube = [Cube new];
        [cube loadCubeShaders];
        [cube setup];
        cube.position = GLKVector3Make(x + (wallLength / 2) ,y + ((wallLength / 4) + (doorWidth /2)) , z + ((wallHeight / 2) * (self.buildingLevels - 1)));
        cube.scale = GLKVector3Make(wallThickness, (wallLength / 2 - doorWidth), wallHeight * self.buildingLevels);
        cube.color = self.wallColour;
        cube.objectID  = 5;
        [self.cubes addObject:cube];
    }
    else
    {
        // full back wall
        cube = [Cube new];
        [cube loadCubeShaders];
        [cube setup];
        cube.position = GLKVector3Make(x + (wallLength / 2) ,y , z + ((wallHeight / 2) * (self.buildingLevels - 1)));
        cube.scale = GLKVector3Make(wallThickness, wallLength, wallHeight * self.buildingLevels);
        cube.color = self.wallColour;
        cube.objectID  = 6;
        [self.cubes addObject:cube];
    }
    
    if (self.frontDoor)
    {
        // front wall
        cube = [Cube new];
        [cube loadCubeShaders];
        [cube setup];
        cube.position = GLKVector3Make(x - (wallLength / 2) ,y , z + doorHeight + ((wallHeight / 2) * (self.buildingLevels - 1)));
        cube.scale = GLKVector3Make(wallThickness, wallLength,  (wallHeight * self.buildingLevels) - (doorHeight *2));
        cube.color = self.wallColour;
        cube.objectID  = 3;
        [self.cubes addObject:cube];
        
        // front door
        cube = [Cube new];
        [cube loadCubeShaders];
        [cube setup];
        cube.position = GLKVector3Make(x - (wallLength / 2) ,y - ((wallLength / 4) + (doorWidth /2)) , z + ((wallHeight / 2) * (self.buildingLevels - 1)));
        cube.scale = GLKVector3Make(wallThickness, (wallLength / 2 - doorWidth), wallHeight * self.buildingLevels);
        cube.color = self.wallColour;
        cube.objectID  = 4;
        [self.cubes addObject:cube];
        
        // front door
        cube = [Cube new];
        [cube loadCubeShaders];
        [cube setup];
        cube.position = GLKVector3Make(x - (wallLength / 2) ,y + ((wallLength / 4) + (doorWidth /2)) , z + ((wallHeight / 2) * (self.buildingLevels - 1)));
        cube.scale = GLKVector3Make(wallThickness, (wallLength / 2 - doorWidth), wallHeight * self.buildingLevels);
        cube.color = self.wallColour;
        cube.objectID  = 5;
        [self.cubes addObject:cube];
    }
    else
    {
        // full front wall
        cube = [Cube new];
        [cube loadCubeShaders];
        [cube setup];
        cube.position = GLKVector3Make(x - (wallLength / 2) ,y , z + ((wallHeight / 2) * (self.buildingLevels - 1)));
        cube.scale = GLKVector3Make(wallThickness, wallLength, wallHeight * self.buildingLevels);
        cube.color = self.wallColour;
        cube.objectID  = 6;
        [self.cubes addObject:cube];
    }
    
    //  floor
    cube = [Cube new];
    [cube loadCubeShaders];
    [cube setup];
    cube.position = GLKVector3Make(x  ,y , - 0.60);
    cube.scale = GLKVector3Make(wallLength - wallThickness, wallLength - wallThickness , wallThickness);
    cube.color = self.groundColour;
    cube.objectID  = 7;
    [self.cubes addObject:cube];
    
    // top roof
    cube = [Cube new];
    [cube loadCubeShaders];
    [cube setup];
    cube.position = GLKVector3Make(x  ,y , z + (wallHeight * self.buildingLevels) - 2.5);
    cube.scale = GLKVector3Make(wallLength - wallThickness, wallLength - wallThickness , wallThickness);
    cube.color = self.ceilingColour;
    cube.objectID  = 8;
    [self.cubes addObject:cube];
    
    for (int ii = 0 ; ii < self.buildingLevels -1 ; ii ++)
    {
        if (self.stairMode == 0)
        {
            
            self.stairMode = 1;
            
            // roof
            cube = [Cube new];
            [cube loadCubeShaders];
            [cube setup];
            cube.position = GLKVector3Make(x + ((stairWidth / 2)    ) ,y , (z + (wallHeight * ii) + wallHeight) - ((wallThickness / 2) + 2.5 ));
            cube.scale = GLKVector3Make(wallLength - (stairWidth + wallThickness) , wallLength - wallThickness, wallThickness);
            cube.color = self.ceilingColour;
            cube.objectID  = 9;
            [self.cubes addObject:cube];
            
            // Stairs
            
            // Top step
            
            cube = [Cube new];
            [cube loadCubeShaders];
            [cube setup];
            cube.position = GLKVector3Make(x - (wallLength / 2) + (stairWidth / 2) + (wallThickness / 2), y - (wallLength / 2) + (stairDepth + (wallThickness/2)) , (z + wallThickness + 0.05) + (wallHeight * ii) - (stairHeight / 2) );
            cube.scale = GLKVector3Make(stairWidth , stairDepth * 2,  wallHeight + stairHeight - stairHeight);
            cube.color = self.stairColour;
            cube.objectID  = 10;
            [self.cubes addObject:cube];
            
            int starCount = wallHeight / stairHeight +1;
            
            for (int i = 1; i < starCount ; i ++)
            {
                cube = [Cube new];
                [cube loadCubeShaders];
                [cube setup];
                cube.position = GLKVector3Make(x - (wallLength / 2) + (stairWidth / 2) + (wallThickness / 2), y - (wallLength / 2) + (i * stairDepth) + (stairDepth + wallThickness) , (z + wallThickness + 0.05) + (wallHeight * ii) - (i * (stairHeight / 2)) );
                cube.scale = GLKVector3Make(stairWidth , stairDepth * 2,  wallHeight + stairHeight - (i * stairHeight) );
                cube.color = self.stairColour;
                cube.objectID  = 10 +i;
                NSLog(@"%d",  cube.objectID );
                [self.cubes addObject:cube];
                
            }
        }
        else
        {
             self.stairMode = 0;
            
            // roof
            cube = [Cube new];
            [cube loadCubeShaders];
            [cube setup];
            cube.position = GLKVector3Make(x - ((stairWidth / 2)    ) ,y , (z + (wallHeight * ii) + wallHeight) - ((wallThickness / 2) + 2.5   ));
            cube.scale = GLKVector3Make(wallLength - (stairWidth + wallThickness) , wallLength - wallThickness, wallThickness);
            cube.color = self.ceilingColour;
            cube.objectID  = 9;
            [self.cubes addObject:cube];
            
            // Stairs
            
            // Top step
            cube = [Cube new];
            [cube loadCubeShaders];
            [cube setup];
            cube.position = GLKVector3Make(x + (wallLength / 2) - (stairWidth / 2) - (wallThickness / 2), y - (wallLength / 2) + (stairDepth + (wallThickness/2)) , (z + wallThickness + 0.05) + (wallHeight * ii) - (stairHeight / 2) );
            cube.scale = GLKVector3Make(stairWidth , stairDepth * 2,  wallHeight + stairHeight - stairHeight);
            cube.color = self.stairColour;
            cube.objectID  = 10;
            [self.cubes addObject:cube];
            
            int starCount = wallHeight / stairHeight +1;
            
            for (int i = 1; i < starCount ; i ++)
            {
                cube = [Cube new];
                [cube loadCubeShaders];
                [cube setup];
                cube.position = GLKVector3Make(x + (wallLength / 2) - (stairWidth / 2) - (wallThickness / 2), y - (wallLength / 2) + (i * stairDepth) + (stairDepth + wallThickness) , (z + wallThickness + 0.05) + (wallHeight * ii) - (i * (stairHeight / 2)) );
                cube.scale = GLKVector3Make(stairWidth , stairDepth * 2,  wallHeight + stairHeight - (i * stairHeight) );
                cube.color = self.stairColour;
                cube.objectID  = 10 +i;
                NSLog(@"%d",  cube.objectID );
                [self.cubes addObject:cube];
                
            }
        }
    }
}

- (void)draw:(float)eyeOffset
{
    for (Cube *cube in self.cubes)
    {
        if ((self.cameraPosition.x > cube.position.x - RENDER_DISTANCE) &&
            (self.cameraPosition.x < cube.position.x + RENDER_DISTANCE) &&
            (self.cameraPosition.y > cube.position.y - RENDER_DISTANCE) &&
            (self.cameraPosition.y < cube.position.y + RENDER_DISTANCE) )
        {
            
            // only render stairs if in building
            if (!self.inBuilding && cube.objectID > 8)
            {
                break;
            }
            
            cube.projectionMatrix = self.projectionMatrix;
            cube.baseModelViewMatrix = self.baseModelViewMatrix;
            [cube draw:eyeOffset];
            
        }
        
    }
}

- (int)checkCollison
{
    float buffer = 0.2;
    BOOL groundObjectFound = false;
    float currentGroundHeight = GROUND;
    
    //NSLog(@"%f, %f", self.cameraPosition.x, self.cameraPosition.y)
    for (Cube *cube in self.cubes)
    {
        if (self.cameraPosition.x + buffer > cube.position.x - (cube.scale.x /2) &&
            self.cameraPosition.x - buffer < cube.position.x + (cube.scale.x /2) &&
            self.cameraPosition.y + buffer > cube.position.y - (cube.scale.y /2) &&
            self.cameraPosition.y - buffer < cube.position.y + (cube.scale.y /2))
        {
            
            //NSLog(@"%f %f %f" ,_cameraPosition.z + 2.5,  cube.position.z, cube.position.z + (cube.scale.z/2));
            if (cube.position.z + (cube.scale.z/2) >_cameraPosition.z + 2.5 &&  cube.position.z - (cube.scale.z/2) < _cameraPosition.z)
            {
                self.inBuilding = YES;
                return 1;
            }
            else
            {
                 //NSLog(@"X %f Y %f %f %d",  _cameraPosition.z , cube.position.z, cube.position.z + cube.scale.z, cube.objectID);
                 //NSLog(@"%f %f", _cameraPosition.z , cube.position.z + (cube.scale.z /2) + 0.2);
                if (_cameraPosition.z <= (cube.position.z + cube.scale.z + 0.1))
                {
                    // go up
                    
                    //NSLog(@"%f %f", _cameraPosition.z , cube.position.z + (cube.scale.z /2) + 0.2);
                    if ( ((cube.position.z + (cube.scale.z /2)) - _cameraPosition.z) < 1)
                    {
                        
                        if (currentGroundHeight < cube.position.z + (cube.scale.z /2) + 0.1)
                        {
                            currentGroundHeight = cube.position.z + (cube.scale.z /2) + 0.1;
                        }
                        
                         [self.delegate setPlayerHeight:currentGroundHeight];
                        _cameraPosition.z = currentGroundHeight;
                        
                        groundObjectFound = YES;
                        
                    }
                    
                }
                else if (_cameraPosition.z == (cube.position.z + (cube.scale.z /2) + 0.1))
                {
                    //NSLog(@"%f %f", cube.scale.z, cube.position.z);
                    self.inBuilding = YES;
                    return 2;
                }
                
                //NSLog(@"%f %f", _cameraPosition.z, cube.position.z + (cube.scale.z /2) + 0.1);
            }
        }
        
    }
    
    if (groundObjectFound)
    {
         self.inBuilding = YES;
         return 2;
    }
    
     // not hit anything
    self.inBuilding = NO;
    return 0;
}


- (void)tearDown
{
    self.cubes = nil;
}


@end
