//
//  Ball.h
//  PONG4English
//
//  Created by Kévin Mondésir on 02/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#ifndef PONG4English_Ball_h
#define PONG4English_Ball_h
#define BALL_VERTEX_COUNT 4
#define BALL_INDEX_COUNT 6
float ball_vertices[4][3]=
{
	{2.0f,2.0f,1.0f},
	{2.0f,-2.0f,1.0f},
	{-2.0f,-2.0f,1.0f},
	{-2.0f,2.0f,1.0f}
};
//La balle est bordeau
/*
float ball_colors[4][3]=
{
	{0.45882353,0.023529412,0.043137255},
	{0.45882353,0.023529412,0.043137255},
	{0.45882353,0.023529412,0.043137255},
	{0.45882353,0.023529412,0.043137255}
};/*/
float ball_colors[4][3]=
{
	{0.0,0.0,0.043137255},
	{0.0,1.0,0.043137255},
	{1.0,1.0,0.043137255},
	{1.0,0.0,0.043137255}
};
float	ball_normals[4][3]=
{
	{0.0f,0.0f,1.0f},
	{0.0f,0.0f,1.0f},
	{0.0f,0.0f,1.0f},
	{0.0f,0.0f,1.0f}
};
unsigned int ball_indices[6]=
{
	2,1,3,
	1,0,3
};


#endif
