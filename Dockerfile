FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    TZ=Asia/Dhaka

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common curl wget git unzip p7zip-full ffmpeg aria2 qbittorrent-nox rclone \
    build-essential libssl-dev libffi-dev python3-dev python3-pip python3-venv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install latest yt-dlp
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp \
    && chmod a+rx /usr/local/bin/yt-dlp

# Fix pip for Ubuntu (very important)
RUN pip3 install --break-system-packages --upgrade pip setuptools wheel uv

WORKDIR /usr/src/app

COPY requirements.txt .
RUN uv pip install --system --break-system-packages --no-cache -r requirements.txt

COPY . .

EXPOSE 8080

CMD ["bash", "start.sh"]
