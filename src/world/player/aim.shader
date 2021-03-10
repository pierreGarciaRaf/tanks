shader_type spatial;
render_mode blend_add,depth_draw_opaque,cull_back,unshaded;
uniform vec4 color : hint_color;
uniform float divider : hint_range(1,500);

void fragment(){
	ALPHA = color.a * max(0,fract(-divider * UV.y - TIME)-0.5);
	ALBEDO = color.rgb;
}