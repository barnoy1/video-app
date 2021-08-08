#version 330 core
in vec2 TexCoords;
out vec4 color;

uniform sampler2D scene;
uniform mat4 brightnessMatrix; 
uniform float brightnessValue;

void main()
{ 
    color = vec4(0.0f);
    color = vec4(brightnessValue, brightnessValue, brightnessValue, 1.0f) * texture(scene, TexCoords);
}
