#!/bin/bash
# ============================================================
# 全部 Baseline 从头训练（无预训练）+ 测试集评估
# 日期: 2026-04-09
# 预计总耗时: ~3-5 小时
# ============================================================

set -e

OUTPUT_BASE="./output/baselines_scratch_v2"
EVAL_BASE="./output/eval_results"
SEED=42

MODELS=(
  fpn_mnv3s
  unet_mnv3s
  fpn_mv2
  deeplabv3p_mv2
  deeplabv3p_effb0
  unet_r18
  deeplabv3p_r18
  pspnet_r18
)

echo "======================================================"
echo "Scratch Baseline Training (${#MODELS[@]} models)"
echo "Output: $OUTPUT_BASE"
echo "Seed: $SEED"
echo "Start: $(date)"
echo "======================================================"

# ============================================================
# Training
# ============================================================
for MODEL in "${MODELS[@]}"; do
  echo ""
  echo "====== Training: $MODEL (scratch) ======"
  echo "Start: $(date)"

  python tools/train.py \
    --model "$MODEL" \
    --no_pretrain \
    --seed $SEED \
    --epochs 200 \
    --lr 6e-4 \
    --batch_size 8 \
    --early_stop_patience 30 \
    --output_dir "$OUTPUT_BASE"

  echo "$MODEL training done: $(date)"
done

echo ""
echo "======================================================"
echo "All training complete: $(date)"
echo "======================================================"

# ============================================================
# Test Evaluation
# ============================================================
echo ""
echo "====== Test Evaluation ======"

for MODEL in "${MODELS[@]}"; do
  # Find latest checkpoint
  CKPT=$(ls -t ${OUTPUT_BASE}/${MODEL}_*/best_model.pth 2>/dev/null | head -1)
  if [ -z "$CKPT" ]; then
    echo "WARNING: No checkpoint found for $MODEL, skipping eval"
    continue
  fi

  EVAL_DIR="${EVAL_BASE}/scratch_v2_${MODEL}"
  echo "Evaluating $MODEL: $CKPT -> $EVAL_DIR"

  python tools/eval.py \
    --model "$MODEL" \
    --checkpoint "$CKPT" \
    --split test \
    --output "$EVAL_DIR"

  echo "$MODEL eval done"
done

# ============================================================
# Summary
# ============================================================
echo ""
echo "======================================================"
echo "RESULTS SUMMARY"
echo "======================================================"
echo ""
printf "%-22s | %-12s | %-12s\n" "Model" "Val mIoU" "Test mIoU"
printf "%-22s-+-%-12s-+-%-12s\n" "----------------------" "------------" "------------"

for MODEL in "${MODELS[@]}"; do
  LOG=$(ls -t ${OUTPUT_BASE}/${MODEL}_*/train.log 2>/dev/null | head -1)
  VAL=$(grep "Done\." "$LOG" 2>/dev/null | grep -oP "mIoU: \K[0-9.]+" || echo "N/A")
  TEST_FILE="${EVAL_BASE}/scratch_v2_${MODEL}/test_metrics.txt"
  TEST=$(grep "mIoU:" "$TEST_FILE" 2>/dev/null | head -1 | awk '{print $2}' || echo "N/A")
  printf "%-22s | %-12s | %-12s\n" "$MODEL" "$VAL" "$TEST"
done

echo ""
echo "======================================================"
echo "ALL DONE: $(date)"
echo "======================================================"
