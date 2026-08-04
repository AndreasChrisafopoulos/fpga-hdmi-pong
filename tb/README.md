# Testbenches

The repository includes self-checking behavioral testbenches for two critical HDMI pipeline blocks.

## TMDS encoder

`tmds_encoder_tb.v` verifies `rtl/tmds/tmds_encoder.v` against:

- 999 reference data vectors
- all four TMDS control symbols
- running-disparity behavior across multiple vector sequences

### Vivado setup

Add as **Simulation Sources**:

- `tb/tmds_encoder_tb.v`
- `tb/tmds_vectors.v`

Add as **Design Sources**:

- `rtl/tmds/tm_choice.v`
- `rtl/tmds/tmds_encoder.v`

Set `tmds_encoder_tb` as the simulation top and run behavioral simulation. A successful run ends with:

```text
TMDS ENCODER TEST: PASS
```

## Video timing

`video_timing_tb.v` verifies `rtl/video/video_timing_FSMs.v` over two complete 640x480 frames. It checks:

- 800 pixel clocks per line
- 525 lines per frame
- the 640x480 active-video region
- the 96-clock HSYNC interval
- the two-line VSYNC interval
- horizontal and vertical counter wraparound
- exactly one `new_frame` pulse per frame

### Vivado setup

Add as a **Simulation Source**:

- `tb/video_timing_tb.v`

Add as a **Design Source**:

- `rtl/video/video_timing_FSMs.v`

Set `video_timing_tb` as the simulation top and run behavioral simulation. A successful run ends with:

```text
VIDEO TIMING TEST: PASS
```
