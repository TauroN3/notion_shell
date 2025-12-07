# Creating and Updating Pages

## Page Overview

Pages can be created as standalone pages or as entries in a database. When creating a page:
- **Standalone pages** only have a title property
- **Database pages** must include properties matching the database schema

## API Endpoints

### Create a Page

**POST** `/v1/pages`

```bash
curl -X POST https://api.notion.com/v1/pages \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  --data '{
    "parent": { "page_id": "xxx" },
    "properties": {
      "title": {
        "title": [{ "type": "text", "text": { "content": "My New Page" } }]
      }
    },
    "children": [
      {
        "object": "block",
        "type": "paragraph",
        "paragraph": {
          "rich_text": [{
            "type": "text",
            "text": { "content": "Page content goes here" }
          }]
        }
      }
    ]
  }'
```

**Parameters:**
- `parent` (required) - Page, database, or workspace parent
- `properties` (required) - Page properties matching parent's schema
- `children` (optional) - Array of block objects for initial content
- `icon` (optional) - Emoji or external file icon
- `cover` (optional) - External or uploaded cover image

**Response:** Returns the created page object with ID

### Update Page Properties

**PATCH** `/v1/pages/{page_id}`

```bash
curl -X PATCH https://api.notion.com/v1/pages/xxx \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  --data '{
    "properties": {
      "Name": {
        "title": [{ "type": "text", "text": { "content": "Updated Title" } }]
      }
    }
  }'
```

**Updatable fields:**
- `properties` - Update specific properties
- `icon` - Change emoji or icon
- `cover` - Change cover image
- `archived` - Archive (true) or unarchive (false)

**Note:** To update page content (blocks), use block endpoints.

## Parent Types

### Page Parent (Standalone Page)
```json
{
  "parent": { "page_id": "parent-page-id" }
}
```

### Database Parent (Database Entry)
```json
{
  "parent": { "database_id": "database-id" }
}
```

### Workspace Parent (Top-level Page)
```json
{
  "parent": { "workspace": true }
}
```

## Property Values for Creating/Updating

### Title
```json
{
  "title": {
    "title": [{ "type": "text", "text": { "content": "Page Title" } }]
  }
}
```

### Rich Text
```json
{
  "Description": {
    "rich_text": [
      {
        "type": "text",
        "text": { "content": "Detailed description" },
        "annotations": { "bold": true }
      }
    ]
  }
}
```

### Number
```json
{
  "Price": {
    "number": 99.99
  }
}
```

### Select
```json
{
  "Status": {
    "select": { "name": "In Progress" }
  }
}
```

### Multi-Select
```json
{
  "Tags": {
    "multi_select": [
      { "name": "urgent" },
      { "name": "bug" }
    ]
  }
}
```

### Date
```json
{
  "Due Date": {
    "date": {
      "start": "2024-12-31",
      "end": null
    }
  }
}
```

With time:
```json
{
  "Due Date": {
    "date": {
      "start": "2024-12-31T14:30:00.000Z",
      "time_zone": "America/New_York"
    }
  }
}
```

Date range:
```json
{
  "Due Date": {
    "date": {
      "start": "2024-12-01",
      "end": "2024-12-31"
    }
  }
}
```

### People
```json
{
  "Assignee": {
    "people": [
      { "id": "user-id-1" },
      { "id": "user-id-2" }
    ]
  }
}
```

### Files (External URLs only via API)
```json
{
  "Attachments": {
    "files": [
      {
        "name": "document.pdf",
        "type": "external",
        "external": {
          "url": "https://example.com/document.pdf"
        }
      }
    ]
  }
}
```

### Checkbox
```json
{
  "Completed": {
    "checkbox": true
  }
}
```

### URL
```json
{
  "Website": {
    "url": "https://example.com"
  }
}
```

### Email
```json
{
  "Contact Email": {
    "email": "user@example.com"
  }
}
```

### Phone Number
```json
{
  "Phone": {
    "phone_number": "+1-555-123-4567"
  }
}
```

### Relation
```json
{
  "Related Tasks": {
    "relation": [
      { "id": "page-id-1" },
      { "id": "page-id-2" }
    ]
  }
}
```

### Status
```json
{
  "Status": {
    "status": { "name": "In progress" }
  }
}
```

## Clearing Property Values

Set property to empty value:

```json
{
  "Due Date": { "date": null },
  "Tags": { "multi_select": [] },
  "Assignee": { "people": [] },
  "Description": { "rich_text": [] }
}
```

## Icons and Covers

### Emoji Icon
```json
{
  "icon": {
    "type": "emoji",
    "emoji": "🚀"
  }
}
```

### External Icon
```json
{
  "icon": {
    "type": "external",
    "external": { "url": "https://example.com/icon.png" }
  }
}
```

### External Cover
```json
{
  "cover": {
    "type": "external",
    "external": { "url": "https://example.com/cover.jpg" }
  }
}
```

## Common Use Cases

### Create Standalone Page with Content

```javascript
const page = await notion.pages.create({
  parent: { page_id: 'parent-page-id' },
  properties: {
    title: {
      title: [{ type: 'text', text: { content: 'Meeting Notes' } }]
    }
  },
  icon: { type: 'emoji', emoji: '📝' },
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
    }
  ]
});
```

### Add Entry to Database

```javascript
const page = await notion.pages.create({
  parent: { database_id: 'database-id' },
  properties: {
    'Task Name': {
      title: [{ type: 'text', text: { content: 'Implement feature' } }]
    },
    'Status': {
      select: { name: 'In Progress' }
    },
    'Priority': {
      select: { name: 'High' }
    },
    'Assignee': {
      people: [{ id: 'user-id' }]
    },
    'Due Date': {
      date: { start: '2024-12-31' }
    },
    'Tags': {
      multi_select: [
        { name: 'feature' },
        { name: 'backend' }
      ]
    },
    'Estimate': {
      number: 5
    }
  }
});
```

### Update Multiple Properties

```javascript
await notion.pages.update({
  page_id: 'page-id',
  properties: {
    'Status': { select: { name: 'Done' } },
    'Completed': { checkbox: true },
    'Completed Date': { date: { start: '2024-11-05' } },
    'Notes': {
      rich_text: [
        { type: 'text', text: { content: 'Completed on time' } }
      ]
    }
  }
});
```

### Archive a Page

```javascript
await notion.pages.update({
  page_id: 'page-id',
  archived: true
});
```

### Restore Archived Page

```javascript
await notion.pages.update({
  page_id: 'page-id',
  archived: false
});
```

### Update Icon and Cover

```javascript
await notion.pages.update({
  page_id: 'page-id',
  icon: {
    type: 'emoji',
    emoji: '✅'
  },
  cover: {
    type: 'external',
    external: { url: 'https://example.com/success-banner.jpg' }
  }
});
```

## Best Practices

1. **Match Schema:** Page properties must match database schema when creating database entries
2. **Rich Text:** Always use rich text format, never plain strings
3. **Store IDs:** Save page IDs when creating for future updates
4. **Batch Content:** Create pages with initial content in one request when possible
5. **Permissions:** Share parent page/database with integration before creating
6. **Select Options:** Options auto-create if they don't exist in schema
7. **Relations:** Related pages' databases must be shared with integration
8. **Validation:** Validate property types before sending to API
