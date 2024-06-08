extern number time;
extern vec2 resolution;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    // Example shader effect: simple color modulation
    vec2 uv = screen_coords / resolution;
    float wave = sin(uv.y * 10.0 + time) * 0.1;
    uv.x += wave;
    vec4 pixel = Texel(texture, uv);
    return pixel * color;
}
