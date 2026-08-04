# TMDS encoder testbench

This self-checking testbench verifies `rtl/tmds/tmds_encoder.v` against 999 reference data vectors and all four TMDS control symbols.

## Vivado simulation

Add the following files as **Simulation Sources**:

- `tb/tmds_encoder_tb.v`
- `tb/tmds_vectors.v`

Add the following files as **Design Sources**:

- `rtl/tmds/tm_choice.v`
- `rtl/tmds/tmds_encoder.v`

Set `tmds_encoder_tb` as the simulation top and run behavioral simulation. A successful run ends with:

```text
TMDS ENCODER TEST: PASS
```
