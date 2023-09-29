# Stage 1: Build
FROM python:3.10.12-slim as builder

RUN apt update && \
    apt install --no-install-recommends -y build-essential gcc git

COPY requirements-min.txt /requirements.txt

RUN pip install --no-cache-dir --no-warn-script-location --user -r requirements.txt

# Stage 2: Runtime
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
ENV GRADIO_SERVER_NAME=0.0.0.0

RUN apt update && \
    apt install --no-install-recommends -y python3 python3-pip libgl1-mesa-glx libglib2.0-0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY models/ /models
COPY util/ /util
COPY backbone/ /backbone
COPY align/ /align
COPY app.py app.py

COPY --from=builder /root/.local/lib/python3.10/site-packages /root/.local/lib/python3.10/site-packages

CMD [ "python3" , "-u", "app.py" ]
EXPOSE 7860