shader_type spatial;
varying vec3 world_position;


void vertex() {
	world_position = VERTEX;
}

const float gridSize = 3.5;

void fragment(){
	vec3 pos = world_position;
	pos /= gridSize;
	pos += gridSize * 20.0;
	float xGrid = fract(float(int(pos.x*2.0))/2.0);
	pos.y += 1.0*float(xGrid);
	float yGrid = fract(float(int(pos.y*2.0))/2.0);
	pos.z += float(yGrid);
	float zGrid = fract(float(int(pos.z*2.0))/2.0);
	vec3 col = vec3(zGrid);
	ROUGHNESS = zGrid/2.0 + 0.2;
	ALBEDO = col;
}