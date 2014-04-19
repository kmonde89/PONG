//
//  Text.vs
//  PONG4English
//
//  Created by Kévin Mondésir on 02/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#version 150

in vec3 attribPosition;
in vec2 TextCoord;
uniform vec3	test;

uniform mat4 cameraMatrix;
uniform mat4 projectionMatrix;
uniform vec4 moveIT;

out vec2 Textcoord;

void main() {
	//mat4 transform =cameraMatrix ;
	vec3 eyePos;
	
		eyePos = vec3(cameraMatrix * (vec4(attribPosition, 1.0)+vec4(moveIT[1],moveIT[2],0.0,0.0))*vec4(moveIT[3],moveIT[3],1.0,1.0));
	
	
	gl_Position = projectionMatrix * vec4(eyePos, 1.0)*vec4(0.08,0.08,0.08,1.0);
    // color
	//int test=2;
	int pr=int(moveIT[0]);
	switch (pr) {
		case 0:
			Textcoord = TextCoord;
			break;
		case 1:
			Textcoord = TextCoord;
			
			break;
		case 2:
			Textcoord = TextCoord+vec2(0.080078125,0.0)-vec2(0.41992188,-0.080078125);
			break;
		case 3:
			Textcoord = TextCoord-vec2(0.41992188,-0.080078125);
			break;
		case 4:
			Textcoord = TextCoord+6*vec2(0.080078125,0.0);
			break;
		case 5:
			Textcoord = TextCoord+5*vec2(0.080078125,0.0);
			break;
		case 6:
			Textcoord = TextCoord+4*vec2(0.080078125,0.0);
			break;
		case 7:
			Textcoord = TextCoord+3*vec2(0.080078125,0.0);
			break;
		case 8:
			Textcoord = TextCoord+2*vec2(0.080078125,0.0);
			break;
		case 9:
			Textcoord = TextCoord+vec2(0.080078125,0.0);
			break;
		case 58:
			break;
		default:Textcoord = TextCoord;
			if (pr<100) {
				Textcoord = TextCoord+(99-pr)*vec2(0.080078125,0.0)-5*vec2(0,-0.080078125)-vec2(0.41992188,0.0);
			}
			else{
				if(pr<112)
				{
					Textcoord = TextCoord+(111-pr)*vec2(0.080078125,0.0)-4*vec2(0,-0.080078125)-vec2(0.41992188,0.0);

				}
				else{
					if(pr<123)
					{
						Textcoord = TextCoord+((123-pr)+(pr>113?1:0))*vec2(0.080078125,0.0)-3*vec2(0,-0.080078125)-vec2(0.41992188,0.0);
						
					}
				}
			}
			break;
	}
	
}