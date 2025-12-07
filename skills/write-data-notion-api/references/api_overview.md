# Notion API Overview

## Base URL and Conventions

**Base URL:** `https://api.notion.com`

All API requests must use HTTPS. The API follows RESTful conventions with GET, POST, PATCH, and DELETE operations.

### JSON Conventions

- All resources have an `"object"` property indicating the resource type
- Resources are addressable by UUIDv4 `"id"` (dashes in IDs are optional)
- Property names use `snake_case`
- Temporal values use ISO 8601 format:
  - Datetimes: `2020-08-12T02:12:33.231Z`
  - Dates: `2020-08-12`
- The API does not support empty strings - use `null` instead

### Required Headers

All API requests must include:
- `Authorization: Bearer {TOKEN}` - Your integration token or OAuth access token
- `Notion-Version: 2022-06-28` - API version
- `Content-Type: application/json` - Required for POST/PATCH requests

Example curl request:
```bash
curl -X POST 'https://api.notion.com/v1/pages' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  --data '{...}'
```

## Authentication

### Internal Integrations

1. Create integration at https://www.notion.so/profile/integrations
2. Copy the integration token from the Configuration tab
3. **Important:** Share specific pages/databases with the integration via "Add connections" menu
4. Include the token in all API requests

**Keep tokens secret!** Use environment variables.

### Integration Capabilities for Writing

Integrations need specific capabilities to write data:
- **Update content** - Modify existing pages and databases
- **Insert content** - Create new pages and databases
- **Insert comments** - Add comments to pages

Configure capabilities in integration settings.

### Public Integrations (OAuth 2.0)

For public integrations, exchange authorization code for access token:

```bash
POST /v1/oauth/token
Authorization: Basic {base64(client_id:client_secret)}
Content-Type: application/json

{"grant_type": "authorization_code", "code": "{CODE}", "redirect_uri": "{REDIRECT_URI}"}
```

## Rate Limits

When rate limits are exceeded:
- Status code: `429 Too Many Requests`
- Response includes `retry-after` header

Best practices:
- Implement exponential backoff
- Batch operations when possible
- Use async operations for large writes

## Common Error Codes

- `400 Bad Request` - Invalid request parameters or property format
- `401 Unauthorized` - Missing or invalid authentication token
- `403 Forbidden` - Integration lacks required capabilities
- `404 Not Found` - Resource doesn't exist or integration lacks access
- `409 Conflict` - Resource was modified by another request
- `429 Too Many Requests` - Rate limit exceeded
- `500/502/503/504` - Server errors (retry with exponential backoff)

## Size Limits

- **Blocks:** Maximum ~2000 characters per block
- **API Request:** Maximum ~100 blocks per request
- **Database Schema:** Recommended maximum 50KB
- **File Uploads:**
  - Free workspaces: Limited per file size
  - Paid workspaces: 5 GiB per file
  - Files >20 MiB must use multi-part upload
- **Filename length:** Maximum 900 bytes

## Notion SDK

Official JavaScript SDK: `@notionhq/client`

```javascript
const { Client } = require('@notionhq/client');
const notion = new Client({ auth: process.env.NOTION_API_KEY });

// SDK handles headers and token automatically
const response = await notion.pages.create({
  parent: { page_id: 'xxx' },
  properties: { title: { title: [{ text: { content: 'My Page' } }] } }
});
```

The SDK is recommended for write operations as it handles serialization and provides TypeScript types.
