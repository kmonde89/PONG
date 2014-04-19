//
//  Uno.h
//  PONG4English
//
//  Created by Kévin Mondésir on 09/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#ifndef PONG4English_Uno_h
#define PONG4English_Uno_h
#define UNO_VERTEX_COUNT 4
#define UNO_INDEX_COUNT 6
float uno_vertices[4][3]=
{
	{5.0f,10.0f,1.0f},
	{5.0f,-10.0f,1.0f},
	{-5.0f,-10.0f,1.0f},
	{-5.0f,10.0f,1.0f}
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
float uno_coord[4][3]=
{
	//0.21875
	//0.21851563
	//0.0803125
	//-0.21484376
	//0,29515626
	{0.19628906,0.21484376,0},
	{0.19628906,0.29515626,0},
	{0.16015625,0.29515626,0},
	{0.16015625,0.21484376,0}
};
unsigned int uno_indices[6]=
{
	2,1,3,
	1,0,3
};


#endif
