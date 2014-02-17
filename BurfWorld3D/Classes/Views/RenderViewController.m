//
//  ViewController.m
//  BurfWorld3D
//
//  Created by snrb on 28/01/2014.
//  Copyright (c) 2014 Compsoft. All rights reserved.
//

#import "RenderViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "Skybox.h"
#import "Cube.h"
#import "Plane.h"
#import "Building.h"
#import "Constant.h"

static const int PLANE_TEXTURE_SIZE = 1024; //1536

GLfloat gPlane3DVertexData[48] =
{
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,     1.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,     0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,     1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,     1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,     0.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,     0.0f, 0.0f,
};


@interface RenderViewController ()
{
    CMMotionManager* _cmMotionmanager;
    
    GLKVector3 _cameraPosition;
    GLKMatrix4 _projectionMatrix;
    GLKMatrix4 _baseModelViewMatrix;
    
    GLKMatrix4 _planeModelViewProjectionMatrixLeft;
    GLKMatrix3 _planeNormalMatrixLeft;
    GLKMatrix4 _planeModelViewProjectionMatrixRight;
    GLKMatrix3 _planeNormalMatrixRight;
    GLuint _planeProgram;
    GLuint _planeVertexArray;
    GLuint _planeVertexBuffer;
    
    GLuint _planeTextureLeft;
    GLuint _planeFrameBufferLeft; // _planeTexture is rendered-to-texture using _planeFrameBuffer
    GLuint _planeDepthBufferLeft;
    
    GLuint _planeTextureRight;
    GLuint _planeFrameBufferRight; // _planeTexture is rendered-to-texture using _planeFrameBuffer
    GLuint _planeDepthBufferRight;
    
    float _gameTime;
    float _invDeviceScale; // 1.0 for full size ipad. Smaller to zoom up elements on iPad mini.
    
}
@property (strong, nonatomic) EAGLContext *context;

@property (nonatomic, strong) Skybox *skybox;
@property (nonatomic, strong) Plane *plane;


@property (nonatomic, strong) NSMutableArray *buildings;

@property (nonatomic) int forward;
@property (nonatomic) int left;
@property (nonatomic) float rotateLeft;
@property (nonatomic) float rotateTop;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadPlaneShaders;
@end

@implementation RenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _invDeviceScale = 0.7f; // iphone 5
    
    self.duoGamer = [DuoGamer new];
    self.duoGamer.delegate = self;
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidUnload
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [super viewDidUnload];
}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    
    self.buildings = [NSMutableArray new];
    
    _cmMotionmanager = [[CMMotionManager alloc] init];
    [_cmMotionmanager startDeviceMotionUpdates];
    
    [EAGLContext setCurrentContext:self.context];
    
    [self loadPlaneShaders];
    [self setup3DView];
    
    self.skybox = [Skybox new];
    [self.skybox loadSkyboxShaders];
    [self.skybox setupWithTexture:@"0-night-skybox.png"];
    
    self.plane = [Plane new];
    [self.plane loadCubeShaders];
    [self.plane setup];
    self.plane.color = GLKVector4Make(0.2, 0.2, 0.2, 1);
    self.plane.position = GLKVector3Make(1, 0, -1.5);
    self.plane.scale = GLKVector3Make(MAP_SIZE, MAP_SIZE, 1);
    
    // Load vertex array object for plane:
    glGenVertexArraysOES(1, &_planeVertexArray);
    glBindVertexArrayOES(_planeVertexArray);
    
    glGenBuffers(1, &_planeVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _planeVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gPlane3DVertexData), gPlane3DVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));
    
    glBindVertexArrayOES(0);
    
    for (int i = 0; i < 10; i++ )
    {
        Building *building = [Building new];
        building.delegate = self;
        building.frontDoor = YES;
        building.backDoor = NO;
        building.stairMode = 1;
        building.buildingLevels = 5 ;
        
        building.ceilingColour = GLKVector4Make(240.0f / 255, 240.0f / 255, 230.0f / 255, 1);
        building.wallColour= GLKVector4Make(137.0f / 255,137.0f / 255, 137.0f / 255, 1);
        building.stairColour= GLKVector4Make(160.0f / 255, 82.0f / 255, 45.0f / 255, 1);
        building.groundColour= GLKVector4Make(205.0f / 255, 201.0f / 255, 201.0f / 255, 1);
        building.outerGroundColour= GLKVector4Make(139.0f / 255, 131.0f / 255, 120.0f / 255, 1);
        building.position = GLKVector3Make(12, i * 24 , 0);
        [building setup];
        [self.buildings addObject:building];
        
        
        building = [Building new];
        building.delegate = self;
        building.frontDoor = NO;
        building.backDoor = YES;
        building.stairMode = 0;
        building.buildingLevels = 2 ;
        
        building.ceilingColour = GLKVector4Make(240.0f / 255, 240.0f / 255, 230.0f / 255, 1);
        building.wallColour= GLKVector4Make(137.0f / 255,137.0f / 255, 137.0f / 255, 1);
        building.stairColour= GLKVector4Make(160.0f / 255, 82.0f / 255, 45.0f / 255, 1);
        building.groundColour= GLKVector4Make(205.0f / 255, 201.0f / 255, 201.0f / 255, 1);
        building.outerGroundColour= GLKVector4Make(139.0f / 255, 131.0f / 255, 120.0f / 255, 1);
        building.position = GLKVector3Make(-12 , i * 14 , 0);
        [building setup];
        
        [self.buildings addObject:building];
    }
    
    self.preferredFramesPerSecond = 60;
}

//- (void)setupEffect
//{
//    self.effect = [[GLKBaseEffect alloc] init];
//    self.effect.light0.enabled = GL_TRUE;
////    self.effect.light0.specularColor = GLKVector4Make(1, 1, 1, 1);
////    self.effect.lightModelAmbientColor = GLKVector4Make(0, 0, 0, 1);
////    self.effect.lightingType = GLKLightingTypePerPixel;
//
//    //self.effect.light0.diffuseColor = GLKVector4Make(0.4f, 0.4f, 0.4f, 1.0f);
//
//    //self.effect.light0.diffuseColor = GLKVector4Make(0, 1, 1, 1);
//    //self.effect.light0.ambientColor = GLKVector4Make(1, 1, 1, 1);
//    //self.effect.material.specularColor = GLKVector4Make(1, 1, 1, 1);
//
//    //self.effect.light0.position = GLKVector4Make(0, 1.5, -6, 1);
//
//
//    self.effect.light1.enabled = GL_TRUE;
//    self.effect.light1.diffuseColor = GLKVector4Make(1, 1, 0.8, 1);
//    self.effect.light1.position = GLKVector4Make(0, 0, 0, 1);
//
//
//    //    self.effect.fog.color = GLKVector4Make(0.3 ,0.3, 0.3, 0.8);
//    //    self.effect.fog.enabled = YES;
//    //    //self.effect.fog.density = 1.0;
//    //    self.effect.fog.start = 20;
//    //    self.effect.fog.end = 30;
//    //
//    //    self.effect.fog.mode = GLKFogModeLinear;
//}

- (void)setup3DView
{
    // we render to _planeTexture using _planeFrameBuffer
    int planeTextureWidth = PLANE_TEXTURE_SIZE;
    int planeTextureHeight = PLANE_TEXTURE_SIZE;
    
    glGenTextures(1, &_planeTextureLeft);
    glBindTexture(GL_TEXTURE_2D, _planeTextureLeft);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, planeTextureWidth, planeTextureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    GLenum err = glGetError();
    if (err != GL_NO_ERROR)
        NSLog(@"Error uploading texture. glError: 0x%04X", err);
    glGenFramebuffersOES(1, &_planeFrameBufferLeft);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _planeFrameBufferLeft);
    // attach renderbuffer
    glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, _planeTextureLeft, 0);
    
    glGenRenderbuffers(1, &_planeDepthBufferLeft);
    glBindRenderbuffer(GL_RENDERBUFFER, _planeDepthBufferLeft);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, planeTextureWidth, planeTextureHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _planeDepthBufferLeft);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"Framebuffer status: %x", (int)status);
    
    glGenTextures(1, &_planeTextureRight);
    glBindTexture(GL_TEXTURE_2D, _planeTextureRight);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, planeTextureWidth, planeTextureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    GLenum err2 = glGetError();
    if (err2 != GL_NO_ERROR)
        NSLog(@"Error uploading texture. glError: 0x%04X", err2);
    glGenFramebuffersOES(1, &_planeFrameBufferRight);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _planeFrameBufferRight);
    // attach renderbuffer
    glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, _planeTextureRight, 0);
    
    glGenRenderbuffers(1, &_planeDepthBufferRight);
    glBindRenderbuffer(GL_RENDERBUFFER, _planeDepthBufferRight);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, planeTextureWidth, planeTextureHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _planeDepthBufferRight);
    
    GLenum status2 = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status2 != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"Framebuffer status: %x", (int)status2);
    
    
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    
}

- (void)tearDownGL
{
    [_cmMotionmanager stopDeviceMotionUpdates];
    
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_planeVertexBuffer);
    glDeleteVertexArraysOES(1, &_planeVertexArray);
    glDeleteRenderbuffers(1, &_planeDepthBufferLeft);
    glDeleteFramebuffers(1, &_planeFrameBufferLeft);
    glDeleteTextures(1, &_planeTextureLeft);
    glDeleteRenderbuffers(1, &_planeDepthBufferRight);
    glDeleteFramebuffers(1, &_planeFrameBufferRight);
    glDeleteTextures(1, &_planeTextureRight);
    
    if (_planeProgram) {
        glDeleteProgram(_planeProgram);
        _planeProgram = 0;
    }
    
    [self.skybox tearDown];
    [self.plane tearDown];
    
    for (Building *building in self.buildings)
    {
        [building tearDown];
    }
    
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    
    // Plane matricies:
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 planeProjectionMatrix = GLKMatrix4MakeOrtho(-aspect*_invDeviceScale, aspect*_invDeviceScale, -_invDeviceScale, _invDeviceScale, -_invDeviceScale, _invDeviceScale);
    float planeScale = 2.0f*0.7f; // 2.0 will scale plane to vertical height of screen
    
    float planeEyeOffsetX = 4.0f*.15f; // offset from center. 1.0 would offset by vertical height of screen
    float planeEyeOffsetY = 0; //-0.05f;
    
    // Left eye:
    GLKMatrix4 planeModelViewMatrix = GLKMatrix4MakeTranslation(-planeEyeOffsetX, planeEyeOffsetY, 0.0f);
    planeModelViewMatrix = GLKMatrix4Scale(planeModelViewMatrix, planeScale, planeScale, planeScale);
    _planeNormalMatrixLeft = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(planeModelViewMatrix), NULL);
    _planeModelViewProjectionMatrixLeft = GLKMatrix4Multiply(planeProjectionMatrix, planeModelViewMatrix);
    // Right:
    planeModelViewMatrix = GLKMatrix4MakeTranslation(planeEyeOffsetX, planeEyeOffsetY, 0.0f);
    planeModelViewMatrix = GLKMatrix4Scale(planeModelViewMatrix, planeScale, planeScale, planeScale);
    _planeNormalMatrixRight = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(planeModelViewMatrix), NULL);
    _planeModelViewProjectionMatrixRight = GLKMatrix4Multiply(planeProjectionMatrix, planeModelViewMatrix);
    
    GLKMatrix4 deviceMotionAttitudeMatrix;
    if (_cmMotionmanager.deviceMotionActive) {
        CMDeviceMotion *deviceMotion = _cmMotionmanager.deviceMotion;
        
        GLKMatrix4 baseRotation = GLKMatrix4MakeRotation(M_PI_2, 0.0f , 0.0f , 1.0f );
        
        // Note: in the simulator this comes back as the zero matrix.
        // on device, this doesn't include the changes required to match screen rotation.
        CMRotationMatrix a = deviceMotion.attitude.rotationMatrix;
        deviceMotionAttitudeMatrix
        = GLKMatrix4Make(a.m11, a.m21, a.m31, 0.0f,
                         a.m12 , a.m22, a.m32, 0.0f,
                         a.m13 , a.m23 , a.m33 , 0.0f,
                         0.0f, 0.0f, 0.0f, 1.0f);
        deviceMotionAttitudeMatrix = GLKMatrix4Multiply(baseRotation, deviceMotionAttitudeMatrix);
    }
    else
    {
        // Look straight forward (we're probably in the simulator, or a device without a gyro)
        deviceMotionAttitudeMatrix = GLKMatrix4MakeRotation(-M_PI_2, 1.0f, 0.0f, 0.0f);
    }
    
    deviceMotionAttitudeMatrix = GLKMatrix4RotateZ(deviceMotionAttitudeMatrix, (self.rotateLeft / 10));
    
    //    deviceMotionAttitudeMatrix = GLKMatrix4Rotate(deviceMotionAttitudeMatrix, (self.rotateLeft / 20), 0, 0, 1);
    //
    //     deviceMotionAttitudeMatrix = GLKMatrix4Rotate(deviceMotionAttitudeMatrix, -(self.rotateTop / 20), 0, 1, 0);
    
    //    GLKMatrix4 leftRotation = GLKMatrix4MakeRotation((self.rotateLeft / 20), 0.0f, 0.0f, 1.0f);
    //    GLKMatrix4 TopRotation = GLKMatrix4MakeRotation(-(self.rotateTop / 20), 0.0f, 1.0f, 0.0f);
    //
    //    GLKMatrix4 complete = GLKMatrix4Multiply(TopRotation, leftRotation);
    //    deviceMotionAttitudeMatrix = GLKMatrix4Multiply(deviceMotionAttitudeMatrix,complete);
    
    
    //    deviceMotionAttitudeMatrix = GLKMatrix4RotateY(deviceMotionAttitudeMatrix, (self.rotateTop / 20));
    
    // Process controller input...
    const float maxSpeed = 3.0f;
    // find new camera position (based on input and camera orientation)
    GLKVector4 cameraForward4 = GLKMatrix4GetRow(deviceMotionAttitudeMatrix, 2);
    GLKVector3 cameraForward = GLKVector3Make(-cameraForward4.x, -cameraForward4.y, 0);
    GLKVector4 cameraLeft4 = GLKMatrix4GetRow(deviceMotionAttitudeMatrix, 0);
    GLKVector3 cameraLeft = GLKVector3Make(-cameraLeft4.x, -cameraLeft4.y , 0);
    
    _cameraPosition = GLKVector3Add(_cameraPosition, GLKVector3MultiplyScalar(cameraForward, maxSpeed * self.timeSinceLastUpdate * self.forward));
    _cameraPosition = GLKVector3Add(_cameraPosition, GLKVector3MultiplyScalar(cameraLeft, - maxSpeed * self.timeSinceLastUpdate * self.left));
    
    BOOL foundGround = NO;
    for (Building *building in self.buildings)
    {
        if  (_cameraPosition.y + RENDER_DISTANCE >  building.position.y && _cameraPosition.y - RENDER_DISTANCE <  building.position.y && (_cameraPosition.x + RENDER_DISTANCE >  building.position.x && _cameraPosition.x - RENDER_DISTANCE <  building.position.x))
        {
            building.cameraPosition = _cameraPosition;
            int co = [building checkCollison];
            if (co == 1)
            {
                _cameraPosition = GLKVector3Subtract(_cameraPosition, GLKVector3MultiplyScalar(cameraForward, maxSpeed * self.timeSinceLastUpdate * self.forward));
                _cameraPosition = GLKVector3Subtract(_cameraPosition, GLKVector3MultiplyScalar(cameraLeft, - maxSpeed * self.timeSinceLastUpdate * self.left));
            }
            else if (co == 2)
            {
                foundGround = YES;
            }
        }

    }
    
    // we found nothing below us
    if (_cameraPosition.z > GROUND && foundGround == NO)
    {
        float newHeight = _cameraPosition.z - 0.1;
        
        if (newHeight < GROUND)
            newHeight = GROUND;
        
        [self setPlayerHeight:newHeight];
    }

       // Sky Cube matricies:
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(115.0f), 1.0f, 0.1f, 100.0f);
    
    _baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f,0.0f,0.0f);
    _baseModelViewMatrix = GLKMatrix4Multiply(_baseModelViewMatrix, deviceMotionAttitudeMatrix);
    _baseModelViewMatrix = GLKMatrix4Translate(_baseModelViewMatrix, -_cameraPosition.x, -_cameraPosition.y, -_cameraPosition.z - HEIGHT_OFF_GROUND);
    
    const float skyboxScale = 50.0f;
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeScale(skyboxScale, skyboxScale, skyboxScale);
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, 0.0f);
    // Skybox ModelView matrix doesn't include the camera translation:
    modelViewMatrix = GLKMatrix4Multiply(deviceMotionAttitudeMatrix, modelViewMatrix);
    
    self.skybox.skyboxNormalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    self.skybox.skyboxModelViewProjectionMatrix = GLKMatrix4Multiply(_projectionMatrix, modelViewMatrix);
    
    _gameTime += self.timeSinceLastUpdate;
    
    //NSLog(@"%f %f %f", _cameraPosition.x, _cameraPosition.y,_cameraPosition.z);
    //NSLog(@"%d", self.framesPerSecond);
}

- (void)drawWorldWithEyeOffset:(float)eyeOffset
{
    glClearColor(0.35f, 0.35f, 0.85f, 1.0f); // light blue
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.skybox draw];
    
    //NSLog(@"%f %f %f", _cameraPosition.x , _cameraPosition.y, _cameraPosition.z);
    
    
    for (Building *building in self.buildings)
    {
        
        
        //NSLog(@"%f %f", building.position.y, _cameraPosition.y);
        
        if  (_cameraPosition.y + RENDER_DISTANCE >  building.position.y && _cameraPosition.y - RENDER_DISTANCE <  building.position.y && (_cameraPosition.x + RENDER_DISTANCE >  building.position.x && _cameraPosition.x - RENDER_DISTANCE <  building.position.x))
        {
            building.cameraPosition = _cameraPosition;
            building.projectionMatrix = _projectionMatrix;
            building.baseModelViewMatrix  = _baseModelViewMatrix;
            [building draw:eyeOffset];
            
            //NSLog(@"rendered");
        }
        else
        {
            //NSLog(@"Not rendered");
        }

    }
    
    
    self.plane.projectionMatrix = _projectionMatrix;
    self.plane.baseModelViewMatrix = _baseModelViewMatrix;
    [self.plane draw:eyeOffset];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    const float ipd = 0.065f; // Typical pupil distance values are 50-70mm
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _planeFrameBufferLeft);
    
    glViewport(0, 0, PLANE_TEXTURE_SIZE, PLANE_TEXTURE_SIZE);
    [self drawWorldWithEyeOffset: 0.5f*ipd];
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _planeFrameBufferRight);
    glViewport(0, 0, PLANE_TEXTURE_SIZE, PLANE_TEXTURE_SIZE);
    [self drawWorldWithEyeOffset: -0.5f*ipd];
    
    [view bindDrawable]; // glBindFramebufferOES(GL_FRAMEBUFFER_OES, ?);
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f); // gray
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Draw plane:
    glBindVertexArrayOES(_planeVertexArray);
    glUseProgram(_planeProgram);
    float width = [view drawableWidth];
    float height = [view drawableHeight];
    glEnable(GL_SCISSOR_TEST);
    
    // left eye:
    glBindTexture(GL_TEXTURE_2D, _planeTextureLeft);
    glScissor(0, 0, width/2, height);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _planeModelViewProjectionMatrixLeft.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _planeNormalMatrixLeft.m);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    // right eye:
    glBindTexture(GL_TEXTURE_2D, _planeTextureRight);
    glScissor(width/2, 0, width/2, height);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _planeModelViewProjectionMatrixRight.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _planeNormalMatrixRight.m);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    glDisable(GL_SCISSOR_TEST);
    
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadPlaneShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _planeProgram = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"PlaneShader" ofType:@"vsh"];
    if (![Object3D compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"PlaneShader" ofType:@"fsh"];
    if (![Object3D compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_planeProgram, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_planeProgram, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_planeProgram, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_planeProgram, GLKVertexAttribNormal, "normal");
    glBindAttribLocation(_planeProgram, GLKVertexAttribTexCoord0, "inputTextureCoordinate");
    
    // Link program.
    if (![Object3D linkProgram:_planeProgram]) {
        NSLog(@"Failed to link program: %d", _planeProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_planeProgram) {
            glDeleteProgram(_planeProgram);
            _planeProgram = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_planeProgram, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_planeProgram, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_planeProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_planeProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

#pragma mark - DUE

- (void)connected
{
    NSLog(@"connected");
    
    self.duoGamer = [DuoGamer new];
    self.duoGamer.delegate = self;
}

-(void) handleState:(DuoGamerState*)state
{
    //NSLog(@"%d", state->dpadLeft);
    //NSLog(@"%d %d ", state->analogRightX, state->analogRightY);
    
    self.forward = 0;
    self.left = 0;
    //    /self.rotate = 0;
    
    if  (state)
    {
        //NSLog(@"%d", state->dpadUp);
        
        self.forward = -(state->analogLeftY / 127);
        self.left = (state->analogLeftX / 127);
        
        self.rotateLeft += (state->analogRightX / 127);
        self.rotateTop += (state->analogRightY / 127);
        
    }
    
}
-(void) disconnected
{
    NSLog(@"Disconnected");
}

#pragma mark - @protocol RenderDelegate

- (float)getPlayerHeight
{
    return _cameraPosition.z;
}

- (void)setPlayerHeight:(float)height
{
    _cameraPosition.z = height;
}


@end
