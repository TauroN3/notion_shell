# notion_agent
1. Fill the .env file with API tokens
2. Build the image:
```
docker build -t notion_agent .
```
3. Add the following docker command to claude desktop MCP file:
```
docker run -p 8000:8000 -i --env-file <PATH/TO/ENV/FILE> notion_agent
```

It is reccomended to use Docker with MicroVM support for security as I did not fine-tuned claude-code's permissions at all
