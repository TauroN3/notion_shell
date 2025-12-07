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

RUN mkdir -p /home/appuser/.claude/skills/read-data-notion-api && \
    mkdir -p /home/appuser/.claude/skills/write-data-notion-api && \
    mkdir -p /home/appuser/.claude/agents/data-reader && \
    mkdir -p /home/appuser/.claude/agents/data-writer && \
    chown -R appuser:appuser /home/appuser/.claude

COPY skills/read-data-notion-api/ /home/appuser/.claude/skills/read-data-notion-api/
COPY skills/write-data-notion-api/ /home/appuser/.claude/skills/write-data-notion-api/
COPY subagents/data-reader.md /home/appuser/.claude/agents/data-reader/
COPY subagents/data-writer.md /home/appuser/.claude/agents/data-writer/
COPY settings.json /home/appuser/.claude/settings.json

RUN chown -R appuser:appuser /app

USER appuser

ENV HOME=/home/appuser

ENV ANTHROPIC_API_KEY=""
ENV NOTION_API_KEY=""
ENV PORT=8000

EXPOSE ${PORT}

CMD ["node", "mcp-server.js"]
