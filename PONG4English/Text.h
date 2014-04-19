//
//  Text.h
//  PONG4English
//
//  Created by Kévin Mondésir on 08/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#ifndef PONG4English_Text_h
#define PONG4English_Text_h
#define TEXT_VERTEX_COUNT 4
#define TEXT_INDEX_COUNT 6
float text_vertices[4][3]=
{
	{10.0f,10.0f,1.0f},
	{10.0f,-10.0f,1.0f},
	{-10.0f,-10.0f,1.0f},
	{-10.0f,10.0f,1.0f}
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
float text_coord[4][3]=
{
	{0.5,0.13476563,0},
	{0.5,0.21507813,0},
	{0.41992188,0.21507813,0},
	{0.41992188,0.13476563,0}
};
unsigned int text_indices[6]=
{
	2,1,3,
	1,0,3
};


#endif
