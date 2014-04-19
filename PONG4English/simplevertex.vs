#version 150

in vec3 attribPosition;
in vec4 colorSet;


uniform mat4 cameraMatrix;
uniform mat4 projectionMatrix;

out vec4 primaryColor;

void main() {
	gl_Position = projectionMatrix * vec4(vec3(cameraMatrix * vec4(attribPosition, 1.0)), 1.0)*vec4(0.08,0.08,0.08,1.0);
	primaryColor = colorSet;
}