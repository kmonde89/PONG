//
//  NString+OpenGLPrint.h
//  PONG4English
//
//  Created by Kévin Mondésir on 24/12/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import <Foundation/NSString.h>
#import <OpenGL/OpenGL.h>
#import <GLKit/GLKMath.h>
#import <OpenGL/glu.h>
#import <OpenGL/gl3.h>
#import "pongDataType.h"
@interface NSString (OpenGLPrint)

+ (void)setmoveId:(GLuint)moveId;
+ (void)setAttribPos:(GLuint)attribPos;
+ (void) setProgram:(GLuint)prog;
+ (void) setVaoID1:(GLuint) id1 andVaoID2:(GLuint) id2;
+ (void)setLetter:(quadricText *)letters;
+ (void)setNumbText:(GLuint)numbTexture;
+ (void)setTextureCoord:(GLuint)textCoord;
-(void)writeGLTextWithPosition:(CGPoint)position andSize:(CGFloat)size;
-(void)writeGLTextWithPosition:(CGPoint)position decalage:(float)decalage andSize:(CGFloat)size;
@end
