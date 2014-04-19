#version 150


flat in vec3 normal;
in vec3 eyePos;
//color donnee par l'utilisateur
in vec4 primaryColor;
//enlever les light
uniform vec3 lightPos;
uniform vec3 lightColor;
out vec4 fragColor;
uniform sampler2D myTextureSampler;
uniform sampler2D myTextureSamplerText;
void main() {
	vec3 view = normal-eyePos;
	fragColor = primaryColor + vec4(min( 32.0+lightColor, 1.0), 0);
	
		fragColor= vec4(lightColor,1.0)*texture( myTextureSampler, vec2(primaryColor[0],primaryColor[1]) ).rgba;
	
	
}