# CAM Verification

This circuit is a read-only CAM that has the following behavior:
> Suppose that `trigger` is high at time `t` then at time `t+1`, hit is true if and only if at time `t`, we had `query` present in the CAM.