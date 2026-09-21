import pandas as pd
from sklearn.cluster import KMeans
import os

def main():
    input_path = '/workspace/raw_sequencer_output.csv'
    if not os.path.exists(input_path):
        raise FileNotFoundError(f"Missing input data at {input_path}")
        
    df = pd.read_csv(input_path)
    X = df[['signal_1', 'signal_2']]
    
    kmeans = KMeans(n_clusters=3, random_state=42)
    df['cluster_label'] = kmeans.fit_predict(X)
    
    output_path = '/workspace/final_clusters.csv'
    df.to_csv(output_path, index=False)

if __name__ == '__main__':
    main()
