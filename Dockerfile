# Base system is the Raspian ARM image from Resin
FROM   resin/rpi-raspbian

RUN [ "cross-build-start" ]

# Default port of UrBackup server
EXPOSE 55413
EXPOSE 55414
EXPOSE 55415
EXPOSE 35623

# Make sure we don't get notifications we can't answer during building.
ENV    DEBIAN_FRONTEND noninteractive

# Prepare UrBackup dependencies
RUN apt-get update && \
    apt-get install -y  wget \
                        lsb-release \
                        sqlite3 \
                        libcurl3 \
                        libfuse2 && \
    rm -rf /var/lib/apt/lists/*

# Download UrBasckup package and install
RUN wget https://www.urbackup.org/downloads/Server/2.3.7/urbackup-server_2.3.7_armhf.deb -O download && \
    dpkg -i download && \
    rm download

# Mount root folder for backups
VOLUME /media/BACKUP/

# Mount folder for log file
VOLUME /var/log/

# Mount config folder. If empty, default files will be created.
# Keeping this folder separate allows to migrate the server with complaints by the clients
VOLUME /var/urbackup/

# If set up, used for backup temp files
VOLUME /tmp/

# Default port of UrBackup server
EXPOSE 55413
EXPOSE 55414
EXPOSE 55415
EXPOSE 35623

ENTRYPOINT ["/usr/bin/urbackupsrv"]

# Default operation is run, adding -u root solves permission issues with mounted volumes
CMD ["run", "-u root"]

RUN [ "cross-build-end" ]
