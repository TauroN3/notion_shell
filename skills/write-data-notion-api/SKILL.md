---
name: write-data-notion-api
description: Guide for writing and modifying data in Notion using the REST API. Use this skill when Claude needs to (1) Create new pages or databases, (2) Update page properties or content, (3) Add, update, or delete blocks, (4) Modify database schemas, (5) Add comments to pages, (6) Archive or restore pages, or (7) Format content with rich text, tables, and other block types.
---

# Notion API Write Operations Skill

This skill provides guidance for creating and modifying data in Notion using the REST API.

## How to Use This Skill

This skill covers all write operations in the Notion API:
1. **Start with common_write_tasks.md** for quick recipes
2. **Read specific references** for detailed documentation
3. **Use api_overview.md** for authentication and request format

## Quick Start

**First time writing to Notion API?** Start by reading:
1. `references/api_overview.md` - Authentication, headers, request format
2. `references/common_write_tasks.md` - Quick recipes for writing data

## Reference Files

### Quick Reference

**`references/common_write_tasks.md`** - START HERE
Quick recipes for writing data:
- Creating pages and databases
- Updating page properties
- Adding and updating blocks
- Creating formatted content
- Working with tables, lists, and complex structures
- Archiving and restoring pages

### Core Concepts

**`references/api_overview.md`**
Foundational information:
- Base URL and request conventions
- Authentication (internal vs. public integrations)
- Required headers
- Rate limits and error codes

### Creating and Updating Databases

**`references/databases_write.md`**
Complete guide to database operations:
- Creating new databases
- Updating database schemas
- Adding and removing properties
- Property type configurations

### Creating and Updating Pages

**`references/pages_write.md`**
Everything about page operations:
- Creating standalone pages
- Creating database entries
- Updating page properties
- Archiving and restoring pages
- Setting icons and covers

### Creating and Updating Blocks

**`references/blocks_write.md`**
Guide to creating page content:
- Appending blocks to pages
- Updating block content
- Deleting blocks
- All block types with examples
- Rich text formatting
- Complex structures (tables, columns, nested lists)

### Property Value Formats

**`references/properties_write.md`**
How to set property values:
- All property type formats
- Rich text formatting
- Date and time handling
- Relation and people values

## Discovery Patterns

### User Asks "How do I create..."

**Response pattern:**
1. Check `references/common_write_tasks.md` for a matching recipe
2. Provide working code example
3. Include all required fields
4. Mention sharing requirements

**Examples:**
- "How do I create a page?" → Create Page endpoint
- "How do I add a database entry?" → Create Page with database parent
- "How do I add content to a page?" → Append Block Children endpoint

### User Asks "How do I update..."

**Response pattern:**
1. Check relevant reference for update endpoint
2. Identify what can be updated
3. Provide correct PATCH request format

## Important Reminders

### Before Writing Data

1. **Authentication Required:** Need integration token or OAuth access token
2. **Pages Must Be Shared:** Integration must be shared with parent pages/databases
3. **Headers Required:** Authorization, Notion-Version, Content-Type headers
4. **Capabilities:** Integration needs "Insert content" and/or "Update content" capabilities

### Common Write Operations

| Operation | Endpoint | Method |
|-----------|----------|--------|
| Create Database | `/v1/databases` | POST |
| Update Database | `/v1/databases/{id}` | PATCH |
| Create Page | `/v1/pages` | POST |
| Update Page | `/v1/pages/{id}` | PATCH |
| Append Blocks | `/v1/blocks/{id}/children` | PATCH |
| Update Block | `/v1/blocks/{id}` | PATCH |
| Delete Block | `/v1/blocks/{id}` | DELETE |
| Create Comment | `/v1/comments` | POST |

### Best Practices for Writing

1. **Rich Text Format:** Always use rich text format, never plain strings
2. **Property Matching:** Page properties must match database schema
3. **Batch Operations:** Include multiple blocks in one request (max ~100)
4. **Block Limits:** Maximum ~2000 characters per block
5. **Store IDs:** Save created resource IDs for future updates
6. **Error Handling:** Handle rate limits and validation errors
7. **Validate First:** Validate data before sending to API

## Example: Create Page with Content

```javascript
const page = await notion.pages.create({
  parent: { page_id: 'parent-page-id' },
  properties: {
    title: {
      title: [{ type: 'text', text: { content: 'Meeting Notes' } }]
    }
  },
  children: [
    {
      object: 'block',
      type: 'heading_1',
      heading_1: {
        rich_text: [{ type: 'text', text: { content: 'Agenda' } }]
      }
    },
    {
      object: 'block',
      type: 'bulleted_list_item',
      bulleted_list_item: {
        rich_text: [{ type: 'text', text: { content: 'Review Q4 goals' } }]
      }
    },
    {
      object: 'block',
      type: 'to_do',
      to_do: {
        rich_text: [{ type: 'text', text: { content: 'Prepare presentation' } }],
        checked: false
      }
    }
  ]
});
```

## Example: Add Database Entry

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
      multi_select: [
        { name: 'urgent' },
        { name: 'bug' }
      ]
    },
    'Assignee': {
      people: [{ id: 'user-id' }]
    }
  }
});
```

## Example: Update Page Properties

```javascript
await notion.pages.update({
  page_id: 'page-id',
  properties: {
    'Status': { select: { name: 'Done' } },
    'Completed': { checkbox: true },
    'Notes': {
      rich_text: [
        { type: 'text', text: { content: 'Completed ahead of schedule' } }
      ]
    }
  }
});
```

## Example: Add Content to Existing Page

```javascript
await notion.blocks.children.append({
  block_id: 'page-id',
  children: [
    {
      object: 'block',
      type: 'paragraph',
      paragraph: {
        rich_text: [
          {
            type: 'text',
            text: { content: 'Important: ' },
            annotations: { bold: true }
          },
          {
            type: 'text',
            text: { content: 'This is a new paragraph' }
          }
        ]
      }
    }
  ]
});
```
