---
name: read-data-notion-api
description: Guide for reading data from Notion using the REST API. Use this skill when Claude needs to (1) Query databases and retrieve entries, (2) Search for pages or databases, (3) Read page properties and content, (4) Get block children and page structure, (5) List users or retrieve user info, (6) Read comments from pages, or (7) Understand how to filter, sort, and paginate data from Notion.
---

# Notion API Read Operations Skill

This skill provides guidance for reading data from Notion using the REST API.

## How to Use This Skill

This skill covers all read operations in the Notion API:
1. **Start with common_read_tasks.md** for quick recipes
2. **Read specific references** for detailed documentation
3. **Use api_overview.md** for authentication and pagination

## Quick Start

**First time reading from Notion API?** Start by reading:
1. `references/api_overview.md` - Authentication, headers, pagination
2. `references/common_read_tasks.md` - Quick recipes for reading data

## Reference Files

### Quick Reference

**`references/common_read_tasks.md`** - START HERE
Quick recipes for reading data:
- Authentication and setup
- Finding page/database IDs
- Querying databases with filters and sorts
- Reading page properties
- Getting page content (blocks)
- Searching for pages and databases
- Listing users
- Reading comments

### Core Concepts

**`references/api_overview.md`**
Foundational information:
- Base URL and request conventions
- Authentication (internal vs. public integrations)
- Required headers
- Pagination patterns
- Rate limits and error codes

### Reading from Databases

**`references/databases_read.md`**
Complete guide to querying databases:
- Database object structure
- Query endpoint with filters and sorts
- All filter conditions by property type
- Compound filters (AND/OR)
- Sort options
- Pagination for large databases

### Reading Pages

**`references/pages_read.md`**
Everything about reading pages:
- Page object structure
- Retrieving page properties
- Finding page IDs
- Understanding parent types

### Reading Blocks

**`references/blocks_read.md`**
Guide to reading page content:
- Block object structure
- Retrieving block children
- Recursive reading for nested content
- All block types

### Understanding Properties

**`references/properties.md`**
Complete reference for property types:
- Property value formats
- How to interpret each property type
- Paginated properties

## Discovery Patterns

### User Asks "How do I get..."

**Response pattern:**
1. Check `references/common_read_tasks.md` for a matching recipe
2. Provide working code example
3. Include pagination handling if needed
4. Mention sharing requirements

**Examples:**
- "How do I get all items from a database?" → Query Database endpoint
- "How do I search for pages?" → Search endpoint
- "How do I read page content?" → Retrieve Block Children endpoint

### User Asks "How do I filter..."

**Response pattern:**
1. Check `references/databases_read.md` for filter syntax
2. Identify the property type
3. Provide filter example with correct condition

## Important Reminders

### Before Reading Data

1. **Authentication Required:** Need integration token or OAuth access token
2. **Pages Must Be Shared:** Integration must be shared with pages/databases via Notion UI
3. **Headers Required:** Authorization, Notion-Version, Content-Type headers

### Common Read Operations

| Operation | Endpoint | Method |
|-----------|----------|--------|
| Search | `/v1/search` | POST |
| Get Database | `/v1/databases/{id}` | GET |
| Query Database | `/v1/databases/{id}/query` | POST |
| Get Page | `/v1/pages/{id}` | GET |
| Get Page Property | `/v1/pages/{id}/properties/{property_id}` | GET |
| Get Block | `/v1/blocks/{id}` | GET |
| Get Block Children | `/v1/blocks/{id}/children` | GET |
| List Users | `/v1/users` | GET |
| Get User | `/v1/users/{id}` | GET |
| Get Bot User | `/v1/users/me` | GET |
| Get Comments | `/v1/comments` | GET |

### Best Practices for Reading

1. **Handle Pagination:** Always paginate for large datasets
2. **Recursive Reading:** Page content may be nested - use recursive functions
3. **Rate Limits:** Implement exponential backoff for 429 errors
4. **404 Errors:** Usually means page isn't shared with integration
5. **Cache Responses:** Cache when appropriate to reduce API calls

## Example: Query Database with Filters

```javascript
const response = await notion.databases.query({
  database_id: 'database-id',
  filter: {
    and: [
      { property: 'Status', select: { equals: 'In Progress' } },
      { property: 'Due Date', date: { this_week: {} } }
    ]
  },
  sorts: [
    { property: 'Due Date', direction: 'ascending' }
  ],
  page_size: 100
});

// Handle pagination
let allResults = response.results;
let nextCursor = response.next_cursor;

while (response.has_more) {
  const nextPage = await notion.databases.query({
    database_id: 'database-id',
    start_cursor: nextCursor,
    page_size: 100
  });
  allResults.push(...nextPage.results);
  nextCursor = nextPage.next_cursor;
}
```

## Example: Read All Page Content

```javascript
async function getAllBlocks(blockId) {
  const allBlocks = [];
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
```
