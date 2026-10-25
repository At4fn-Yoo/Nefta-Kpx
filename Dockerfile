# 1. Base Image (Ubuntu 24.04 Latest)
FROM ubuntu:24.04

# 2. Environment Variables
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    TZ=Asia/Dhaka \
    LANG=C.UTF-8

# 3. Install System Dependencies & Python 3.14 (via PPA)
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
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y python3.14 python3.14-dev python3.14-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 4. Set Python 3.14 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.14 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.14 1

# 5. Install Latest yt-dlp
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp \
    && chmod a+rx /usr/local/bin/yt-dlp

# 6. Upgrade pip and install uv
RUN python3 -m pip install --upgrade pip setuptools wheel uv

# 7. Set Working Directory
WORKDIR /usr/src/app

# 8. Install Python Requirements
COPY requirements.txt .
RUN uv pip install --system --no-cache -r requirements.txt

# 9. Copy Bot Code
COPY . .

# 10. Expose Port for Heroku
EXPOSE 8080

# 11. Start Command
ENTRYPOINT ["bash", "start.sh"]
