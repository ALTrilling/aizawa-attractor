import { default as gulls } from "./gulls/gulls.js";

const sg = await gulls.init();
const size = window.innerWidth * window.innerHeight
const NUM_PARTICLES = 1024*32;
const NUM_PROPERTIES = 3;

const state = new Float32Array(NUM_PARTICLES * NUM_PROPERTIES);

for(let i = 0; i < NUM_PARTICLES * NUM_PROPERTIES; i += NUM_PROPERTIES) {
  state[  i  ] = (Math.random() - 0.5) * 4;
  state[i + 1] = (Math.random() - 0.5) * 4;
  state[i + 2] = (Math.random() - 0.5) * 4;
}

const draw_shader = await gulls.import("./frag.wgsl");
const particle_shader = await gulls.import("./compute.wgsl");
const state_b = sg.buffer( state );
const frame_u = sg.uniform( 0 );
const res_u   = sg.uniform([ sg.width, sg.height ]);

const draw = await sg.render({
  shader: draw_shader,
  data: [frame_u, res_u, state_b],
  onframe() {frame_u.value++},
  count: NUM_PARTICLES,
  blend: false,
});

const dc = Math.ceil(NUM_PARTICLES / 64);

const particle = sg.compute({
  shader: particle_shader,
  data: [res_u, state_b],
  dispatchCount: [dc, dc, 1],
  times: 1,
});

sg.run(particle, draw);
