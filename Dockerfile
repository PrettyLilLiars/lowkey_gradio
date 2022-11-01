FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
EXPOSE 7860

ENV CONDA_DIR /opt/conda
RUN apt-get update && \
    apt-get install -y build-essential  && \
    apt-get install -y wget && \
    apt-get install -y libgl1-mesa-glx && \
    apt-get install -y libglib2.0-0 && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

ENV PATH=$CONDA_DIR/bin:$PATH

ENV GRADIO_SERVER_NAME=0.0.0.0
WORKDIR /workspace

ADD requirements.txt /workspace/requirements.txt
RUN pip install -r requirements.txt

COPY models/ /workspace/models
COPY util/ /workspace/util
COPY backbone/ /workspace/backbone
COPY align/ /workspace/align
ADD app.py /workspace/
CMD [ "python" , "/workspace/app.py" ]
