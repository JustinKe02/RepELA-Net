# RepELA-Net

RepELA-Net is a lightweight semantic segmentation project for optical images of two-dimensional materials. It includes the RepELA-Net model, training and evaluation scripts, baseline comparisons, transfer-learning utilities, and the datasets used for the main and transfer experiments.

## Repository Layout

```text
models/                  Model definitions for RepELA-Net and decoder variants
datasets/                MoS2 dataset loader
utils/                   Losses and segmentation metrics
tools/                   Training, evaluation, inference, benchmarking, visualization
transfer/                Cross-material fine-tuning and inference utilities
scripts/                 Experiment, plotting, data-preparation, and batch-run scripts
splits/                  Main MoS2 train/val/test split files

Mos2_data/               Main MoS2 segmentation dataset
other data/              Public transfer datasets: Graphene and WS2
other_datav2_prepared/   Prepared external MoS2 transfer dataset
supplementary_prepared/  Prepared supplementary transfer datasets
transfer_train/          Small transfer-learning result summaries and figures
```

Large generated artifacts, checkpoints, logs, caches, and intermediate datasets are intentionally excluded from the public release.

## Installation

Create a Python environment and install the dependencies:

```bash
pip install -r requirements.txt
```

The project is developed for Python 3.10+ and PyTorch. Install the PyTorch build that matches your CUDA version if GPU training is required.

## Data

The repository expects the main dataset at:

```text
Mos2_data/
```

Transfer-learning datasets are expected at:

```text
other data/graphene/
other data/WS2_data/
other_datav2_prepared/
supplementary_prepared/WS2_supp/
supplementary_prepared/Gr_supp/
```

See `DATA.md` for the full data layout and release notes.

## Training

Train the main RepELA-Net model on the MoS2 dataset:

```bash
python tools/train.py --model repela_small --data_root Mos2_data --split_dir splits
```

Train a baseline model:

```bash
python tools/train.py --model unet_r18 --data_root Mos2_data --split_dir splits
```

Train all configured baseline models:

```bash
python tools/train.py --model all_baselines --data_root Mos2_data --split_dir splits
```

## Evaluation

Evaluate a trained checkpoint on the test split:

```bash
python tools/eval.py \
  --model repela_small \
  --checkpoint path/to/best_model.pth \
  --data_root Mos2_data \
  --split test
```

Run inference on a split:

```bash
python tools/inference.py \
  --checkpoint path/to/best_model.pth \
  --data_root Mos2_data \
  --split test
```

## Transfer Learning

Fine-tune from a pretrained MoS2 checkpoint on Graphene:

```bash
python transfer/finetune.py \
  --data_root "other data/graphene" \
  --pretrained path/to/best_model.pth \
  --num_classes 3 \
  --name graphene_ft
```

Fine-tune on WS2:

```bash
python transfer/finetune.py \
  --data_root "other data/WS2_data" \
  --pretrained path/to/best_model.pth \
  --num_classes 4 \
  --name ws2_ft
```

The shell scripts in `scripts/` reproduce the experiment groups used during development.

## Notes For Reproducibility

- Checkpoints are not included in the repository. Train locally or provide pretrained weights separately.
- Several plotting and batch-run scripts may need path cleanup if you run them outside the repository root.
- Dataset and result files included in this release are intended to support reproduction of the reported experiments.

## License

Source code and documentation are released under the MIT License. Dataset files are documented separately in `DATA.md`; verify redistribution and usage terms before public release.
