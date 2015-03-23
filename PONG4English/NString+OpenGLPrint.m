//
//  NString+OpenGLPrint.m
//  PONG4English
//
//  Created by Kévin Mondésir on 24/12/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import "NString+OpenGLPrint.h"

@implementation NSString (OpenGLPrint)
static GLuint program; //
static GLuint vaoID[2]; //
static GLuint attribPosition; //
static GLuint textureCoord; //
static GLuint numbText; //
static GLuint moveID; //
static quadricText * letter; //

+ (void)setmoveId:(GLuint)moveId
{
	moveID=moveId;
}
+ (void)setAttribPos:(GLuint)attribPos
{
	attribPosition=attribPos;
}
+ (void) setProgram:(GLuint)prog
{
	program=prog;
}
+ (void) setVaoID1:(GLuint) id1 andVaoID2:(GLuint) id2
{
	vaoID[0]=id1;
	vaoID[1]=id2;
}
+ (void)setLetter:(quadricText *)letters
{
	letter=letters;
}
+ (void)setNumbText:(GLuint)numbTexture
{
	numbText=numbTexture;
}
+ (void)setTextureCoord:(GLuint)textCoord
{
	textureCoord=textCoord;
}
-(void)writeGLTextWithPosition:(CGPoint)position andSize:(CGFloat)size
{
	[self writeGLTextWithPosition:position decalage:20 andSize:size];
}
-(void)writeGLTextWithPosition:(CGPoint)position decalage:(float)decalage andSize:(CGFloat)size
{
	
	glUseProgram(program);
	//float position=60.0f;
	//float positionx=-110.0f;
	GLKVector4	nouvelPosition;
	NSUInteger iter=0;
	while (iter<[self length]) {
		unichar charactere=[self characterAtIndex:iter];
		//NSLog(@"%c %d", chaine[iter],(int) chaine[iter]);
		if(charactere!=32){
			if(charactere>47 &&charactere<58)
			{
				nouvelPosition=GLKVector4Make(1.0f*(charactere-48),position.x, position.y, size);
				if(charactere-48==1)
				{
					glBindVertexArray(vaoID[1]);
				}
				else{
					glBindVertexArray(vaoID[0]);
				}
				glEnableVertexAttribArray(attribPosition);
				glEnableVertexAttribArray(textureCoord);
				glUseProgram(program);
				glUniform3fv(numbText, 1, (const GLfloat *)&nouvelPosition);
				glUniform4fv(moveID, 1, (const GLfloat *)&nouvelPosition);
				glDrawElementsInstancedARB(GL_TRIANGLES, letter->indexCount, GL_UNSIGNED_INT, NULL, 1);
			}
			else{
				nouvelPosition=GLKVector4Make(1.0f*charactere,position.x, position.y, size);
				glBindVertexArray(vaoID[0]);
				glUniform3fv(numbText, 1, (const GLfloat *)&nouvelPosition);
				glUniform4fv(moveID, 1, (const GLfloat *)&nouvelPosition);
				glDrawElementsInstancedARB(GL_TRIANGLES, letter->indexCount, GL_UNSIGNED_INT, NULL, 1);
				
			}
		}
		iter++;
		position.x+=decalage;
		
	}
}
@end
