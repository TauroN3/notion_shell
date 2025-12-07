# Reading Pages

## Page Overview

Pages are the fundamental content units in Notion where users write notes, documents, and landing pages. Each page has:
- **Properties:** Structured metadata (title, dates, relations, etc.)
- **Content:** Free-form blocks (paragraphs, headers, lists, images, etc.)

## Page Object Structure

```json
{
  "object": "page",
  "id": "59833787-2cf9-4fdf-8782-e53db20768a5",
  "created_time": "2022-03-01T19:05:00.000Z",
  "last_edited_time": "2022-03-01T19:05:00.000Z",
  "created_by": { "object": "user", "id": "..." },
  "last_edited_by": { "object": "user", "id": "..." },
  "cover": {
    "type": "external",
    "external": { "url": "https://example.com/cover.jpg" }
  },
  "icon": {
    "type": "emoji",
    "emoji": "📄"
  },
  "parent": {
    "type": "database_id",
    "database_id": "xxx"
  },
  "archived": false,
  "in_trash": false,
  "properties": {
    "Name": {
      "id": "title",
      "type": "title",
      "title": [{ "type": "text", "text": { "content": "My Page" } }]
    }
  },
  "url": "https://www.notion.so/My-Page-xxx"
}
```

### Parent Types

A page can be a child of:
1. **Database:** `{"type": "database_id", "database_id": "{uuid}"}`
2. **Page:** `{"type": "page_id", "page_id": "{uuid}"}`
3. **Workspace:** `{"type": "workspace", "workspace": true}`

## Finding Page IDs

### From Notion URL
1. Open page in Notion
2. Use Share menu → Copy link
3. Extract ID from URL format: `https://www.notion.so/Page-Title-{PAGE_ID}?v=...`
4. Format: 32-character string, can add hyphens in pattern 8-4-4-4-12

### Via API
- Use Search endpoint to find pages by title
- Use Query Database endpoint if page is in a database
- Store IDs when creating pages programmatically

## API Endpoints

### Retrieve a Page

**GET** `/v1/pages/{page_id}`

```bash
curl https://api.notion.com/v1/pages/xxx \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Notion-Version: 2022-06-28"
```

Returns the page object with properties. To get the page content (blocks), use the "Retrieve block children" endpoint with the page ID.

## Reading Page Properties

### Basic Property Retrieval

Properties are returned directly in the page object:

```javascript
const page = await notion.pages.retrieve({
  page_id: 'page-id'
});

// Access properties
const title = page.properties.Name.title[0].plain_text;
const status = page.properties.Status.select?.name;
const dueDate = page.properties['Due Date'].date?.start;
```

### Paginated Property Retrieval

For properties with many values (relations, rollups), use the property item endpoint:

**GET** `/v1/pages/{page_id}/properties/{property_id}`

```javascript
const propertyItems = await notion.pages.properties.retrieve({
  page_id: 'page-id',
  property_id: 'property-id'
});
```

This is necessary when property values are too large to fit in the page object response.

## Reading Page Content

Pages are themselves blocks, so use the block endpoints to read content:

**GET** `/v1/blocks/{page_id}/children`

```javascript
// Get immediate children
const blocks = await notion.blocks.children.list({
  block_id: 'page-id',
  page_size: 100
});
```

### Recursive Content Reading

Page content may be deeply nested. Use recursive functions to get all content:

```javascript
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

// Get page with all content
const page = await notion.pages.retrieve({ page_id: 'xxx' });
const allContent = await getAllBlocks('xxx');
```

## Common Use Cases

### Get Page with All Properties

```javascript
const page = await notion.pages.retrieve({ page_id: 'xxx' });

// Extract common property types
const properties = page.properties;

// Title
const title = properties.Name?.title[0]?.plain_text || '';

// Select
const status = properties.Status?.select?.name || null;

// Multi-select
const tags = properties.Tags?.multi_select.map(t => t.name) || [];

// Date
const dueDate = properties['Due Date']?.date?.start || null;

// Checkbox
const completed = properties.Completed?.checkbox || false;

// Number
const priority = properties.Priority?.number || 0;

// People
const assignees = properties.Assignee?.people.map(p => p.id) || [];
```

### Search and Retrieve Page

```javascript
// Search by title
const searchResults = await notion.search({
  query: 'Meeting Notes',
  filter: { property: 'object', value: 'page' }
});

// Get full page details
if (searchResults.results.length > 0) {
  const page = await notion.pages.retrieve({
    page_id: searchResults.results[0].id
  });
}
```

### Get Page with Content Summary

```javascript
async function getPageWithContent(pageId) {
  const page = await notion.pages.retrieve({ page_id: pageId });
  const blocks = await notion.blocks.children.list({
    block_id: pageId,
    page_size: 100
  });

  return {
    id: page.id,
    title: page.properties.title?.title[0]?.plain_text,
    url: page.url,
    lastEdited: page.last_edited_time,
    blockCount: blocks.results.length,
    hasMore: blocks.has_more
  };
}
```

## Best Practices

1. **Permissions:** Always share pages with your integration before API access
2. **404 Handling:** Could mean page doesn't exist OR integration lacks access
3. **Recursive Content:** Page content may be deeply nested - use recursive functions
4. **Pagination:** Handle pagination for pages with many blocks
5. **Property Types:** Understand each property type's value format
6. **Caching:** Cache page data when appropriate to reduce API calls
