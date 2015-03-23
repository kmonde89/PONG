//
//  pongDataType.h
//  PONG4English
//
//  Created by Kévin Mondésir on 23/03/2015.
//  Copyright (c) 2015 Kmonde. All rights reserved.
//

#ifndef PONG4English_pongDataType_h
#define PONG4English_pongDataType_h
typedef struct _QuadricStruct
{
	GLuint vertCount;
	GLuint indexCount;
	GLuint vertsID;
	GLuint normalsID;
	GLuint colorsID;
	GLuint indicesID;
} quadric;
typedef struct _TexturedStruct
{
	GLuint vertCount;
	GLuint indexCount;
	GLuint vertsID;
	GLuint normalsID;
	GLuint textureID;
	GLuint indicesID;
} quadricTextured;
typedef  struct _TextTextureStruct
{
	GLuint vertCount;
	GLuint indexCount;
	GLuint vertsID;
	GLuint textID;
	GLuint indicesID;
}quadricText;
typedef struct _DefaultStruct
{
	GLuint vertCount;
	GLuint indexCount;
	GLuint vertsID;
	GLuint colorsID;
	GLuint indicesID;
}defaultStruct;

#endif
