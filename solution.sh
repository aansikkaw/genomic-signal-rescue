#!/bin/bash
pip install pandas scipy scikit-learn numpy

cat << 'INNER_EOF' > /workspace/process_genomics.py
import pandas as pd
import numpy as np
from scipy.signal import butter, filtfilt
from sklearn.cluster import KMeans

def butter_highpass_filter(data, cutoff, fs, order=5):
    nyq = 0.5 * fs
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='high', analog=False)
    return filtfilt(b, a, data)

def main():
    chunk_size = 150000 
    file_path = '/workspace/raw_sequencer_output.csv'
    fs = 100.0
    cutoff = 1.0
    filtered_data = []
    gene_ids = []
    
    for chunk in pd.read_csv(file_path, chunksize=chunk_size):
        s1, s2 = chunk['signal_1'].values, chunk['signal_2'].values
        s1_clean = butter_highpass_filter(s1, cutoff, fs)
        s2_clean = butter_highpass_filter(s2, cutoff, fs)
        filtered_data.append(np.column_stack((s1_clean, s2_clean)))
        gene_ids.extend(chunk['gene_id'].tolist())

    X = np.vstack(filtered_data)
    kmeans = KMeans(n_clusters=3, random_state=42, n_init=10)
    labels = kmeans.fit_predict(X)
    
    output_df = pd.DataFrame({'gene_id': gene_ids, 'cluster_label': labels})
    output_df.to_csv('/workspace/final_clusters.csv', index=False)

if __name__ == '__main__':
    main()
INNER_EOF

python3 /workspace/process_genomics.py
