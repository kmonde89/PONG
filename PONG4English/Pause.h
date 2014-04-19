//
//  Pause.h
//  PONG4English
//
//  Created by Kévin Mondésir on 05/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#ifndef PONG4English_Pause_h
#define PONG4English_Pause_h
#define PAUSESCREEN_VERTEX_COUNT 4
#define PAUSESCREEN_INDEX_COUNT 6
float pause_vertices[4][3]=
{
	{90.0f,90.0f,1.0f},
	{90.0f,-90.0f,1.0f},
	{-90.0f,-90.0f,1.0f},
	{-90.0f,90.0f,1.0f}
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
float pause_colors[4][4]=
{
	{0.0,0.0,0.0,0.75},
	{0.0,0.0,0.0,0.75},
	{0.0,0.0,0.0,0.75},
	{0.0,0.0,0.0,0.75}
};
float	pause_normals[4][3]=
{
	{0.0f,0.0f,1.0f},
	{0.0f,0.0f,1.0f},
	{0.0f,0.0f,1.0f},
	{0.0f,0.0f,1.0f}
};
unsigned int pause_indices[6]=
{
	2,1,3,
	1,0,3
};


#endif
