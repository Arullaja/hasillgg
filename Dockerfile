FROM node:20-slim

# Install Chromium dan dependensi
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-freefont-ttf \
    libxss1 \
    dbus \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Environment variables untuk Puppeteer/Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV NODE_ENV=production
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

WORKDIR /app

# Buat folder tokens untuk menyimpan sesi WhatsApp
RUN mkdir -p /app/tokens

# Install dependencies dulu (Docker cache layer)
COPY package*.json ./
RUN npm install --omit=dev

# Copy source code
COPY . .

# Expose port (Railway akan set PORT env var)
EXPOSE ${PORT:-3000}

# Start bot
CMD ["node", "bot.js"]
