# Reading Blocks and Page Content

## Block Overview

Blocks are the building units of page content in Notion. Everything users see on a page - paragraphs, headings, lists, images, etc. - is represented as a block.

**Key concepts:**
- Pages ARE blocks (special type that can have children)
- Blocks can have child blocks (nesting)
- Each block has a `type` and type-specific properties

## Block Object Structure

```json
{
  "object": "block",
  "id": "abc123",
  "parent": {
    "type": "page_id",
    "page_id": "xxx"
  },
  "created_time": "2024-01-01T12:00:00.000Z",
  "last_edited_time": "2024-01-01T12:00:00.000Z",
  "created_by": { "object": "user", "id": "xxx" },
  "last_edited_by": { "object": "user", "id": "xxx" },
  "has_children": false,
  "archived": false,
  "in_trash": false,
  "type": "paragraph",
  "paragraph": {
    "rich_text": [
      {
        "type": "text",
        "text": { "content": "This is a paragraph" },
        "annotations": {
          "bold": false,
          "italic": false,
          "strikethrough": false,
          "underline": false,
          "code": false,
          "color": "default"
        }
      }
    ],
    "color": "default"
  }
}
```

Common properties for all blocks:
- `object`: Always "block"
- `id`: Block UUID
- `type`: Block type (paragraph, heading_1, etc.)
- `created_time`, `last_edited_time`: ISO 8601 timestamps
- `has_children`: Boolean indicating if block has child blocks
- `archived`: Boolean for archived status
- `{type}`: Type-specific properties (e.g., `paragraph`, `heading_1`)

## API Endpoints

### Retrieve Block Children

**GET** `/v1/blocks/{block_id}/children`

Returns child blocks of a block (or page). Only returns first level - recursive calls needed for nested blocks.

```bash
curl https://api.notion.com/v1/blocks/xxx/children?page_size=100 \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Notion-Version: 2022-06-28"
```

**Parameters:**
- `page_size` (optional) - Max 100, default 100
- `start_cursor` (optional) - Pagination cursor

**Response:** Paginated list of block objects

### Retrieve a Block

**GET** `/v1/blocks/{block_id}`

```bash
curl https://api.notion.com/v1/blocks/xxx \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Notion-Version: 2022-06-28"
```

Returns the block object. Use "Retrieve block children" to get its child blocks.

## Block Types Reference

### Text Blocks

**Paragraph**
```json
{
  "type": "paragraph",
  "paragraph": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "Paragraph text" }
    }],
    "color": "default"
  }
}
```

**Headings (heading_1, heading_2, heading_3)**
```json
{
  "type": "heading_1",
  "heading_1": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "Heading text" }
    }],
    "color": "default",
    "is_toggleable": false
  }
}
```

**Callout**
```json
{
  "type": "callout",
  "callout": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "Important note" }
    }],
    "icon": {
      "type": "emoji",
      "emoji": "💡"
    },
    "color": "gray_background"
  }
}
```

**Quote**
```json
{
  "type": "quote",
  "quote": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "Quote text" }
    }],
    "color": "default"
  }
}
```

**Code**
```json
{
  "type": "code",
  "code": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "console.log('Hello');" }
    }],
    "caption": [],
    "language": "javascript"
  }
}
```

### List Blocks

**Bulleted List Item**
```json
{
  "type": "bulleted_list_item",
  "bulleted_list_item": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "List item" }
    }],
    "color": "default",
    "children": []
  }
}
```

**Numbered List Item**
```json
{
  "type": "numbered_list_item",
  "numbered_list_item": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "Numbered item" }
    }],
    "color": "default",
    "children": []
  }
}
```

**To-Do**
```json
{
  "type": "to_do",
  "to_do": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "Task to do" }
    }],
    "checked": false,
    "color": "default"
  }
}
```

**Toggle**
```json
{
  "type": "toggle",
  "toggle": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "Toggle title" }
    }],
    "color": "default",
    "children": []
  }
}
```

### Media Blocks

**Image**
```json
{
  "type": "image",
  "image": {
    "type": "external",
    "external": {
      "url": "https://example.com/image.png"
    },
    "caption": []
  }
}
```

**Video**
```json
{
  "type": "video",
  "video": {
    "type": "external",
    "external": {
      "url": "https://youtube.com/watch?v=xxx"
    },
    "caption": []
  }
}
```

**File**
```json
{
  "type": "file",
  "file": {
    "type": "external",
    "external": {
      "url": "https://example.com/document.pdf"
    },
    "caption": []
  }
}
```

### Layout Blocks

**Divider**
```json
{
  "type": "divider",
  "divider": {}
}
```

**Table of Contents**
```json
{
  "type": "table_of_contents",
  "table_of_contents": {
    "color": "default"
  }
}
```

**Column List & Column**
```json
{
  "type": "column_list",
  "column_list": {}
}
```

**Table**
```json
{
  "type": "table",
  "table": {
    "table_width": 3,
    "has_column_header": true,
    "has_row_header": false
  }
}
```

### Reference Blocks

**Child Page** (Read-only reference)
```json
{
  "type": "child_page",
  "child_page": {
    "title": "Page Name"
  }
}
```

**Child Database** (Read-only)
```json
{
  "type": "child_database",
  "child_database": {
    "title": "Database Name"
  }
}
```

**Link to Page**
```json
{
  "type": "link_to_page",
  "link_to_page": {
    "type": "page_id",
    "page_id": "xxx"
  }
}
```

## Recursive Content Reading

### Get All Page Content

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

const allContent = await getAllBlocks('page-id');
```

### Extract Plain Text from Blocks

```javascript
function extractText(blocks) {
  return blocks.map(block => {
    const type = block.type;
    const content = block[type];

    if (content?.rich_text) {
      return content.rich_text.map(rt => rt.plain_text).join('');
    }

    return '';
  }).filter(text => text.length > 0);
}
```

### Get Blocks by Type

```javascript
function getBlocksByType(blocks, type) {
  return blocks.filter(block => block.type === type);
}

// Get all headings
const headings = getBlocksByType(allBlocks, 'heading_1');

// Get all to-do items
const todos = getBlocksByType(allBlocks, 'to_do');
```

## Colors

Supported colors for blocks:
- `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`
- Background versions: `gray_background`, `brown_background`, etc.

## Best Practices

1. **Recursive Reading:** Always recursively read blocks with `has_children: true`
2. **Pagination:** Handle pagination for pages with many blocks
3. **Error Handling:** Handle unsupported blocks gracefully (type: "unsupported")
4. **Async Operations:** Use async/await for recursive operations
5. **Rate Limits:** Be mindful of rate limits when recursively reading large pages
6. **Block Limits:** Some pages may have many blocks - optimize reading strategies
