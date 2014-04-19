#version 150


flat in vec3 normal;
in vec3 eyePos;
//color donnee par l'utilisateur
in vec4 primaryColor;
//enlever les light
uniform vec3 lightPos;
uniform vec3 lightColor;
//layout(pixel_center_integer) in vec4 gl_FragCoord;
//uniform sampler2D backbuffer;
out vec4 fragColor;
uniform sampler2D myTextureSampler;
uniform sampler2D myTextureSamplerText;
void main() {
	vec3 view = normal-eyePos;
	//vec3 L = normalize(lightPos-eyePos);
	//float attenuation = min(0.0, dot(normal, L));
	//vec3 reflectvec = normalize(reflect(-L, normal));
	//float spec = max(dot(reflectvec, view),0.0);
	//fragColor = primaryColor + vec4(min(pow(spec, 32.0)+attenuation*lightColor, 1.0), 1);
	fragColor = primaryColor + vec4(min( 32.0+lightColor, 1.0), 0);
	//fragColor=primaryColor;
	//gl_BackColor=vec4(0,0,0,0);
	/*
	if((primaryColor[0]-0.5)*(primaryColor[0]-0.5)+(primaryColor[1]-0.5)*(primaryColor[1]-0.5)>0.24)
	{
		ivec2 screenpos = ivec2(gl_FragCoord.xy);
		// look up result from previous render pass in the texture
		//vec4 color = texelFetch(mytex, screenpos, 0);
		fragColor=vec4(0.4,0.4,0.4,0);
		//fragColor=texture(backbuffer, screenpos).rgba;
	}
	else{*/
	
		fragColor= vec4(lightColor,1.0)*texture( myTextureSampler, vec2(primaryColor[0],primaryColor[1]) ).rgba;
	
	
	//}
}