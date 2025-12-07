# Quick Reference: Common Read Tasks

This guide provides quick recipes for reading data from Notion.

## Authentication & Setup

### Get Your Integration Token
1. Go to https://www.notion.so/my-integrations
2. Create or select your integration
3. Copy the "Internal Integration Token" from Configuration tab
4. Store securely in environment variable: `NOTION_API_KEY`

### Share Pages with Integration
**Before API access works, you MUST share pages/databases:**
1. Open page in Notion
2. Click ••• menu (top right)
3. Scroll to "Add connections"
4. Search and select your integration

## Finding IDs

### Get Page ID from URL
```
URL: https://www.notion.so/My-Page-abc123def456...
ID: abc123def456... (32 characters)
```

### Get Database ID from URL
```
URL: https://www.notion.so/workspace/abc123?v=def456
Database ID: abc123 (between workspace name and ?v=)
```

### Search for Page/Database by Title
```bash
curl -X POST https://api.notion.com/v1/search \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  --data '{
    "query": "My Page Title",
    "filter": { "property": "object", "value": "page" }
  }'
```

## Database Read Operations

### List All Databases I Have Access To
```bash
curl -X POST https://api.notion.com/v1/search \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  --data '{
    "filter": { "property": "object", "value": "database" }
  }'
```

### Get Database Schema
```bash
curl https://api.notion.com/v1/databases/{database_id} \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Notion-Version: 2022-06-28"
```

Response includes `properties` object with full schema.

### Get All Items from Database
```javascript
const response = await notion.databases.query({
  database_id: 'database-id'
  // No filter = get all items
});

// With pagination for large databases:
let allPages = [];
let hasMore = true;
let startCursor = undefined;

while (hasMore) {
  const response = await notion.databases.query({
    database_id: 'database-id',
    start_cursor: startCursor,
    page_size: 100
  });
  allPages.push(...response.results);
  hasMore = response.has_more;
  startCursor = response.next_cursor;
}
```

### Query Database with Filters
```javascript
// Find all "In Progress" tasks
const response = await notion.databases.query({
  database_id: 'database-id',
  filter: {
    property: 'Status',
    select: { equals: 'In Progress' }
  }
});

// Find high-priority incomplete tasks
const response = await notion.databases.query({
  database_id: 'database-id',
  filter: {
    and: [
      { property: 'Status', select: { does_not_equal: 'Done' } },
      { property: 'Priority', multi_select: { contains: 'High' } }
    ]
  }
});

// Find tasks due this week
const response = await notion.databases.query({
  database_id: 'database-id',
  filter: {
    property: 'Due Date',
    date: { this_week: {} }
  }
});
```

### Query Database with Sorting
```javascript
const response = await notion.databases.query({
  database_id: 'database-id',
  sorts: [
    { property: 'Priority', direction: 'ascending' },
    { property: 'Due Date', direction: 'ascending' }
  ]
});
```

## Page Read Operations

### Get Page Properties
```javascript
const page = await notion.pages.retrieve({
  page_id: 'page-id'
});

// Properties are in page.properties
console.log(page.properties);
```

### Get Page Content (All Blocks)
```javascript
// Get immediate children
const blocks = await notion.blocks.children.list({
  block_id: 'page-id',
  page_size: 100
});

// Recursively get all content including nested blocks
async function getAllBlocks(blockId) {
  let allBlocks = [];
  let hasMore = true;
  let startCursor = undefined;

  while (hasMore) {
    const response = await notion.blocks.children.list({
      block_id: blockId,
      start_cursor: startCursor,
      page_size: 100
    });

    for (const block of response.results) {
      allBlocks.push(block);

      if (block.has_children) {
        const children = await getAllBlocks(block.id);
        allBlocks.push(...children);
      }
    }

    hasMore = response.has_more;
    startCursor = response.next_cursor;
  }

  return allBlocks;
}

const allContent = await getAllBlocks('page-id');
```

### Get Single Block
```javascript
const block = await notion.blocks.retrieve({
  block_id: 'block-id'
});
```

## Search Operations

### Search Everything
```javascript
const results = await notion.search({
  query: 'search term'
});
```

### Search Only Pages
```javascript
const pages = await notion.search({
  query: 'search term',
  filter: {
    property: 'object',
    value: 'page'
  }
});
```

### Search Only Databases
```javascript
const databases = await notion.search({
  query: 'search term',
  filter: {
    property: 'object',
    value: 'database'
  }
});
```

### Search with Sorting
```javascript
const results = await notion.search({
  query: 'search term',
  sort: {
    direction: 'descending',
    timestamp: 'last_edited_time'
  }
});
```

## User Operations

### List All Users
```javascript
const users = await notion.users.list({});
```

### Get Current Bot User Info
```javascript
const bot = await notion.users.me({});
```

### Get User by ID
```javascript
const user = await notion.users.retrieve({
  user_id: 'user-id'
});
```

## Comment Operations

### Get Comments on Page
```javascript
const comments = await notion.comments.list({
  block_id: 'page-id'
});
```

## Error Handling

### Check if Page/Database is Shared
```javascript
try {
  const page = await notion.pages.retrieve({ page_id: 'xxx' });
  console.log('Access granted!');
} catch (error) {
  if (error.code === 'object_not_found') {
    console.log('Not shared with integration OR doesn\'t exist');
  }
}
```

### Handle Rate Limits
```javascript
async function withRetry(fn, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (error.code === 'rate_limited') {
        const retryAfter = error.headers?.['retry-after'] || 1;
        console.log(`Rate limited, waiting ${retryAfter}s...`);
        await new Promise(resolve => setTimeout(resolve, retryAfter * 1000));
      } else {
        throw error;
      }
    }
  }
  throw new Error('Max retries exceeded');
}

// Use it:
const result = await withRetry(() =>
  notion.pages.retrieve({ page_id: 'xxx' })
);
```

## Tips & Best Practices

1. **Always share pages** with integration before API access
2. **Handle pagination** for large databases and pages
3. **Use property IDs** instead of names for stability
4. **Handle rate limits** with exponential backoff
5. **Recursive reading** needed for nested block structures
6. **Cache responses** when appropriate to reduce API calls
7. **Keep tokens secret** - never commit to source control
