# Performance investigation report

All measurements below are intentionally unfilled. Correctness tests are not a performance trace.

- Device / OS / Xcode / commit:
- Build configuration and optimization:
- Fixture size: 4,000 tags; five samples per run
- Cold or warm / thermal state / run order:
- Recording tools and selected interval:

| Metric | Baseline raw samples | Candidate raw samples | Interpretation |
| --- | --- | --- | --- |
| BuildCounts elapsed ms | Not recorded | Not recorded | Same checksum required |
| Main-thread sampled work | Not recorded | Not recorded | Inspect the selected interval |
| Decoded preview dimensions | Not recorded | Not recorded | Same visible size/aspect ratio |
| Live memory after decode/release | Not recorded | Not recorded | Separate live, peak, and cumulative allocations |
| Session lifetime after Close | Not recorded | Not recorded | Trace ownership, not just a Leaks badge |

Hypothesis:

One change made:

Correctness evidence:

Measured result and variability:

Tradeoff / next investigation:

Screenshot placeholder: attach genuine trace captures here.
<!-- SCREENSHOT TODO: Replace with actual trace evidence; retain experiment conditions. -->
