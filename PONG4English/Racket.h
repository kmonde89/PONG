//
//  Racket.h
//  PONG4English
//
//  Created by Kévin Mondésir on 02/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#ifndef PONG4English_Racket_h
#define PONG4English_Racket_h
#define RACKET_VERTEX_COUNT 4
#define RACKET_INDEX_COUNT	6
#define RACKET_SIZE 7.0f
float racket_vertices[4][3]=
{
	{1.0f,5.5f,1.0f},
	{1.0f,-5.5f,1.0f},
	{-1.0f,-5.5f,1.0f},
	{-1.0f,5.5f,1.0f}
};
//La racket est orange
float racket_colors[4][3]=
{
	{0.85098039,0.29411765,0.00000000},
	{0.85098039,0.29411765,0.00000000},
	{0.85098039,0.29411765,0.00000000},
	{0.85098039,0.29411765,0.00000000}
};
float	racket_normals[4][3]=
{
	{0.0f,0.0f,1.0f},
	{0.0f,0.0f,1.0f},
	{0.0f,0.0f,1.0f},
	{0.0f,0.0f,1.0f}
};
unsigned int racket_indices[6]=
{
	2,1,3,
	1,0,3
};

#endif
