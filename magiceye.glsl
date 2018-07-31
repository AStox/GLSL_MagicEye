#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(1233.1,311.7)),dot(p,vec2(219.5,143.3))))*43258.5253);
}

float noise(vec2 st)
{
    vec2 i_st = floor(st);
    vec2 f_st = fract(st);

    float m_dist = 0.;
    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            // Neighbor place in the grid
            vec2 neighbor = vec2(float(x),float(y));

            // Random position from current + neighbor place in the grid
            vec2 point = random2(i_st + neighbor);

			// Animate the point
            point = 0.5 + 0.5*sin(8.211*point);

			// Vector between the pixel and the point
            vec2 diff = neighbor + point - f_st;

            // Distance to the point
            float dist = smoothstep(0.,1.,length(diff));

            m_dist += (dist);
            // Keep the closer distance
            // m_dist = min(m_dist, dist);
        }
    }
    st = gl_FragCoord.xy/u_resolution.xy;
    float cdist = smoothstep(0.1,0.9,length(st - vec2(0.5)))*5.;

    return (m_dist-6.3)/2.;
}

float circle(in vec2 _st, in float _radius, in vec2 center){
    vec2 dist = _st-center;
	return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(dist,dist)*4.0);
}

// vec3 draw3D(in vec2 st, float shape, float height){
//     vec3 color = vec3(0.);
//     color += vec3(circle(st,0.1,vec2(0.25,0.5)));
// 	color += vec3(circle(st,0.1,vec2(0.77,0.5)));
//     return color;
// }

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
    vec3 color = vec3(.0);
    
    vec3 color1 = vec3(0.);
    vec3 color2 = vec3(1.);

    float div = 1.;
    
    
    vec2 i = floor(st/vec2(1./(2.*div),1.));
    float even = step(1.,mod(i.x,2.));
    st = mod(st*vec2(2.*div,1.),1.) / vec2((div) , 1.) + (vec2(i.x-even,i.y))/(div*2.);
    
    vec2 scale = vec2(1.,2.);
    st *= scale;
    // st *= 2.;
    st -= vec2(0.,0.5);
    

    
    const int octaves = 3;
    float lacunarity = 2.1;
    float gain = 0.4;
    float amplitude = 0.5;
    float frequency = 1.;
	float y;

    // st = mod(st,vec2(scale/2.,scale));
    for (int i = 0; i < octaves; i++) {
        y += amplitude * noise(frequency*st*4.);
        frequency *= lacunarity;
        amplitude *= gain;
    }
    
	float shift = 0.;
    float height = 0.01;
    shift = circle(st,0.3,vec2(0.5+height,0.5));
    
    color1 = vec3(sin(y*234.))+shift;
    
    shift = circle(st,0.3,vec2(0.5-height,0.5));

    color2 = vec3(sin(y*234.))+shift;

    
//     st = gl_FragCoord.xy/u_resolution.xy;

    // float shift = 0.;
    // float height = 0.05;
    // shift = circle(st,0.1,vec2(0.25-height,0.5));
//     st = mod(st*scale,vec2(scale/2.,scale));
//     st += vec2(-height,0.);
//     amplitude = 0.5;
//     frequency = 1.;
// 	y = 0.;

//     for (int i = 0; i < octaves; i++) {
//         y += amplitude * noise(frequency*st);
//         frequency *= lacunarity;
//         amplitude *= gain;
//     }
//     color1 = vec3(sin(y*234.)) + shift;
    
    
    
    
    
    
    
//     st = gl_FragCoord.xy/u_resolution.xy;

//     shift = 0.;
//     shift += circle(st,0.1,vec2(0.75+height,0.5));
//     st = mod(st*scale,vec2(scale/2.,scale));
//     st += vec2(height,0.);
//     amplitude = 0.5;
//     frequency = 1.;
// 	y = 0.;

//     for (int i = 0; i < octaves; i++) {
//         y += amplitude * noise(frequency*st);
//         frequency *= lacunarity;
//         amplitude *= gain;
//     }
//     color2 = vec3(sin(y*234.)) * shift + color * (1.-shift);

    color = vec3(st,0.);
    color = step(1.,mod(i.x,2.))*color2 + (1.-step(1.,mod(i.x,2.)))*color1;
    // color = color1;
    gl_FragColor = vec4(color,1.0);
}
