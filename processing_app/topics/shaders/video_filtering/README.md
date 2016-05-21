### Experiment with different edge-detection algorithms

By modifying the filter #defines (this can't be done dynamically so just edit the filter), although I have an idea for using a erb template to make this easier... 

Modify `edge_detect.glsl` directly to use these alternative defines included in the shader.

In the provided example the the `EDGE_FUNC` is
`#define EDGE_FUNC edge`

Alternatives are `colorEdge, trueColorEdge`

In the provided example the sketch uses a sobel filter algorithm

`#define SOBEL`

Alternatives are `KAYYALI_NESW, KAYYALI_SENW, PREWITT, ROBERTSCROSS, SCHARR`

Another tunable option to experiment with is `SCHARR`, that defaults to `1.0` for STEP but if `#define SCHARR` sets step at `0.15`
