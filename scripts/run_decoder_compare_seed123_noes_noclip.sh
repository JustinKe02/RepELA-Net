#!/bin/bash
# Decoder comparison aligned to the seed_123 main-model training recipe:
# seed=123, no early stopping, no gradient clipping.

set -e

cd /root/autodl-tmp/PhysicalNet

export PYTHONHASHSEED=0
export CUBLAS_WORKSPACE_CONFIG=:4096:8

OUT_DIR="output/decoder_compare_seed123_noes_noclip"
EVAL_DIR="output/eval_results_seed123_noes_noclip"
DECODERS=("fpn" "aspp" "segformer" "ppm" "hamburger" "ours")

mkdir -p "$OUT_DIR" "$EVAL_DIR"

for dec in "${DECODERS[@]}"; do
    echo ""
    echo "================================================================"
    echo "  Training decoder: $dec"
    echo "  $(date)"
    echo "================================================================"
    echo ""
    python tools/train_decoder_compare.py \
        --decoder "$dec" \
        --data-root Mos2_data \
        --split-dir splits \
        --output-dir "$OUT_DIR" \
        --epochs 200 \
        --batch-size 8 \
        --lr 6e-4 \
        --crop-size 512 \
        --seed 123 \
        --early-stop-patience 0 \
        --grad-clip 0
done

python scripts/eval_decoder_compare_preds.py \
    --decoders "${DECODERS[@]}" \
    --split test \
    --data-root Mos2_data \
    --split-dir splits \
    --crop-size 512 \
    --stride 384 \
    --checkpoint-root "$OUT_DIR" \
    --output-root "$EVAL_DIR"

echo ""
echo "Decoder comparison seed123/no-early-stop/no-clip complete!"
echo "$(date)"
