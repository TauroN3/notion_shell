FROM node:25-bookworm

RUN apt update && \
    apt upgrade -y && \
    apt install -y curl git bash && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash appuser

RUN npm install -g @anthropic-ai/claude-code

WORKDIR /app

COPY package.json .
RUN npm install

COPY mcp-server.js .

RUN mkdir -p /home/appuser/.claude/skills/notion-api && \
    chown -R appuser:appuser /home/appuser/.claude

COPY notion-api/ /home/appuser/.claude/skills/notion-api/
COPY settings.json /home/appuser/.claude/settings.json

RUN chown -R appuser:appuser /app

USER appuser

ENV HOME=/home/appuser

ENV ANTHROPIC_API_KEY=""
ENV NOTION_API_KEY=""
ENV PORT=8000

EXPOSE ${PORT}

CMD ["node", "mcp-server.js"]
