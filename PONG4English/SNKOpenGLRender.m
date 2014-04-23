//
//  SNKOpenGLRender.m
//  PONG4English
//
//  Created by Kévin Mondésir on 01/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//
/*
 
      へ　　　　　／|
 　 　/＼7　　　 ∠＿/
 　  /　│　　 ／　／
 　 │　Z ＿,＜　／　　 /`ヽ
 　 │　　　　　ヽ　　 /　　〉
 　 Y　　　　　`　  /　　/
 　ｲ ●　､　●　⊂⊃ 〈　　/
 　()　 へ　　　　|　＼〈
 　　>ｰ ､_　 ィ　 │ ／／
 　 / へ　　 /　ﾉ＜| ＼＼
 　 ヽ_ﾉ　　(_／　 │／／
 　　7　　　　　　　|／
 　　＞―r￣￣`ｰ―＿
 	PIKACHU BY MAMONE
 */
#ifdef __APPLE__
# define __gl_h_
# define GL_DO_NOT_WARN_IF_MULTI_GL_VERSION_HEADERS_INCLUDED
#endif

#import "SNKOpenGLRender.h"


#define glError() { \
GLenum err = glGetError(); \
while (err != GL_NO_ERROR) { \
__builtin_printf("glError: %s caught at %s:%u\n", (char *)gluErrorString(err), __FILE__, __LINE__); \
err = glGetError(); \
exit(-1); \
} \
}

float Possiblecolors[6][3]=
{
	{0.8,0.0,1},
	{0.0,0.8,1},
	{1.0,0.0,0.8},
	{1.0,1.0,1.0},
	{1.0,0.8,0.0},
	{1.0,0.3,0.0}
};
float variation=0;
#import "Ball.h"
#import "Racket.h"
#import "Text.h"
#import "Uno.h"
#import "Pause.h"
#define VS_NAME "vertexShaderFlat.vs"
#define FS_NAME "fragmentShaderFlat.fs"
#define VS_BALL "Ball.vs"
#define FS_BALL "Ball.fs"
#define VS_TEXT "Text.vs"
#define FS_TEXT "Text.fs"
#define VS_PAUSE_MENU "simplevertex.vs"
#define FS_PAUSE_MENU "simplefragment.fs"

@interface SNKOpenGLRender (private)



GLboolean loadShader(GLenum shaderType, const GLchar** shaderText, GLint* shaderID);
GLboolean linkShaders(GLint* program, GLint vertShaderID, GLint fragShaderID);
-(BOOL) LoadTexture:(int)i andNamed:(NSString *)string;
-(void)game;
-(void)entryScreen;
-(void)writeGLText:(char *)chaine withPosition:(CGPoint)position andSize:(CGFloat)size;
-(void)createBalls;
-(void)createBalls:(int)n;
@end
@implementation SNKOpenGLRender
@synthesize delegate;
BOOL startScreen;

-(BOOL)LoadTexture:(int)i andNamed:(NSString *)string
{
	
	NSImage *img=[NSImage imageNamed:string];
	//NSImage *img=[[NSImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:string]];
		if(img == nil)
			return NO;
		else if(img.size.height == 0 || img.size.width == 0)
			return NO;
		
		NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithData: [img TIFFRepresentation]];
		/*NSData *data;
		data = [rep representationUsingType: NSPNGFileType
								  properties: nil];
		[data writeToFile: @"fichiertemporaire.png"   atomically: NO];*/
		glGenTextures( 1, &texture[i]);
		glBindTexture( GL_TEXTURE_2D, texture[i]);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 0);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
		glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, rep.size.width,
					 rep.size.height, 0, GL_RGBA,
					 GL_UNSIGNED_BYTE, rep.bitmapData);
		
	[rep release];
	//[img release];
	return YES;
}
-(void)loadModels
{
	ball=(quadric *) malloc(sizeof(quadric));
	ball->vertCount	=	BALL_VERTEX_COUNT;
	ball->indexCount=	BALL_INDEX_COUNT;
	glGenBuffers(4, &ball->vertsID);
	glBindBuffer(GL_ARRAY_BUFFER, ball->vertsID);
	glBufferData(GL_ARRAY_BUFFER, ball->vertCount*3*sizeof(float), ball_vertices, GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, ball->colorsID);
	glBufferData(GL_ARRAY_BUFFER, ball->vertCount*3*sizeof(float), ball_colors, GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, ball->normalsID);
	glBufferData(GL_ARRAY_BUFFER, ball->vertCount*3*sizeof(float), ball_normals, GL_STATIC_DRAW);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ball->indicesID);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, ball->indexCount*sizeof(GLuint), ball_indices, GL_STATIC_DRAW);
	
	
	racket=(quadric *)malloc(sizeof(quadric));
	racket->vertCount=RACKET_VERTEX_COUNT;
	racket->indexCount=RACKET_INDEX_COUNT;
	glGenBuffers(4, &racket->vertsID);
	glBindBuffer(GL_ARRAY_BUFFER, racket->vertsID);
	glBufferData(GL_ARRAY_BUFFER, racket->vertCount*3*sizeof(float), racket_vertices, GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, racket->colorsID);
	glBufferData(GL_ARRAY_BUFFER, racket->vertCount*3*sizeof(float), racket_colors, GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, racket->normalsID);
	glBufferData(GL_ARRAY_BUFFER, racket->vertCount*3*sizeof(float), racket_normals, GL_STATIC_DRAW);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, racket->indicesID);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, racket->indexCount*sizeof(GLuint), racket_indices, GL_STATIC_DRAW);
	
	letter=(quadricText *) malloc(sizeof(quadricText));
	letter->vertCount=TEXT_VERTEX_COUNT;
	letter->indexCount=TEXT_INDEX_COUNT;
	glGenBuffers(3, &letter->vertsID);
	glBindBuffer(GL_ARRAY_BUFFER, letter->vertsID);
	glBufferData(GL_ARRAY_BUFFER, letter->vertCount*3*sizeof(float), text_vertices, GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, letter->textID);
	glBufferData(GL_ARRAY_BUFFER, letter->vertCount*3*sizeof(float), text_coord, GL_STATIC_DRAW);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, letter->indicesID);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, letter->indexCount*sizeof(GLuint), text_indices, GL_STATIC_DRAW);
	
	uno=(quadricText *)malloc(sizeof(quadricText));
	uno->vertCount=UNO_VERTEX_COUNT;
	uno->indexCount=UNO_INDEX_COUNT;
	glGenBuffers(3, &uno->vertsID);
	glBindBuffer(GL_ARRAY_BUFFER, uno->vertsID);
	glBufferData(GL_ARRAY_BUFFER, uno->vertCount*3*sizeof(float), uno_vertices, GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, uno->textID);
	glBufferData(GL_ARRAY_BUFFER, uno->vertCount*3*sizeof(float), uno_coord, GL_STATIC_DRAW);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, uno->indicesID);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, uno->indexCount*sizeof(GLuint), uno_indices, GL_STATIC_DRAW);
	
	pauseM=(defaultStruct *)malloc(sizeof(defaultStruct));
	pauseM->vertCount=PAUSESCREEN_VERTEX_COUNT;
	pauseM->indexCount=PAUSESCREEN_INDEX_COUNT;
	glGenBuffers(3, &pauseM->vertsID);
	glBindBuffer(GL_ARRAY_BUFFER, pauseM->vertsID);
	glBufferData(GL_ARRAY_BUFFER, pauseM->vertCount*3*sizeof(float), pause_vertices, GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, pauseM->colorsID);
	glBufferData(GL_ARRAY_BUFFER, pauseM->vertCount*4*sizeof(float), pause_colors, GL_STATIC_DRAW);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, pauseM->indicesID);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, pauseM->indexCount*sizeof(GLuint), pause_indices, GL_STATIC_DRAW);
}
- (id)init
{
    if (self = [super init])
    {
        [self loadModels];
		chaineRestrict=malloc(30*sizeof(char));

		startScreen=YES;
		score=0;
        animationDelta = 1.5/100;
        animationStep = 0.0;
        kAnimationLoopValue = 360.0 / animationDelta;
        animate = YES;
        xAxisAngle = 0.0;
        zAxisAngle = 0.0;
		xvitesse=0.6;
		yvitesse=0.8;
		Balls=[[NSMutableArray alloc]init];
		removeBalls=[[NSMutableArray alloc]init];
		[self createBalls:8];
		createABall=0;
		Myracket=[[SNKracket alloc]initWithPosition:CGPointMake(-80.0, 0.0f)];
		lock=[[NSRecursiveLock alloc]init];
		NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"Point" ofType:@"mp3"];
		sound = [[NSSound alloc] initWithContentsOfFile:resourcePath byReference:YES];
		
		
    }
    return self;
}
-(void)createBalls:(int)n
{
	for (; n>0; n--) {
		[self createBalls];
	}
}
-(void)createBalls
{
	SNKBall * balle=[[SNKBall alloc]initWithSpeed:1.6 andPosition:CGPointMake(0.0, 0.0)];
	[Balls addObject:balle];
	[balle release];
}
- (void)dealloc
{
	glFinish();
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDeleteBuffers(4, &racket->vertsID);
	free(racket);
	glDeleteBuffers(4, &ball->vertsID);
	free(ball);
	glDeleteBuffers(3, &letter->vertsID);
	free(letter);
	glDeleteBuffers(3, &uno->vertsID);
	free(uno);
	glDeleteBuffers(3, &pauseM->vertsID);
	free(pauseM);
	//glDeleteBuffers(1, &scaleBufferID);
	free(chaineRestrict);
    glDeleteBuffers(1, &orientationMatID);
	glUseProgram(0);
	int i = 0;
	for (; i < kProgramCount; i++) {
		glDeleteProgram(programs[i]);
	}
	for (; i < kShaderCount; i++) {
		glDeleteShader(shaders[i]);
	}
	glDeleteTextures( 1, &texture[0] );
	[Balls removeAllObjects];
	[Balls release];
	[removeBalls removeAllObjects];
	[removeBalls release];
	[Myracket release];
	[lock release];
    [super dealloc];
}

#pragma mark - General Setup

- (BOOL)setupScene
{
	
	lightPos.x = 0.0; lightPos.y = 5.0; lightPos.z = 0.0; lightPos.w = 1.0;
	lightColor.x = 0.0; lightColor.y = 0.0; lightColor.z = 0.0; lightColor.w = 0.0;
	
	return YES;
}

- (BOOL)setupGL
{
	
    // create a VAO (vertex array object)
	glGenVertexArrays(5, gearVAOId);
	glBindVertexArray(gearVAOId[0]);
    
	if([self loadShaders])
	{
		return NO;
	}
	/*
	if(![self setupScene])
	{
		return NO;
	}*/
	glEnable(GL_ALPHA_TEST);
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_CULL_FACE);
	glEnable(GL_BLEND);// you enable blending function
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glViewport(0, 0, width, height);
    
    // set up the projection matrix uniform
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(75.0 * (M_PI/180.0), ((GLdouble) width) / ((GLdouble) height), 0.1, 35.0);
	//projection matrix take the ratio width/height
    glUseProgram(programs[0]);
	glUniformMatrix4fv(projectionMatrixLocation, 1, GL_FALSE, (const GLfloat*) &projectionMatrix);
    
	// the gear's normals are with the first vertex
	glProvokingVertexEXT(GL_FIRST_VERTEX_CONVENTION_EXT);
	/*
    // set up vertex attributes
	// one scale and one matrix *per instance*
	//glBindBuffer(GL_ARRAY_BUFFER, scaleBufferID);
	//glVertexAttribPointer(attribScale, 1, GL_FLOAT, GL_FALSE, 0, NULL);
    // glVertexAttribDivisor modifies the rate at which generic vertex attributes advance during instanced rendering
    // here we specify that we want to advance the attribute once per instance
	//glVertexAttribDivisorARB(attribScale, 1);
	
    // all matrix data is in one VBO. Set appropriate offsets
	
	// position, color and normal *per vertex*/
	glBindBuffer(GL_ARRAY_BUFFER, racket->vertsID);
    glVertexAttribPointer(attribPosition, 3, GL_FLOAT, GL_FALSE, 0, NULL);
	glBindBuffer(GL_ARRAY_BUFFER, racket->colorsID);
    glVertexAttribPointer(attribColor, 3, GL_FLOAT, GL_FALSE, 0, NULL);
	glBindBuffer(GL_ARRAY_BUFFER, racket->normalsID);
	glVertexAttribPointer(attribNormal, 3, GL_FLOAT, GL_FALSE, 0, NULL);
    
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, racket->indicesID);
	
	glBindVertexArray(gearVAOId[1]);
    
	 if([self loadShaders2])
	 {
	 return NO;
	 }
	 
	
    // set up the projection matrix uniform
    glUseProgram(programs[1]);
	glUniformMatrix4fv(projectionMatrixLocation2, 1, GL_FALSE, (const GLfloat*) &projectionMatrix);
    
	// the gear's normals are with the first vertex
	glProvokingVertexEXT(GL_FIRST_VERTEX_CONVENTION_EXT);
	
    // set up vertex attributes
	// one scale and one matrix *per instance*
	
	glBindBuffer(GL_ARRAY_BUFFER, ball->vertsID);
    glVertexAttribPointer(attribPosition2, 3, GL_FLOAT, GL_FALSE, 0, NULL);
	glBindBuffer(GL_ARRAY_BUFFER, ball->colorsID);
    glVertexAttribPointer(attribColor2, 3, GL_FLOAT, GL_FALSE, 0, NULL);
	//glBindBuffer(GL_ARRAY_BUFFER, ball->normalsID);
	//glVertexAttribPointer(attribNormal2, 3, GL_FLOAT, GL_FALSE, 0, NULL);
    
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ball->indicesID);
	if(![self LoadTexture:0 andNamed:@"skull4.png"])
		return 4;
	//textureID= glGetUniformLocation(programs[1], "myTextureSampler");
	glActiveTexture(GL_TEXTURE2);
	glBindTexture(GL_TEXTURE_2D, texture[0]);
	glUniform1i(texture2D, 0);
	
	
	glBindVertexArray(gearVAOId[2]);
	if([self loadShaders3])
	{
		return NO;
	}
	glUseProgram(programs[2]);
	glUniformMatrix4fv(projectionMatrixLocation3, 1, GL_FALSE, (const GLfloat*) &projectionMatrix);
	glProvokingVertexEXT(GL_FIRST_VERTEX_CONVENTION_EXT);
	glBindBuffer(GL_ARRAY_BUFFER, letter->vertsID);
    glVertexAttribPointer(attribPosition2, 3, GL_FLOAT, GL_FALSE, 0, NULL);
	glBindBuffer(GL_ARRAY_BUFFER, letter->textID);
    glVertexAttribPointer(attribColor2, 3, GL_FLOAT, GL_FALSE, 0, NULL);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, letter->indicesID);
	if(![self LoadTexture:1 andNamed:@"visitorLarge.png"])
		return 4;
	glActiveTexture(GL_TEXTURE1);
	glBindTexture(GL_TEXTURE_2D, texture[1]);
	glUniform1i(textureText, 1);
	
	
	glBindVertexArray(gearVAOId[3]);
	//glUniformMatrix4fv(projectionMatrixLocation3, 1, GL_FALSE, (const GLfloat*) &projectionMatrix);
	glProvokingVertexEXT(GL_FIRST_VERTEX_CONVENTION_EXT);
	glBindBuffer(GL_ARRAY_BUFFER, uno->vertsID);
    glVertexAttribPointer(attribPosition2, 3, GL_FLOAT, GL_FALSE, 0, NULL);
	glBindBuffer(GL_ARRAY_BUFFER, uno->textID);
    glVertexAttribPointer(attribColor2, 3, GL_FLOAT, GL_FALSE, 0, NULL);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, uno->indicesID);
	
	
	if([self loadShaders4])
	{
		return NO;
	}
	glUseProgram(programs[3]);
	glUniformMatrix4fv(projectionMatrixLocation4, 1, GL_FALSE, (const GLfloat*) &projectionMatrix);
	glBindVertexArray(gearVAOId[4]);
	glProvokingVertexEXT(GL_FIRST_VERTEX_CONVENTION_EXT);
	glBindBuffer(GL_ARRAY_BUFFER, pauseM->vertsID);
    glVertexAttribPointer(attribPosition4, 3, GL_FLOAT, GL_FALSE, 0, NULL);
	glBindBuffer(GL_ARRAY_BUFFER, pauseM->colorsID);
    glVertexAttribPointer(colorSet, 4, GL_FLOAT, GL_FALSE, 0, NULL);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, pauseM->indicesID);
	[self regenCameraMatrix];
	return YES;
}

- (void)reshapeToWidth:(GLsizei)w height:(GLsizei)h
{
	[lock lock];
	width = w;
	height = h;
	glViewport(0, 0, width, height);
	[lock unlock];
}

#pragma mark - Rendering

- (void)draw
{
	
	[lock lock];
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
	float textureColor[3]={0.5,1.0,0.2};
	glUniform3fv(TextColor, 1, (const GLfloat*) &textureColor);
	if(startScreen)
	{
		[self entryScreen];
	}
	else{
		[self game];
		
	}
	[lock unlock];
}
-(void)entryScreen
{
	
	//GLKVector4 lightPosition = GLKMatrix4MultiplyVector4(cameraMatrix, lightPos);
	GLKVector4	nouvelPosition=GLKVector4Make(1.0f*(score%10), 0.0f, 0.0f, 1.0f);
	//nouvelPosition=GLKVector4Make(positionBall.x, positionBall.y, 0.0f, 0.0f);
	glBindVertexArray(gearVAOId[1]);
    
	// enable all our attribs
    glEnableVertexAttribArray(attribPosition2);
    glEnableVertexAttribArray(attribColor2);
	//glEnableVertexAttribArray(attribNormal2);
	//int prev=createABall;
	for(SNKBall * balle in Balls)
	{
		if(animate)
		{
			if([balle getPosition].x<-79)
			{
				[balle contact];
			}
			[balle maj2];
			[balle impactTest];
			
		}
		positionBall=[balle getPosition];
		glUseProgram(programs[1]);
		nouvelPosition=GLKVector4Make(positionBall.x, positionBall.y, 0.0f, 0.0f);
		glUniform3fv(moveIT2, 1, (const GLfloat *)&nouvelPosition);
		glUniformMatrix4fv(cameraTransformLocation2, 1, GL_FALSE, (const GLfloat*) &cameraMatrix);
		//glUniform3fv(lightPosLocation2, 1, (const GLfloat*) &lightPosition);
		glUniform3fv(lightColorLocation2, 1, (const GLfloat*) &Possiblecolors[[balle color]]);
		//glUniform3fv(lightColorLocation2, 1, (const GLfloat*) &lightColor);
		glDrawElementsInstancedARB(GL_TRIANGLES, ball->indexCount, GL_UNSIGNED_INT, NULL, 3);
		glClear(GL_DEPTH_BUFFER_BIT );
	}
	variation++;
	variation=variation>189?10:variation;
	float textureColor[3]={0.5*sin(M_PI*variation/200),0.0,0.2*sin(M_PI*variation/200)};
	if (animate) {
		[Myracket animate];
	}
	//TextColor
	glEnableVertexAttribArray(attribPosition3);
    glEnableVertexAttribArray(TextCoord);
	glUseProgram(programs[2]);
	glUniformMatrix4fv(cameraTransformLocation3, 1, GL_FALSE, (const GLfloat*) &cameraMatrix);
	
	glClear(GL_DEPTH_BUFFER_BIT );
	
	[self writeGLText:"pong4english" withPosition:CGPointMake(-110.0f, 60.0f) andSize:0.6f];
	
	[self writeGLText:"by" withPosition:CGPointMake(-20.0f, 40.0f) andSize:0.4f];
	
	[self writeGLText:"kevin mondesir" withPosition:CGPointMake(-130.0f, 10.0f) andSize:0.3f];
	glUniform3fv(TextColor, 1, (const GLfloat*) &textureColor);
	[self writeGLText:"press p to play" withPosition:CGPointMake(-140.0f, -40.0f) andSize:0.3f];
}
-(void)writeGLText:(char *)chaine withPosition:(CGPoint)position andSize:(CGFloat)size
{
	
	glUseProgram(programs[2]);
	//float position=60.0f;
	//float positionx=-110.0f;
	GLKVector4	nouvelPosition;
	int iter=0;
	while (iter<strlen(chaine)) {
		//NSLog(@"%c %d", chaine[iter],(int) chaine[iter]);
		if(chaine[iter]!=32){
		if(chaine[iter]>47 &&chaine[iter]<58)
		{
			nouvelPosition=GLKVector4Make(1.0f*(chaine[iter]-48),position.x, position.y, size);
			if(chaine[iter]-48==1)
			{
				glBindVertexArray(gearVAOId[3]);
			}
			else{
				glBindVertexArray(gearVAOId[2]);
			}
			glEnableVertexAttribArray(attribPosition3);
			glEnableVertexAttribArray(TextCoord);
			glUseProgram(programs[2]);
			//glUniform3fv(numberTest, 1, (const GLfloat *)&nouvelPosition);
			glUniform4fv(moveIT3, 1, (const GLfloat *)&nouvelPosition);
			glDrawElementsInstancedARB(GL_TRIANGLES, letter->indexCount, GL_UNSIGNED_INT, NULL, 1);
		}
		else{
			nouvelPosition=GLKVector4Make(1.0f*chaine[iter],position.x, position.y, size);
			glBindVertexArray(gearVAOId[2]);
			//glUniform3fv(numberTest, 1, (const GLfloat *)&nouvelPosition);
			glUniform4fv(moveIT3, 1, (const GLfloat *)&nouvelPosition);
			glDrawElementsInstancedARB(GL_TRIANGLES, letter->indexCount, GL_UNSIGNED_INT, NULL, 1);
			
		}
		}
		iter++;
		position.x+=20;
		
	}
}
-(void)game
{
	GLKMatrix4 rotMatrix = GLKMatrix4MakeRotation(animationStep*animationDelta, 0.0, 0.0, 1.0);
	GLKVector4 lightPosition = GLKMatrix4MultiplyVector4(cameraMatrix, lightPos);
	GLKVector4	nouvelPosition=GLKVector4Make(1.0f*(score%10), 0.0f, 0.0f, 1.0f);
	
	if (animate) {
		[Myracket animate];
	}
	//char * chaineRestrict=malloc(20*sizeof(char));
	sprintf(chaineRestrict, "%d",10-score%10);
	[self writeGLText:chaineRestrict withPosition:CGPointMake(0.0f, 0.0f) andSize:1.0f];
	sprintf(chaineRestrict, "score   %d",score);
	[self writeGLText:chaineRestrict withPosition:CGPointMake(40.0f, 220.0f) andSize:0.2f];
	//free(chaineRestrict);
	
	
	glClear(GL_DEPTH_BUFFER_BIT );
	
	nouvelPosition=GLKVector4Make([Myracket getPosition].x, [Myracket getPosition].y, 0.0f, 0.0f);
    glBindVertexArray(gearVAOId[0]);
    
	// enable all our attribs
    glEnableVertexAttribArray(attribPosition);
    glEnableVertexAttribArray(attribColor);
	glEnableVertexAttribArray(attribNormal);
    
    // update uniform vals
	glUseProgram(programs[0]);
	glUniformMatrix4fv(cameraTransformLocation, 1, GL_FALSE, (const GLfloat*) &cameraMatrix);
	glUniformMatrix4fv(rotationAnimationMatrixLocation, 1, GL_FALSE, (const GLfloat*) &rotMatrix);
	glUniform3fv(moveIT, 1, (const GLfloat *)&nouvelPosition);
	glUniform3fv(lightPosLocation, 1, (const GLfloat*) &lightPosition);
	glUniform3fv(lightColorLocation, 1, (const GLfloat*) &lightColor);
	
    // call glDrawElementsInstanced to render multiple instances of primitives in a single draw call
	glDrawElementsInstancedARB(GL_TRIANGLES, racket->indexCount, GL_UNSIGNED_INT, NULL, 1);
	glClear(GL_DEPTH_BUFFER_BIT );
	glBindVertexArray(gearVAOId[1]);
    
	// enable all our attribs
    glEnableVertexAttribArray(attribPosition2);
    glEnableVertexAttribArray(attribColor2);
	//glEnableVertexAttribArray(attribNormal2);
	//glEnableVertexAttribArray(attribScale);
	if(positionBall.x>-78&&positionBall.x+xvitesse<=-78&&yposition-positionBall.y<6&&yposition-positionBall.y>-6)
	{
		xvitesse=-xvitesse;
	}
	if(animate){
		positionBall.x+=xvitesse;
		positionBall.y+=yvitesse;
	}
	
	nouvelPosition=GLKVector4Make(positionBall.x, positionBall.y, 0.0f, 0.0f);
	int prev=createABall;
	for(SNKBall * balle in Balls)
	{
		if(animate)
		{
			[Myracket TestBall:balle];
			[balle maj];
			if([balle impactTest])
			{
				score++;
				if([sound isPlaying])
				[sound stop];
				[sound play];
				createABall++;
			}
			if([balle disappear])
			[removeBalls addObject:balle];
			
		}
		positionBall=[balle getPosition];
		glUseProgram(programs[1]);
		nouvelPosition=GLKVector4Make(positionBall.x, positionBall.y, 0.0f, 0.0f);
		glUniform3fv(moveIT2, 1, (const GLfloat *)&nouvelPosition);
		glUniformMatrix4fv(cameraTransformLocation2, 1, GL_FALSE, (const GLfloat*) &cameraMatrix);
		//glUniform3fv(lightPosLocation2, 1, (const GLfloat*) &lightPosition);
		glUniform3fv(lightColorLocation2, 1, (const GLfloat*) &Possiblecolors[[balle color]]);
		//glUniform3fv(lightColorLocation2, 1, (const GLfloat*) &lightColor);
		glDrawElementsInstancedARB(GL_TRIANGLES, ball->indexCount, GL_UNSIGNED_INT, NULL, 3);
		glClear(GL_DEPTH_BUFFER_BIT );
	}
	
	[self createBalls:createABall/10 -prev/10];
	/*
	for (int i=createABall/10 -prev/10; i>0; i--) {
		SNKBall * balle=[[SNKBall alloc]initWithSpeed:1.3 andPosition:CGPointMake(0.0, 0.0)];
		[Balls addObject:balle];
		[balle release];
	}
	*/
	for (SNKBall * balle in removeBalls) {
		[Balls removeObject:balle];
	}
	if([Balls count]==0)
	{
		startScreen=YES;
		score=0;
		[delegate startScreen];
		[self createBalls:8];
	}
	[removeBalls removeAllObjects];
	if (!animate) {
		glUseProgram(programs[3]);
		glUniformMatrix4fv(cameraTransformLocation4, 1, GL_FALSE, (const GLfloat*) &cameraMatrix);
		glBindVertexArray(gearVAOId[4]);
		glEnableVertexAttribArray(attribPosition4);
		glEnableVertexAttribArray(colorSet);
		glDrawElementsInstancedARB(GL_TRIANGLES, pauseM->indexCount, GL_UNSIGNED_INT, NULL, 3);
		//char * chaine2="pause";
		//char * chaine3="press space to play";
		glClear(GL_DEPTH_BUFFER_BIT );
		variation++;
		variation=variation>189?10:variation;
		[self writeGLText:"pause" withPosition:CGPointMake(-50.0f, 60.0f) andSize:0.6f];
		float textureColor2[3]={0.5*sin(M_PI*variation/200),0.0,0.2*sin(M_PI*variation/200)};
		glUniform3fv(TextColor, 1, (const GLfloat*) &textureColor2);
		[self writeGLText:"press space to play" withPosition:CGPointMake(-190.0f, -40.0f) andSize:0.3f];
	}
	else{
		//char * chaine3="press space to pause";
		glClear(GL_DEPTH_BUFFER_BIT );
		
		variation++;
		variation=variation>189?10:variation;
		[self writeGLText:"press space to pause" withPosition:CGPointMake(-190.0f, -640.0f) andSize:0.07f];
		
	}
	float textureColor[3]={0.5,1.0,0.2};
	glUniform3fv(TextColor, 1, (const GLfloat*) &textureColor);
	glUseProgram(0);
    glBindVertexArray(0);
	
	
}
- (void)toggleAnimation
{
	
	[lock lock];
	if(!startScreen){
		
		animate = !animate;
		if([sound isPlaying]&&!animate)
		{
			currentTime=[sound currentTime];
			[sound stop];
		}
		if(animate &&(currentTime!=0))
		{
			[sound play];
			[sound setCurrentTime:currentTime];
		}
		[delegate pause];
	}
	[lock unlock];
}

#pragma mark - Camera Utility

- (void)regenCameraMatrix
{
	// set up a default camera matrix
    GLKMatrix4 modelView = GLKMatrix4MakeTranslation(0, 0, -6.0);
	cameraMatrix=modelView;
	//c'est une matrice de translation
	//{(1,0,0,0)
	//,(0,1,0,0)
	//,(0,0,-6,0)
	//,(0,0,0,1)}
	
}
-(void)click:(CGPoint)point
{
	
}
- (void)applyCameraMovementWdx:(float)dx dy:(float)dy
{
	xAxisAngle += dy/3 * (M_PI/180.0);
	zAxisAngle += dx/3 * (M_PI/180.0);
	[self regenCameraMatrix];
}
#pragma mark - Moove Racket
- (void)up
{
	[lock lock];
	mooveRacket=YES;
	[Myracket beginMoveTop];
	[lock unlock];
}
-(void)addBall
{
	[lock lock];
	if(startScreen){
		createABall=0;
		[Balls removeAllObjects];
		SNKBall * balle=[[SNKBall alloc]initWithSpeed:1.3 andPosition:CGPointMake(0.0, 0.0)];
		[Balls addObject:balle];
		[balle release];
		startScreen=NO;
		[delegate inGame];
	}
	[lock unlock];
}
- (void)down
{
	[lock lock];
	mooveRacket=YES;
	[Myracket beginMoveBottom];
	[lock unlock];
}
-(void)endDown
{
	[lock lock];
	mooveRacket=NO;
	[Myracket stopMoveBottom];
	[lock unlock];
}
-(void)endUp
{
	[lock lock];
	mooveRacket=NO;
	[Myracket stopMoveTop];
	[lock unlock];
}
#pragma mark - Shader Loading

- (GLchar*)loadShaderFromFile:(const char*)shaderName
{
    const char* resourcePath = [[[NSBundle mainBundle] resourcePath] cStringUsingEncoding:NSASCIIStringEncoding];
	char pathToShader[255];
	sprintf(&pathToShader[0], "%s/%s", resourcePath, shaderName);
    
	FILE* f = fopen(pathToShader, "rb");
	if(!f)
	{
		return NULL;
	}
	fseek(f, 0, SEEK_END);
	size_t shaderLen = ftell(f);
	fseek(f, 0, SEEK_SET);
	GLchar* code = (GLchar*) malloc(shaderLen+1);
	fread(code, sizeof(char), shaderLen, f);
	fclose(f);
	code[shaderLen] = '\0';
	return code;
}

- (GLshort)loadShaders
{
	GLchar* shader = [self loadShaderFromFile:VS_NAME];
	if (!shader) {
		return 1;
	}
	
	if(!loadShader(GL_VERTEX_SHADER, (const GLchar**) &shader, &shaders[0]))
		return 1;
	free(shader);
	
	shader = [self loadShaderFromFile:FS_NAME];
	if(!loadShader(GL_FRAGMENT_SHADER, (const GLchar**) &shader, &shaders[1]))
		return 2;
	free(shader);
	
	if(!linkShaders(&programs[0], shaders[0], shaders[1]))
	{
		return 3;
	}
	
    attribPosition = glGetAttribLocation(programs[0], "attribPosition");
    attribColor = glGetAttribLocation(programs[0], "attribColor");
	attribNormal = glGetAttribLocation(programs[0], "attribNormal");
	rotationAnimationMatrixLocation = glGetUniformLocation(programs[0], "rotationAnimationMatrix");
	moveIT=glGetUniformLocation(programs[0], "moveIT");
	cameraTransformLocation = glGetUniformLocation(programs[0], "cameraMatrix");
    projectionMatrixLocation = glGetUniformLocation(programs[0], "projectionMatrix");
	lightPosLocation = glGetUniformLocation(programs[0], "lightPos");
	lightColorLocation = glGetUniformLocation(programs[0], "lightColor");
	//NSLog(@"attribPosition = %d",attribPosition);
	//NSLog(@"attribColor = %d",attribColor);
    
	return 0;
}
- (GLshort)loadShaders2
{
	GLchar* shader = [self loadShaderFromFile:VS_BALL];
	if (!shader) {
		return 1;
	}
	
	if(!loadShader(GL_VERTEX_SHADER, (const GLchar**) &shader, &shaders[2]))
		return 1;
	free(shader);
	
	shader = [self loadShaderFromFile:FS_BALL];
	if(!loadShader(GL_FRAGMENT_SHADER, (const GLchar**) &shader, &shaders[3]))
		return 2;
	free(shader);
	
	if(!linkShaders(&programs[1], shaders[2], shaders[3]))
	{
		return 3;
	}
	
    attribPosition2 = glGetAttribLocation(programs[1], "attribPosition");
    attribColor2 = glGetAttribLocation(programs[1], "attribColor");
	//attribNormal2 = glGetAttribLocation(programs[1], "attribNormal");
	moveIT2=glGetUniformLocation(programs[1], "moveIT");
	cameraTransformLocation2 = glGetUniformLocation(programs[1], "cameraMatrix");
    projectionMatrixLocation2 = glGetUniformLocation(programs[1], "projectionMatrix");
	//lightPosLocation2 = glGetUniformLocation(programs[1], "lightPos");
	lightColorLocation2 = glGetUniformLocation(programs[1], "lightColor");
	texture2D = glGetUniformLocation(programs[1], "myTextureSampler");
	//textureText= glGetUniformLocation(programs[1], "myTextureSamplerText");
    //NSLog(@"attribPosition2 = %d",attribPosition2);
	//NSLog(@"attribColor2 = %d",attribColor2);
	return 0;
}
- (GLshort)loadShaders3
{
	//NSLog(@" a :%d q:%d z:%d   : donne %d %d ",(int)'a',(int)'q',(int)'z',(int)':' ,(int)' ');
	GLchar* shader = [self loadShaderFromFile:VS_TEXT];
	if (!shader) {
		return 1;
	}
	
	if(!loadShader(GL_VERTEX_SHADER, (const GLchar**) &shader, &shaders[4]))
		return 1;
	free(shader);
	
	shader = [self loadShaderFromFile:FS_TEXT];
	if(!loadShader(GL_FRAGMENT_SHADER, (const GLchar**) &shader, &shaders[5]))
		return 2;
	free(shader);
	
	if(!linkShaders(&programs[2], shaders[4], shaders[5]))
	{
		return 3;
	}
	
    attribPosition3 = glGetAttribLocation(programs[2], "attribPosition");
    TextCoord = glGetAttribLocation(programs[2], "TextCoord");
	//numberTest = glGetAttribLocation(programs[2], "test");
	moveIT3=glGetUniformLocation(programs[2], "moveIT");
	cameraTransformLocation3 = glGetUniformLocation(programs[2], "cameraMatrix");
    projectionMatrixLocation3 = glGetUniformLocation(programs[2], "projectionMatrix");
	//lightPosLocation2 = glGetUniformLocation(programs[2], "lightPos");
	TextColor = glGetUniformLocation(programs[2], "TextColor");
	textureText = glGetUniformLocation(programs[2], "myTextTexture");
	//textureText= glGetUniformLocation(programs[1], "myTextureSamplerText");
    //*/
	//NSLog(@"attribPosition3 = %d",attribPosition3);
	
	return 0;
}
-(GLshort)loadShaders4
{
	GLchar* shader=[self loadShaderFromFile:VS_PAUSE_MENU];
	if(!shader)
	{
		return 1;
	}
	if(!loadShader(GL_VERTEX_SHADER, (const GLchar**)&shader, &shaders[6]))
	{
		return 2;
	}
	shader=[self loadShaderFromFile:FS_PAUSE_MENU];
	if(!shader)
	{
		return 1;
	}
	if(!loadShader(GL_FRAGMENT_SHADER, (const GLchar **)&shader, &shaders[7]))
	{
		return 3;
	}
	if(!linkShaders(&programs[3], shaders[6], shaders[7]))
	{
		return 3;
	}
	attribPosition4=glGetAttribLocation(programs[3], "attribPosition");
	cameraTransformLocation4 = glGetUniformLocation(programs[3], "cameraMatrix");
    projectionMatrixLocation4 = glGetUniformLocation(programs[3], "projectionMatrix");
	colorSet= glGetAttribLocation(programs[3], "colorSet");
	
	return 0;
}
GLboolean loadShader(GLenum shaderType, const GLchar** shaderText, GLint* shaderID)
{
	GLint status = 0;
	
	*shaderID = glCreateShader(shaderType);
	glShaderSource(*shaderID, 1, shaderText, NULL);
	glCompileShader(*shaderID);
	glGetShaderiv(*shaderID, GL_COMPILE_STATUS, &status);
	if(status == GL_FALSE)
	{
		GLint logLength = 0;
		glGetShaderiv(*shaderID, GL_INFO_LOG_LENGTH, &logLength);
		GLcharARB *log = (GLcharARB*) malloc(logLength);
		glGetShaderInfoLog(*shaderID, logLength, &logLength, log);
		printf("Shader compile log\n %s", log);
		free(log);
		return GL_FALSE;
	}
	return GL_TRUE;
}

GLboolean linkShaders(GLint* program, GLint vertShaderID, GLint fragShaderID)
{
	GLint status = 0;
	*program = glCreateProgram();
	glAttachShader(*program, vertShaderID);
	glAttachShader(*program, fragShaderID);
	
	GLint logLength;
	
	glLinkProgram(*program);
	glGetProgramiv(*program, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0) {
		GLchar *log = (GLchar*) malloc(logLength);
		glGetProgramInfoLog(*program, logLength, &logLength, log);
		printf("Program link log:\n%s\n", log);
		free(log);
		glDeleteShader(vertShaderID);
		glDeleteShader(fragShaderID);
		return GL_FALSE;
	}
	glValidateProgram(*program);
	glGetProgramiv(*program, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0) {
		GLchar *log = (GLchar*)malloc(logLength);
		glGetProgramInfoLog(*program, logLength, &logLength, log);
		printf("Program validate log:\n%s\n", log);
		free(log);
        return GL_FALSE;
	}
	
	glGetProgramiv(*program, GL_VALIDATE_STATUS, &status);
	if (status == 0)
    {
		printf("Failed to validate program %d\n", *program);
        return GL_FALSE;
    }
	return GL_TRUE;
}
@end
