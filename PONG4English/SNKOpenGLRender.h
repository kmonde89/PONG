//
//  SNKOpenGLRender.h
//  PONG4English
//
//  Created by Kévin Mondésir on 01/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

///#import <Foundation/Foundation.h>

#import <OpenGL/OpenGL.h>
#import <OpenGL/gl3.h>
#import <OpenGL/glext.h>
#import <OpenGL/glu.h>
#import <GLKit/GLKMath.h>
#include <stdint.h>
#include <stdio.h>
#import "pongDataType.h"
#import "SNKracket.h"
#import "NString+OpenGLPrint.h"
@protocol PongRendererDelegate
-(void)inGame;

-(void)pause;
-(void)startScreen;
@optional
-(void)didLoose;
@end




#ifndef pasdesa
const uint32_t kShaderCount = 6;//le nombre de fragment shader et vertex shader
const uint32_t kProgramCount = 3;// le nombre de programs
const uint32_t VBOCount=1;
#endif
@interface SNKOpenGLRender : NSObject
{
	
	GLsizei width, height;
	
	NSRecursiveLock * lock;
	GLint shaders[8];
	GLint programs[4];
	//attributes
	//GLint attribPosition, attribColor, attribNormal , attribColorChange;
	// uniforms
	//GLuint position;
	GLint attribPosition, attribColor, attribNormal, attribScale, attribOrientationMatrix0, attribOrientationMatrix1, attribOrientationMatrix2, attribOrientationMatrix3,
	lightPosLocation, lightColorLocation;
	GLint attribPosition2, attribColor2, attribNormal2,
	lightPosLocation2, lightColorLocation2;
	GLint attribPosition4,colorSet;
	// uniforms
	GLuint rotationAnimationMatrixLocation, cameraTransformLocation, projectionMatrixLocation;
	GLuint rotationAnimationMatrixLocation2, cameraTransformLocation2, projectionMatrixLocation2;
	GLuint moveIT,moveIT2;
	GLuint attribPosition3,TextCoord,moveIT3,cameraTransformLocation3,projectionMatrixLocation3,TextColor;
	
	GLuint cameraTransformLocation4,projectionMatrixLocation4;
	// buffer objects
	GLuint scaleBufferID,orientationMatID;
	GLuint scaleBufferID2,orientationMatID2;
	GLuint gearVAOId[5];
	GLuint numberTest;
	quadric* racket;
	quadric* ball;
	quadricText * letter;
	quadricText * uno;
	defaultStruct * pauseM;
	GLKMatrix4 cameraMatrix;
	GLKVector4 lightPos, lightColor;
	int numGears;
	int score;
	float animationDelta;
	uint32_t kAnimationLoopValue, animationStep;
	BOOL animate;
	float xAxisAngle, zAxisAngle;
	float yposition;
	CGPoint positionBall;
	float xvitesse,yvitesse;
	BOOL mooveRacket;
	float yRacketSpeed;
	NSMutableArray * Balls;
	NSMutableArray * removeBalls;
	SNKracket * Myracket;
	int createABall;
	NSSound *sound;
	//text
	GLuint base;    // Base display list for the font set
	BOOL emitedSound;
	NSTimeInterval currentTime;
	GLuint texture[3];
	GLuint texture2D;
	GLuint textureID;
	GLuint textureText;
}
@property (assign) id <PongRendererDelegate> delegate;
-(void)click:(CGPoint)point;

- (BOOL)setupGL;
- (void)reshapeToWidth:(GLsizei)w height:(GLsizei)h;
- (void)draw;
- (void)toggleAnimation;
- (void)up;
- (void)down;
- (void)endUp;
- (void)endDown;
-(void)addBall;
@end
