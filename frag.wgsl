struct VertexInput {
  @location(0) pos: vec2f,
  @builtin(instance_index) instance: u32,
};

struct Particle {
  pos: vec3f,
};

@group(0) @binding(0) var<uniform> frame: f32;
@group(0) @binding(1) var<uniform> res:   vec2f;
@group(0) @binding(2) var<storage> state: array<Particle>;

const domain_scale: f32 = 0.5;

@vertex 
fn vs( input: VertexInput ) ->  @builtin(position) vec4f {
  let size = input.pos * 0.005;
  let aspect = res.y / res.x;
  let p = state[input.instance];
  let scaled_pos = vec3f(p.pos.x * domain_scale, p.pos.y + 2.0, p.pos.z * domain_scale - 0.5);
  return vec4f(
        scaled_pos.z * (1/scaled_pos.y) - size.x * aspect * (1/scaled_pos.y), 
  		scaled_pos.x * (1/scaled_pos.y) + size.y * (1/scaled_pos.y), 0.0, 1.0); 
}

@fragment 
fn fs( @builtin(position) pos : vec4f ) -> @location(0) vec4f {
  let blue = 0.5 + sin(frame / 60.0) * 0.5;
  return vec4f(pos.x / res.x,
               pos.y / res.y,
               blue,
               1.0
               );
}
