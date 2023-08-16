shader_type canvas_item;

uniform float tilt = 10;
uniform float hp = 100;

void vertex() { 
    VERTEX.x -= (UV.y)*tilt; //moves vertices based on their y position. If you'd like to reverse this, you can use 1.0-UV.y instead. 
}
void fragment() { 
    if(UV.x > hp/100.0) { //UV.x is a value from 0 to 1, depending on where the pixel is in the thing that's getting rendered. UV.x for the middle pixel would be 0.5 for example.
        COLOR = vec4(0.0); //sets the color to completely transparent 
    } 
}
