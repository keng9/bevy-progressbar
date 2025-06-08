#import bevy_ui::ui_vertex_output::UiVertexOutput

// Maximum number of segments supported (WebGL uniform buffer limitation)
const MAX_SEGMENTS: u32 = 16u;

struct ProgressBarData {
    params: vec4<f32>, // x: progress, y: sections_count, z: unused, w: unused
    empty_color: vec4<f32>,
    sections_color: array<vec4<f32>, MAX_SEGMENTS>,
    sections_amount: array<vec4<f32>, MAX_SEGMENTS>,
}

@group(1) @binding(0)
var<uniform> data: ProgressBarData;

@fragment
fn fragment(
    mesh: UiVertexOutput,
) -> @location(0) vec4<f32> {
    let progress = data.params.x;
    let sections_count = u32(data.params.y);
    
    if progress < mesh.uv.x {
      return data.empty_color;
    }
    var current_amount: f32 = 0.0;
    for (var i = 0u; i < min(sections_count, MAX_SEGMENTS); i++) {
        current_amount += data.sections_amount[i].x * progress;
        if current_amount > mesh.uv.x {
            return data.sections_color[i];
        }
    }
    return data.empty_color;
}
