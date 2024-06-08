extern vec2 resolution;
extern float time;
const float noiseIntensity = 0.1;
const float vignetteIntensity = 0.4;
const float vignetteSoftness = 0.5;

float random(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec4 effect(vec4 color, Image texture, vec2 texcoord, vec2 screen_coords) {
    vec4 fragColor = Texel(texture, texcoord);

    // Apply noise
    float noise = random(texcoord * time) * noiseIntensity;

    // Vignette effect
    vec2 position = (texcoord - 0.5) * resolution;
    float vignette = 1.0 - vignetteIntensity * length(position) / (resolution.x * vignetteSoftness);
    vignette = clamp(vignette, 0.0, 1.0);

    // Apply chromatic aberration
    vec2 offset = vec2(0.005, 0.0);
    vec4 colR = Texel(texture, texcoord + offset * random(texcoord * time));
    vec4 colG = Texel(texture, texcoord);
    vec4 colB = Texel(texture, texcoord - offset * random(texcoord * time));

    vec3 col = vec3(colR.r, colG.g, colB.b);
    col = col * vignette + noise;

    return vec4(col, fragColor.a) * color;
}
