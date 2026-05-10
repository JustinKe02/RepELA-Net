"""
Prepare supplementary data splits for transfer experiments.
Creates train/val/test directory structures for WS2_supp and Gr_supp.
"""
import os, glob, shutil, random
import numpy as np
from pathlib import Path

BASE = '/root/autodl-tmp/PhysicalNet'
SUPP = os.path.join(BASE, 'supplementary_data')
PREP = os.path.join(BASE, 'supplementary_prepared')
SEED = 42


def split_dataset(names, ratios=(0.70, 0.15, 0.15)):
    """Split list into train/val/test."""
    random.seed(SEED)
    random.shuffle(names)
    n = len(names)
    n_train = int(n * ratios[0])
    n_val = int(n * ratios[1])
    return names[:n_train], names[n_train:n_train+n_val], names[n_train+n_val:]


def copy_files(names, src_img_dir, src_mask_dir, dst_img_dir, dst_mask_dir):
    """Copy images and masks for a list of basenames."""
    os.makedirs(dst_img_dir, exist_ok=True)
    os.makedirs(dst_mask_dir, exist_ok=True)
    for name in names:
        # Image (from ori_jpg)
        src_img = os.path.join(src_img_dir, name + '.jpg')
        if os.path.exists(src_img):
            shutil.copy2(src_img, os.path.join(dst_img_dir, name + '.jpg'))
        # Mask
        src_mask = os.path.join(src_mask_dir, name + '.png')
        if os.path.exists(src_mask):
            shutil.copy2(src_mask, os.path.join(dst_mask_dir, name + '.png'))


def prepare_supp_dataset(material, supp_subdir, out_name):
    """Prepare one supplementary dataset with train/val/test splits."""
    src_img = os.path.join(SUPP, supp_subdir, 'ori_jpg')
    src_mask = os.path.join(SUPP, supp_subdir, 'mask')

    # Get all basenames
    masks = sorted(glob.glob(os.path.join(src_mask, '*.png')))
    names = [Path(m).stem for m in masks]

    train, val, test = split_dataset(names)
    out_dir = os.path.join(PREP, out_name)

    print(f'\n{"="*60}')
    print(f'  {out_name}: {len(names)} images → train={len(train)}, val={len(val)}, test={len(test)}')
    print(f'  Output: {out_dir}')
    print(f'{"="*60}')

    for split_name, split_list in [('train', train), ('val', val), ('test', test)]:
        copy_files(split_list,
                   src_img, src_mask,
                   os.path.join(out_dir, 'img_dir', split_name),
                   os.path.join(out_dir, 'ann_dir', split_name))
        print(f'  {split_name}: {len(split_list)} files copied')

    return train, val, test


if __name__ == '__main__':
    # Supplementary datasets
    prepare_supp_dataset('WS2', 'WS2', 'WS2_supp')
    prepare_supp_dataset('Gr', 'Gr', 'Gr_supp')

    # Summary
    print(f'\n{"="*60}')
    print('  Summary')
    print(f'{"="*60}')
    for d in ['WS2_supp', 'Gr_supp']:
        for split in ['train', 'val', 'test']:
            p = os.path.join(PREP, d, 'img_dir', split)
            n = len(os.listdir(p)) if os.path.exists(p) else 0
            print(f'  {d}/{split}: {n}')
    print('\n✅ All data prepared!')
