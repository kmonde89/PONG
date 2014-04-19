//
//  vertexShaderFlat.vs
//  PONG4English
//
//  Created by Kévin Mondésir on 02/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#version 150

in vec3 attribPosition;
in vec3 attribColor;
in vec3 attribNormal;


uniform mat4 cameraMatrix;
uniform mat4 projectionMatrix;
uniform vec3 moveIT;

flat out vec3 normal;
out vec3 eyePos;
out vec4 primaryColor;

void main() {
	//mat4 transform =cameraMatrix ;
	normal = attribNormal;
	eyePos = vec3(cameraMatrix * (vec4(attribPosition, 1.0)+vec4(moveIT,0.0)));
	gl_Position = projectionMatrix * vec4(eyePos, 1.0)*vec4(0.08,0.08,0.08,1.0);
    // color
	
	primaryColor = vec4(attribColor, 0.0);
}