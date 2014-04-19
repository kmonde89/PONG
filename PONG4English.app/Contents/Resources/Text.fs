//
//  Text.fs
//  PONG4English
//
//  Created by Kévin Mondésir on 02/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//
#version 150


in vec2 Textcoord;
uniform vec3 TextColor;
uniform vec3 moveIT;
out vec4 fragColor;
uniform sampler2D myTextTexture;
void main() {
	fragColor= vec4(TextColor,1.0)*texture( myTextTexture, Textcoord ).rgba;
	//fragColor=vec4(1.0,1.0,1.0,1.0);
	//fragColor=texture( myTextTexture, Textcoord ).rgba;
}