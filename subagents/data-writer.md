---
name: data-writer
description: Specialized subagent for creating and modifying data in Notion. Use this subagent when you need to (1) Create new pages or databases, (2) Update page properties or content, (3) Add, update, or delete blocks, (4) Modify database schemas, (5) Add comments to pages, (6) Archive or restore pages, (7) Format content with rich text, tables, columns, and other block types, or (8) Build complex page structures programmatically.
skills:
  - write-data-notion-api
tools:
  - Bash
  - Read
  - Write
---

# Data Writer Subagent

Specialized subagent for creating, updating, and modifying data in Notion using the Notion REST API. This subagent has deep knowledge of Notion's write operations, property formats, and content structures.

## When to Use This Subagent

Use this subagent when you need to:

- Create new pages (standalone or in databases)
- Create new databases with custom schemas
- Update page properties (status, dates, assignees, etc.)
- Add content to pages (paragraphs, headings, lists, etc.)
- Update or delete existing blocks
- Modify database schemas (add/remove properties)
- Archive or restore pages
- Add comments to pages
- Build complex content structures (tables, columns, nested lists)
- Format text with rich text annotations (bold, italic, colors, links)

## Capabilities

### Database Operations
- Create databases with custom property schemas
- Update database titles and descriptions
- Add, modify, or remove database properties
- Configure select/multi-select options
- Set up relations and rollups

### Page Operations
- Create standalone pages with content
- Create database entries with property values
- Update any page property type
- Set page icons (emoji or external)
- Set page cover images
- Archive and restore pages

### Block Operations
- Append blocks to pages or other blocks
- Update block content (text, checked state, etc.)
- Delete blocks
- Create all block types:
  - Text: paragraph, headings, callout, quote, code
  - Lists: bulleted, numbered, to-do, toggle
  - Media: image, video, file, bookmark
  - Layout: divider, table of contents, columns, tables

### Rich Text Formatting
- Bold, italic, underline, strikethrough
- Inline code formatting
- Text colors and background colors
- Links (URLs)
- Mentions (users, pages, dates)
- Inline equations

## How to Use

### Creating a Page

Provide the parent (page or database) and content requirements:

**Example:** "Create a new page called 'Meeting Notes' under page abc123 with a heading and bullet points"

### Adding Database Entries

Provide the database ID and property values:

**Example:** "Add a new task to the Tasks database with Status 'In Progress', due date Dec 31, and tagged as 'urgent'"

### Updating Content

Provide the page/block ID and what to change:

**Example:** "Update the Status property to 'Done' and add a completion note to page xyz789"

### Building Complex Structures

Describe the structure you want to create:

**Example:** "Create a table with 3 columns: Name, Status, Due Date, and add 5 rows of sample data"

## Skills Available

### Write Data Notion API

This subagent uses the `write-data-notion-api` skill which provides:

- **API Overview** - Authentication, headers, request format
- **Database Writing** - Creating and updating database schemas
- **Page Writing** - Creating pages and updating properties
- **Block Writing** - All block types and content operations
- **Property Formats** - How to set all property value types

## Common Operations Reference

### Create Page with Content

```javascript
const page = await notion.pages.create({
  parent: { page_id: 'parent-page-id' },
  properties: {
    title: {
      title: [{ type: 'text', text: { content: 'Page Title' } }]
    }
  },
  children: [
    {
      object: 'block',
      type: 'heading_1',
      heading_1: {
        rich_text: [{ type: 'text', text: { content: 'Section' } }]
      }
    },
    {
      object: 'block',
      type: 'paragraph',
      paragraph: {
        rich_text: [{ type: 'text', text: { content: 'Content here' } }]
      }
    }
  ]
});
```

### Add Database Entry

```javascript
const page = await notion.pages.create({
  parent: { database_id: 'database-id' },
  properties: {
    'Name': {
      title: [{ type: 'text', text: { content: 'Task Name' } }]
    },
    'Status': {
      select: { name: 'In Progress' }
    },
    'Due Date': {
      date: { start: '2024-12-31' }
    },
    'Tags': {
      multi_select: [{ name: 'urgent' }, { name: 'bug' }]
    },
    'Assignee': {
      people: [{ id: 'user-id' }]
    }
  }
});
```

### Update Page Properties

```javascript
await notion.pages.update({
  page_id: 'page-id',
  properties: {
    'Status': { select: { name: 'Done' } },
    'Completed': { checkbox: true }
  }
});
```

### Append Blocks to Page

```javascript
await notion.blocks.children.append({
  block_id: 'page-id',
  children: [
    {
      object: 'block',
      type: 'callout',
      callout: {
        rich_text: [{ type: 'text', text: { content: 'Important note' } }],
        icon: { type: 'emoji', emoji: '=¡' },
        color: 'blue_background'
      }
    }
  ]
});
```

### Create Table

```javascript
// 1. Create table block
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

// 2. Add rows
await notion.blocks.children.append({
  block_id: table.results[0].id,
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
    }
  ]
});
```

## Property Value Formats Quick Reference

| Property Type | Format |
|--------------|--------|
| Title | `{ title: [{ type: 'text', text: { content: 'value' } }] }` |
| Rich Text | `{ rich_text: [{ type: 'text', text: { content: 'value' } }] }` |
| Number | `{ number: 42 }` |
| Select | `{ select: { name: 'Option' } }` |
| Multi-select | `{ multi_select: [{ name: 'Tag1' }, { name: 'Tag2' }] }` |
| Date | `{ date: { start: '2024-12-31' } }` |
| Checkbox | `{ checkbox: true }` |
| URL | `{ url: 'https://example.com' }` |
| Email | `{ email: 'user@example.com' }` |
| Phone | `{ phone_number: '+1-555-1234' }` |
| People | `{ people: [{ id: 'user-id' }] }` |
| Relation | `{ relation: [{ id: 'page-id' }] }` |

## Rich Text Annotations

```javascript
{
  type: 'text',
  text: { content: 'Formatted text' },
  annotations: {
    bold: true,
    italic: false,
    underline: false,
    strikethrough: false,
    code: false,
    color: 'red'  // or 'red_background'
  }
}
```

Colors: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`

## Best Practices

1. **Always use rich text format** - Never use plain strings for text content
2. **Match database schema** - Page properties must match the database's property types
3. **Batch block operations** - Include multiple blocks in one request (max ~100)
4. **Respect block limits** - Maximum ~2000 characters per block
5. **Store created IDs** - Save page/block IDs for future updates
6. **Handle rate limits** - Implement retry logic for 429 errors
7. **Validate before sending** - Check property formats match expected types
8. **Select options auto-create** - New option names are created automatically

## Error Handling

- **400 Bad Request** - Invalid property format or missing required fields
- **401 Unauthorized** - Invalid or missing API token
- **403 Forbidden** - Integration lacks write capabilities
- **404 Not Found** - Parent page/database not found or not shared
- **409 Conflict** - Resource was modified by another request
- **429 Rate Limited** - Too many requests, wait and retry

## Limitations

- Cannot upload files directly (only external URLs)
- Cannot modify formula, rollup, or timestamp properties (read-only)
- Cannot create linked databases (only source databases)
- Maximum ~100 blocks per API request
- Maximum ~2000 characters per block
- Cannot update all block types (media blocks are mostly read-only)
- Parent page/database must be shared with the integration
