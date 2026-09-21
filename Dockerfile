FROM python:3.10-slim
RUN pip install pandas numpy scikit-learn scipy
RUN mkdir /app && mkdir /workspace
WORKDIR /app
COPY setup_data.py /app/setup_data.py
COPY process_genomics.py /workspace/process_genomics.py
RUN python /app/setup_data.py
RUN rm /app/setup_data.py
CMD mv /app/raw_sequencer_output.csv /workspace/raw_sequencer_output.csv && tail -f /dev/null
