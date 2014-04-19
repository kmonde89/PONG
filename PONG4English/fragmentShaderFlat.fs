/*#version 150


flat in vec3 normal;
in vec3 eyePos;
in vec4 primaryColor;

uniform vec3 lightPos;
uniform vec3 lightColor;

out vec4 fragColor;

void main() {
	vec3 view = normalize(-eyePos);
	vec3 L = normalize(lightPos-eyePos);
	float attenuation = min(0.0, dot(normal, L));
	vec3 reflectvec = normalize(reflect(-L, normal));
	float spec = max(dot(reflectvec, view),0.0);
	fragColor = primaryColor + vec4(min(pow(spec, 32.0)+attenuation*lightColor, 1.0), 1);
	fragColor=primaryColor;
}*/
#version 150


flat in vec3 normal;
in vec3 eyePos;
//color donnee par l'utilisateur
in vec4 primaryColor;
//enlever les light
uniform vec3 lightPos;
uniform vec3 lightColor;

out vec4 fragColor;

void main() {
	vec3 view = normal-eyePos;
	//vec3 L = normalize(lightPos-eyePos);
	//float attenuation = min(0.0, dot(normal, L));
	//vec3 reflectvec = normalize(reflect(-L, normal));
	//float spec = max(dot(reflectvec, view),0.0);
	//fragColor = primaryColor + vec4(min(pow(spec, 32.0)+attenuation*lightColor, 1.0), 1);
	fragColor = primaryColor + vec4(min( 32.0+lightColor, 1.0), 1);
	fragColor=primaryColor;
}