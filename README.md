# For Your Eyes Only

This repository contains the MATLAB code to reproduce the neural-network localization results from:

**"For Your Eyes Only: Bridging Privacy and Sensing in Wi-Fi Networks Through CSI Obfuscation"**  
Giovanni Angelo Alghisi, Francesco Gringoli, Marco Cominelli, Shabbir Raza, Renato Lo Cigno  
(*to appear in IEEE MedComNet 2025*)

[Download the paper from here](https://doi.org/10.1109/MedComNet65822.2025.11103523)

## Requirements

- MATLAB
- Deep Learning Toolbox  
- (Optional) Parallel Computing Toolbox (you can train multiple networks in parallel, e.g. with `parfor`, significantly reducing overall training time)

## Dataset

You can download the dataset from Zenodo using the link below:

[Download the dataset from here](https://doi.org/10.5281/zenodo.15304711)

The dataset contains:
- **Raw CSI samples** as collected during experiments,
- **Processed datasets** organized for training neural networks and performing localization analysis.


### Single-step localization script

We've provided a one-shot MATLAB example, `localizationExample.m`, that loads a processed dataset, trains the neural network across all antennas, and evaluates the per-antenna accuracy for “clear”, “masked” and “unmasked” cases.


## Citation

If you use our dataset or code in your research, please cite our paper:

```bibtex
@INPROCEEDINGS{alghisi2025foryoureyesonly,
AUTHOR="Giovanni Angelo Alghisi and Francesco Gringoli and Marco Cominelli and
Shabbir Raza and Renato {Lo Cigno}",
TITLE="For Your Eyes Only: Bridging Privacy and Sensing in {Wi-Fi} Networks Through {CSI} Obfuscation",
BOOKTITLE="2025 23rd Mediterranean Communication and Computer Networking Conference (MedComNet) (MedComNet 2025)",
ADDRESS="Cagliari, Italy",
PAGES="5.98",
DAYS=24,
MONTH=jun,
YEAR=2025,
}
```
