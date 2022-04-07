## Detecting Slow Slip Events From Seafloor Pressure Data Using Machine Learning
A machine learning Detector to detect the Slow Slip Events(SSEs) in long-time seafloor pressure data

The detailed can be found in [paper](https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2020GL087579)
We improved the model by detecting both uplift and subsidence signals.


### Step01: Prepare the synthetic training dataset
Synthetic data includes noise, down/up ramp synthetic SSE, and linear instrumental drift. ![Figure](/Figures/FigS4.pdf)

### Step02: Train the machine learning model (SSE detector)
Training architecture ![architecture](/Figures/Figure2.pdf)

### Step03: Apply the detector to the real data
