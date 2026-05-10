# Data

This repository includes the datasets needed to run the main MoS2 segmentation experiments and the cross-material transfer-learning experiments.

## Included Data

### Main MoS2 Dataset

```text
Mos2_data/
├── ori/MoS2/      RGB optical images
├── mask/          Segmentation masks with class ids
└── label/         Annotation/source label files
```

The main training split files are stored in:

```text
splits/train.txt
splits/val.txt
splits/test.txt
```

The MoS2 class ids are:

```text
0 background
1 monolayer
2 fewlayer
3 multilayer
```

### Public Transfer Datasets

```text
other data/graphene/
other data/WS2_data/
```

These directories use the transfer-learning layout:

```text
dataset_root/
├── img_dir/
│   ├── train/
│   ├── val/
│   └── test/      optional for some datasets
└── ann_dir/
    ├── train/
    ├── val/
    └── test/      optional for some datasets
```

Graphene uses three classes:

```text
0 BG
1 1L
2 >1L
```

WS2 uses four classes:

```text
0 BG
1 1L
2 FL
3 ML
```

### External MoS2 Transfer Dataset

```text
other_datav2_prepared/
├── img_dir/
│   ├── train/
│   ├── val/
│   └── test/
├── ann_dir/
│   ├── train/
│   ├── val/
│   └── test/
├── train.txt
├── val.txt
└── test.txt
```

This dataset uses the same four-class label space as the main MoS2 task.

### Supplementary Transfer Datasets

```text
supplementary_prepared/WS2_supp/
supplementary_prepared/Gr_supp/
```

These directories are prepared inputs for transfer-learning experiments:

- `WS2_supp`: supplementary WS2 split.
- `Gr_supp`: supplementary Graphene split.

They follow the same `img_dir/{train,val,test}` and `ann_dir/{train,val,test}` structure used by `transfer/material_dataset.py`.



## Data License And Redistribution

Before making the repository public, verify that all image and annotation files included here can be redistributed under your intended data terms. If the dataset license differs from the code license, add the exact dataset license text or citation files in the corresponding dataset directories.

The MIT license in `LICENSE` applies to source code and documentation unless otherwise stated. Dataset files should be treated according to this document and any per-dataset notices you add before release.
