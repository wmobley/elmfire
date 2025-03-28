FROM debian:bullseye-slim
RUN sudo apt-get update && sudo apt-get upgrade -y 

RUN sudo apt-get install -y bc csvkit gdal-bin gfortran git jq libopenmpi-dev \
openmpi-bin pigz python3 python3-pip unzip wget zip

RUN sudo pip3 install google-api-python-client grpcio grpcio-tools python-dateutil \
                  --break-system-packages

RUN git clone https://github.com/lautenberger/elmfire.git
COPY run.sh /bin/run.sh

RUN chmod +x /bin/run.sh

ENTRYPOINT [ "run.sh" ]
