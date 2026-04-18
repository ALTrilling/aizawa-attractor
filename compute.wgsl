struct Particle {
  pos: vec3f,
};

@group(0) @binding(0) var<uniform> res: vec2f;
@group(0) @binding(1) var<storage, read_write> state: array<Particle>;

fn cellindex(cell: vec3u) -> u32 {
  let size = 8u;
  return cell.x + (cell.y * size) + (cell.z * size * size);
}

const A: f32 = 0.95;
const B: f32 = 0.7;
const C: f32 = 0.6;
const D: f32 = 3.5;
const E: f32 = 0.25;
const F: f32 = 0.1;

const DT: f32 = 0.001;

@compute
@workgroup_size(8,8)
fn cs(@builtin(global_invocation_id) cell: vec3u) {
  let i = cellindex(cell);
  let p = state[i];

  let x = p.pos.x;
  let y = p.pos.y;
  let z = p.pos.z;

  let dx = (z - B) * x - D * y;
  let dy = D * x + (z - B) * y;
  let dz = C + A * z - (z * z * z) / 3.0 - (x * x + y * y) * (1.0 + E * z) + F * z * x * x * x;

  let nx = x + dx * DT;
  let ny = y + dy * DT;
  let nz = z + dz * DT;

  state[i].pos = vec3f(nx, ny, nz);
}
