# Creating and Updating Blocks

## Block Overview

Blocks are the building units of page content. Use block endpoints to add, update, and delete content on pages.

## API Endpoints

### Append Block Children

**PATCH** `/v1/blocks/{block_id}/children`

Add blocks to a parent block (or page). Blocks are appended to the end by default.

```bash
curl -X PATCH https://api.notion.com/v1/blocks/xxx/children \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  --data '{
    "children": [
      {
        "object": "block",
        "type": "paragraph",
        "paragraph": {
          "rich_text": [{
            "type": "text",
            "text": { "content": "New paragraph" }
          }]
        }
      }
    ]
  }'
```

**Parameters:**
- `children` (required) - Array of block objects to append
- `after` (optional) - Block ID to append after (instead of at end)

**Limits:** Maximum ~100 blocks per request, ~2000 characters per block

### Update a Block

**PATCH** `/v1/blocks/{block_id}`

Update block content. Only certain block types support updates.

```bash
curl -X PATCH https://api.notion.com/v1/blocks/xxx \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  --data '{
    "paragraph": {
      "rich_text": [{
        "type": "text",
        "text": { "content": "Updated content" }
      }]
    }
  }'
```

**Updatable block types:**
- paragraph, heading_1, heading_2, heading_3
- bulleted_list_item, numbered_list_item, toggle
- to_do, quote, callout, code

**Non-updatable:** Most media blocks, column_list, table, etc.

### Delete a Block

**DELETE** `/v1/blocks/{block_id}`

```bash
curl -X DELETE https://api.notion.com/v1/blocks/xxx \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Notion-Version: 2022-06-28"
```

Sets `archived: true` on the block.

## Block Types

### Text Blocks

**Paragraph**
```json
{
  "object": "block",
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

**Headings**
```json
{
  "object": "block",
  "type": "heading_1",
  "heading_1": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "Heading 1" }
    }],
    "color": "default",
    "is_toggleable": false
  }
}
```

Use `heading_1`, `heading_2`, or `heading_3`.

**Callout**
```json
{
  "object": "block",
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
    "color": "blue_background"
  }
}
```

**Quote**
```json
{
  "object": "block",
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
  "object": "block",
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

Languages: javascript, python, java, c, cpp, csharp, ruby, go, rust, typescript, html, css, sql, bash, json, yaml, markdown, and many more.

### List Blocks

**Bulleted List Item**
```json
{
  "object": "block",
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
  "object": "block",
  "type": "numbered_list_item",
  "numbered_list_item": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "Numbered item" }
    }],
    "color": "default"
  }
}
```

**To-Do**
```json
{
  "object": "block",
  "type": "to_do",
  "to_do": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "Task" }
    }],
    "checked": false,
    "color": "default"
  }
}
```

**Toggle**
```json
{
  "object": "block",
  "type": "toggle",
  "toggle": {
    "rich_text": [{
      "type": "text",
      "text": { "content": "Toggle title" }
    }],
    "color": "default",
    "children": [
      {
        "object": "block",
        "type": "paragraph",
        "paragraph": {
          "rich_text": [{ "type": "text", "text": { "content": "Hidden content" } }]
        }
      }
    ]
  }
}
```

### Media Blocks

**Image**
```json
{
  "object": "block",
  "type": "image",
  "image": {
    "type": "external",
    "external": {
      "url": "https://example.com/image.png"
    },
    "caption": [
      { "type": "text", "text": { "content": "Caption" } }
    ]
  }
}
```

**Video**
```json
{
  "object": "block",
  "type": "video",
  "video": {
    "type": "external",
    "external": {
      "url": "https://youtube.com/watch?v=xxx"
    }
  }
}
```

**File**
```json
{
  "object": "block",
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

**Bookmark**
```json
{
  "object": "block",
  "type": "bookmark",
  "bookmark": {
    "url": "https://example.com",
    "caption": []
  }
}
```

### Layout Blocks

**Divider**
```json
{
  "object": "block",
  "type": "divider",
  "divider": {}
}
```

**Table of Contents**
```json
{
  "object": "block",
  "type": "table_of_contents",
  "table_of_contents": {
    "color": "default"
  }
}
```

**Equation**
```json
{
  "object": "block",
  "type": "equation",
  "equation": {
    "expression": "E = mc^2"
  }
}
```

### Table

Tables require creating the table block first, then adding rows:

```javascript
// 1. Create table
const table = await notion.blocks.children.append({
  block_id: 'page-id',
  children: [{
    object: 'block',
    type: 'table',
    table: {
      table_width: 3,
      has_column_header: true,
      has_row_header: false
    }
  }]
});

const tableId = table.results[0].id;

// 2. Add rows
await notion.blocks.children.append({
  block_id: tableId,
  children: [
    {
      object: 'block',
      type: 'table_row',
      table_row: {
        cells: [
          [{ type: 'text', text: { content: 'Header 1' } }],
          [{ type: 'text', text: { content: 'Header 2' } }],
          [{ type: 'text', text: { content: 'Header 3' } }]
        ]
      }
    },
    {
      object: 'block',
      type: 'table_row',
      table_row: {
        cells: [
          [{ type: 'text', text: { content: 'Cell 1' } }],
          [{ type: 'text', text: { content: 'Cell 2' } }],
          [{ type: 'text', text: { content: 'Cell 3' } }]
        ]
      }
    }
  ]
});
```

### Columns

Columns require creating column_list, then columns, then content:

```javascript
// 1. Create column_list
const columnList = await notion.blocks.children.append({
  block_id: 'page-id',
  children: [{
    object: 'block',
    type: 'column_list',
    column_list: {}
  }]
});

const columnListId = columnList.results[0].id;

// 2. Add columns
const columns = await notion.blocks.children.append({
  block_id: columnListId,
  children: [
    { object: 'block', type: 'column', column: {} },
    { object: 'block', type: 'column', column: {} }
  ]
});

// 3. Add content to each column
await notion.blocks.children.append({
  block_id: columns.results[0].id,
  children: [{
    object: 'block',
    type: 'paragraph',
    paragraph: {
      rich_text: [{ type: 'text', text: { content: 'Left column' } }]
    }
  }]
});

await notion.blocks.children.append({
  block_id: columns.results[1].id,
  children: [{
    object: 'block',
    type: 'paragraph',
    paragraph: {
      rich_text: [{ type: 'text', text: { content: 'Right column' } }]
    }
  }]
});
```

## Rich Text Formatting

### Basic Text
```json
{
  "type": "text",
  "text": { "content": "Plain text" }
}
```

### Formatted Text
```json
{
  "type": "text",
  "text": { "content": "Bold and italic" },
  "annotations": {
    "bold": true,
    "italic": true,
    "underline": false,
    "strikethrough": false,
    "code": false,
    "color": "default"
  }
}
```

### Link
```json
{
  "type": "text",
  "text": {
    "content": "Click here",
    "link": { "url": "https://example.com" }
  }
}
```

### Mention User
```json
{
  "type": "mention",
  "mention": {
    "type": "user",
    "user": { "id": "user-id" }
  }
}
```

### Mention Page
```json
{
  "type": "mention",
  "mention": {
    "type": "page",
    "page": { "id": "page-id" }
  }
}
```

### Mention Date
```json
{
  "type": "mention",
  "mention": {
    "type": "date",
    "date": { "start": "2024-12-31" }
  }
}
```

### Inline Equation
```json
{
  "type": "equation",
  "equation": { "expression": "x^2" }
}
```

## Colors

Block and text colors:
- `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`
- Background: `gray_background`, `brown_background`, `orange_background`, etc.

## Common Patterns

### Create Page with Rich Content

```javascript
await notion.pages.create({
  parent: { page_id: 'xxx' },
  properties: {
    title: { title: [{ type: 'text', text: { content: 'Documentation' } }] }
  },
  children: [
    {
      object: 'block',
      type: 'heading_1',
      heading_1: {
        rich_text: [{ type: 'text', text: { content: 'Overview' } }]
      }
    },
    {
      object: 'block',
      type: 'paragraph',
      paragraph: {
        rich_text: [
          { type: 'text', text: { content: 'This is ' } },
          {
            type: 'text',
            text: { content: 'important' },
            annotations: { bold: true, color: 'red' }
          },
          { type: 'text', text: { content: ' information.' } }
        ]
      }
    },
    {
      object: 'block',
      type: 'callout',
      callout: {
        rich_text: [{ type: 'text', text: { content: 'Note: Read carefully' } }],
        icon: { type: 'emoji', emoji: '⚠️' },
        color: 'yellow_background'
      }
    }
  ]
});
```

### Create Nested Lists

```javascript
await notion.blocks.children.append({
  block_id: 'page-id',
  children: [
    {
      object: 'block',
      type: 'bulleted_list_item',
      bulleted_list_item: {
        rich_text: [{ type: 'text', text: { content: 'Parent' } }],
        children: [
          {
            object: 'block',
            type: 'bulleted_list_item',
            bulleted_list_item: {
              rich_text: [{ type: 'text', text: { content: 'Child 1' } }],
              children: [
                {
                  object: 'block',
                  type: 'bulleted_list_item',
                  bulleted_list_item: {
                    rich_text: [{ type: 'text', text: { content: 'Grandchild' } }]
                  }
                }
              ]
            }
          },
          {
            object: 'block',
            type: 'bulleted_list_item',
            bulleted_list_item: {
              rich_text: [{ type: 'text', text: { content: 'Child 2' } }]
            }
          }
        ]
      }
    }
  ]
});
```

### Update Block Text

```javascript
await notion.blocks.update({
  block_id: 'block-id',
  paragraph: {
    rich_text: [
      {
        type: 'text',
        text: { content: 'Updated text with ' },
      },
      {
        type: 'text',
        text: { content: 'formatting' },
        annotations: { bold: true }
      }
    ]
  }
});
```

### Update To-Do Checked Status

```javascript
await notion.blocks.update({
  block_id: 'todo-block-id',
  to_do: {
    checked: true
  }
});
```

## Best Practices

1. **Batch Appends:** Include multiple blocks in one request (max ~100)
2. **Block Limits:** Maximum ~2000 characters per block
3. **Rich Text:** Always use proper rich text format
4. **Nested Content:** Use children property for nested blocks
5. **Tables/Columns:** Create parent first, then add children
6. **Updates:** Not all block types can be updated
7. **Rate Limits:** Implement retry logic for 429 errors
8. **Validation:** Validate block structure before sending
