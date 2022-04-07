## Detecting Slow Slip Events From Seafloor Pressure Data Using Machine Learning
A machine learning Detector to detect the Slow Slip Events(SSEs) in long-time seafloor pressure data

The detailed can be found in [paper](https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2020GL087579)

We improved the model by detecting both uplift and subsidence signals.


### Step01: Prepare the synthetic training dataset
Synthetic data includes noise, down/up ramp synthetic SSE, and linear instrumental drift. ![Figure](/Figures/Synthetic_data.png)
<center><img src=/Figures/Synthetic_data.png width="700" height="800"></center>


### Step02: Train the machine learning model (SSE detector)
Training architecture ![architecture](/Figures/Architecture.png)

### Step03: Apply the detector to the real data
