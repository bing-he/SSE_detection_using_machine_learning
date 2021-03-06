## Detecting Slow Slip Events From Seafloor Pressure Data Using Machine Learning
A machine learning Detector to automatically detect the Slow Slip Events(SSEs) in long-time seafloor pressure data.

https://user-images.githubusercontent.com/41640721/165691085-bf577f0e-5c08-4dc1-ac02-2e62a2a7ec25.mp4

The detailed can be found in [paper](https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2020GL087579). I later improved the model by detecting both uplift and subsidence signals.

### Step01: Prepare the synthetic training dataset
Synthetic data includes noise, down/up ramp synthetic SSE, and linear instrumental drift. 
<center><img src=/Figures/Synthetic_data.png width="600" height="700"/></center>

### Step02: Train the machine learning model (SSE detector)
<center><img src=/Figures/Architecture.png width="700" height="700"/></center>

### Step03: Apply the detector to the real data
