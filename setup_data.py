import numpy as np
import pandas as pd
import os

def create_synthetic_data(filepath, rows=500_000):
    np.random.seed(42)
    time = np.linspace(0, 1000, rows)
    centers = [[2.0, 2.0], [8.0, 8.0], [2.0, 8.0]]
    cluster_assignments = np.random.randint(0, 3, rows)
    
    signal_1, signal_2 = np.zeros(rows), np.zeros(rows)
    for i in range(3):
        mask = cluster_assignments == i
        signal_1[mask] = np.random.normal(centers[i][0], 1.0, np.sum(mask))
        signal_2[mask] = np.random.normal(centers[i][1], 1.0, np.sum(mask))
        
    drift = 5.0 * np.sin(2 * np.pi * 0.1 * time)
    signal_1 += drift
    signal_2 += drift
    
    gene_ids = [f"GENE_{i:08d}" for i in range(rows)]
    
    df = pd.DataFrame({'gene_id': gene_ids, 'time': time, 'signal_1': signal_1, 'signal_2': signal_2})
    df.to_csv(filepath, index=False)
    
    truth_df = pd.DataFrame({'gene_id': gene_ids, 'true_label': cluster_assignments})
    truth_df.to_csv('hidden_ground_truth.csv', index=False)

if __name__ == "__main__":
    create_synthetic_data("raw_sequencer_output.csv")
