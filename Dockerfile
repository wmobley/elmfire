FROM  ubuntu:noble-20250127

RUN apt-get update && \
apt-get -y install sudo

RUN sudo apt-get install -y bc csvkit gdal-bin gfortran git jq libopenmpi-dev \
openmpi-bin pigz python3 python3-pip unzip wget zip 

RUN sudo pip3 install google-api-python-client grpcio grpcio-tools python-dateutil \
--break-system-packages

RUN git clone --branch 2025.0212 --single-branch https://github.com/lautenberger/elmfire.git

COPY run.sh /bin/run.sh

RUN chmod +x /bin/run.sh

ENTRYPOINT [ "run.sh" ]
