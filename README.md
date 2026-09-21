# Genomic Signal Rescue (Terminal-Bench)

An AI agent evaluation environment designed to test advanced data rescue, algorithmic debugging, and memory management within a constrained Docker runtime.

## Objective
The base genomic clustering pipeline (`process_genomics.py`) is failing due to two primary issues:
1. **Out-Of-Memory (OOM) Kills:** The container operates under a strict 1.5GB memory limit, causing the standard Pandas/KMeans implementation to crash when processing the large sequence dataset.
2. **Signal Corruption:** The raw biological data is heavily corrupted by a low-frequency sensor drift artifact (a large-amplitude sine wave), which destroys spatial clustering accuracy.

The objective is to refactor the pipeline to execute entirely within the memory constraints and mathematically filter the systematic noise to recover the true biological signal.

## Solution Architecture
* **Memory Management:** Implemented memory-safe iterative chunking (`chunksize=150000`) using Pandas and NumPy to process the dataset without exceeding the 1.5GB threshold.
* **Digital Signal Processing (DSP):** Applied a SciPy Butterworth high-pass filter (1Hz cutoff) to eliminate the low-frequency sensor drift prior to KMeans clustering.
* **Evaluation Metric:** Refactored the testing rubric to utilize the Adjusted Rand Index (ARI). This evaluates the agent's output against a hidden ground truth file (`/app/hidden_ground_truth.csv`), ensuring grading is based on biological accuracy rather than physical spatial distance across noisy data.

## Repository Structure
* `docker-compose.yaml` / `Dockerfile`: Environment configuration enforcing the 1.5GB memory limit and generating the dynamic synthetic datasets on build.
* `process_genomics.py`: The failing baseline pipeline provided to the agent.
* `setup_data.py`: The synthetic genomic data generator.
* `tests/run-tests.sh`: The evaluation script utilizing ARI to score the agent's final output.
* `task.yaml` / `instruction.md`: Terminal-Bench metadata and prompt configurations.

## Usage
To initialize the sandbox and generate the datasets:
```bash
git clone [https://github.com/aansikkaw/genomic-signal-rescue.git](https://github.com/aansikkaw/genomic-signal-rescue.git)
cd genomic-signal-rescue
docker-compose build
docker-compose up -d
