FROM archlinux

RUN pacman -Syy --noconfirm && \
    pacman -S nano --noconfirm && \
#    pacman -S pacman-contrib --noconfirm && \
#    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup && \
#    sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup && \
#    rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist && \
#    pacman -Syu --noconfirm && \
#    pacman -S --noconfirm sudo && \
#    echo "elastic ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd -m -U elastic

USER elastic

RUN cd /home/elastic && \
    curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.2-linux-x86_64.tar.gz && \
    tar -xzf elasticsearch-8.1.2-linux-x86_64.tar.gz

ENV PATH="home/elastic/elasticsearch-8.1.2/bin:$PATH"

# COPY logging.yml /home/elastic/elasticsearch-8.1.2/config/

# COPY --chown=elastic:elastic elasticsearch.yml /home/elastic/elasticsearch-8.1.2/config/

# COPY jvm.options /home/elasticsearch/elasticsearch-8.1.2/config/jvm.options.d/

CMD ["elasticsearch"]

EXPOSE 9200 9300
