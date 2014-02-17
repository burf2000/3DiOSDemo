//
//  ViewController.h
//  BurfWorld3D
//
//  Created by snrb on 28/01/2014.
//  Copyright (c) 2014 Compsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "DuoGamerSDK.h"

@protocol RenderDelegate <NSObject>

- (float)getPlayerHeight;
- (void)setPlayerHeight:(float)height;

@end

@interface RenderViewController : GLKViewController <DuoGamerDelegate, RenderDelegate>

@property (nonatomic, strong) DuoGamer *duoGamer;

@end
