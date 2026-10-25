# 1. Base Image (Ubuntu Latest)
FROM ubuntu:24.04

# 2. Environment Variables
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    TZ=Asia/Dhaka \
    LANG=C.UTF-8

# 3. Install System Dependencies (Latest)
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    curl \
    wget \
    git \
    unzip \
    p7zip-full \
    ffmpeg \
    aria2 \
    qbittorrent-nox \
    rclone \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 4. Install Latest yt-dlp (Binary)
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp \
    && chmod a+rx /usr/local/bin/yt-dlp

# 5. Upgrade pip and install uv (Fast package installer)
RUN pip3 install --break-system-packages --upgrade pip setuptools wheel uv

# 6. Set Working Directory
WORKDIR /usr/src/app

# 7. Install Python Requirements
COPY requirements.txt .
RUN uv pip install --system --break-system-packages --no-cache -r requirements.txt

# 8. Copy Bot Code
COPY . .

# 9. Expose Port for Heroku
EXPOSE 8080

# 10. Start Command
ENTRYPOINT ["bash", "start.sh"]
