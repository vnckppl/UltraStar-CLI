FROM oven/bun:alpine
WORKDIR /app

# System dependencies required by yt-dlp / ffmpeg
RUN apk add --no-cache python3 py3-pip ffmpeg ca-certificates tzdata bash

# Install youtube-dl
RUN python3 -m venv /opt/yt-venv && \
    /opt/yt-venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel && \
    /opt/yt-venv/bin/pip install --no-cache-dir yt-dlp && \
    ln -s /opt/yt-venv/bin/yt-dlp /usr/local/bin/yt-dlp

ENV PATH="/opt/yt-venv/bin:${PATH}"

COPY . .
RUN bun install && bun run build

RUN addgroup -S app && adduser -S app -G app
USER app

VOLUME ["/app/songs", "/app/.config"]
ENTRYPOINT ["bunx", "--bun", "ultrastar"]
CMD ["--help"]
