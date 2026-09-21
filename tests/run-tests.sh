#!/bin/bash
if [ ! -f "/workspace/final_clusters.csv" ]; then
    echo "FAIL: final_clusters.csv not found. Did the pipeline OOM?"
    exit 1
fi

python3 - << 'PY_EOF'
import pandas as pd
import sys
from sklearn.metrics import adjusted_rand_score

def main():
    try:
        df = pd.read_csv('/workspace/final_clusters.csv')
    except Exception as e:
        print(f"FAIL: Could not read final_clusters.csv - {e}")
        sys.exit(1)

    expected_columns = ['gene_id', 'cluster_label']
    if list(df.columns) != expected_columns:
        print(f"FAIL: Incorrect schema.")
        sys.exit(1)

    try:
        truth_df = pd.read_csv('/app/hidden_ground_truth.csv')
    except Exception as e:
        print(f"FAIL: hidden_ground_truth.csv missing - {e}")
        sys.exit(1)

    eval_df = truth_df.merge(df, on='gene_id', how='inner')
    score = adjusted_rand_score(eval_df['true_label'], eval_df['cluster_label'])

    if score < 0.75:
        print(f"FAIL: Clustering accuracy below 0.75 (Score: {score:.3f}).")
        sys.exit(1)
    
    print("PASS: Biological signal successfully rescued and clustered.")
    sys.exit(0)

if __name__ == "__main__":
    main()
PY_EOF
