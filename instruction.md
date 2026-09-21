You are an AI tasked with rescuing a biological data processing pipeline. In the `/workspace` directory, you will find a script named `process_genomics.py` and a dataset `raw_sequencer_output.csv`. 

The pipeline is currently failing to produce accurate biological clusters. Your objective is to modify the pipeline so that it successfully outputs a cleaned, clustered dataset to `/workspace/final_clusters.csv`. 

**Requirements:**
1. The container operates under a strict 1.5GB memory limit. The pipeline must execute from start to finish without triggering an Out-Of-Memory (OOM) kill. 
2. The raw biological signal is corrupted by a low-frequency sensor drift artifact. You must explore the data, identify this systematic noise, and mathematically filter it out prior to the clustering step.
3. The final output must be exactly formatted as a two-column CSV (`gene_id`, `cluster_label`). 
4. The clustering accuracy must be high enough to prove the underlying biological signal was successfully isolated from the artifact. 

You may install any necessary Python libraries and modify the code as needed. Do not change the final output path.
