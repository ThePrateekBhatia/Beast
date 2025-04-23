FROM mysterysd/wzmlx:v3

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN uv venv --system-site-packages

COPY requirements.txt .
RUN uv pip install --no-cache-dir -r requirements.txt

COPY . .

# Remove all qBittorrent PPA references before updating apt
RUN find /etc/apt/sources.list.d/ -name '*qbittorrent*' -exec rm -f {} + && \
    sed -i '/qbittorrent/d' /etc/apt/sources.list || true && \
    sed -i '/qbittorrent/d' /etc/apt/sources.list.d/*.list || true

# Install supervisor only (remove qbittorrent-nox)
RUN apt-get update && apt-get install -y supervisor && rm -rf /var/lib/apt/lists/*

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

