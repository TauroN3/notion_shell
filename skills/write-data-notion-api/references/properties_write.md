# Property Values - Writing Data

## Overview

When creating or updating pages, you must provide property values in the correct format. This reference shows how to set each property type.

## Setting Property Values

### Title (Required for all pages)
```json
{
  "Name": {
    "title": [
      {
        "type": "text",
        "text": { "content": "Page Title" }
      }
    ]
  }
}
```

With formatting:
```json
{
  "Name": {
    "title": [
      {
        "type": "text",
        "text": { "content": "Important: " },
        "annotations": { "bold": true }
      },
      {
        "type": "text",
        "text": { "content": "Page Title" }
      }
    ]
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
        "text": { "content": "Description text" }
      }
    ]
  }
}
```

With formatting:
```json
{
  "Description": {
    "rich_text": [
      {
        "type": "text",
        "text": { "content": "Bold text" },
        "annotations": { "bold": true }
      },
      {
        "type": "text",
        "text": { "content": " and " }
      },
      {
        "type": "text",
        "text": { "content": "italic text" },
        "annotations": { "italic": true }
      }
    ]
  }
}
```

With link:
```json
{
  "Description": {
    "rich_text": [
      {
        "type": "text",
        "text": {
          "content": "Click here",
          "link": { "url": "https://example.com" }
        }
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
    "select": {
      "name": "In Progress"
    }
  }
}
```

Or by ID:
```json
{
  "Status": {
    "select": {
      "id": "option-id"
    }
  }
}
```

**Note:** If the option name doesn't exist, it will be auto-created.

### Multi-Select
```json
{
  "Tags": {
    "multi_select": [
      { "name": "urgent" },
      { "name": "bug" },
      { "name": "backend" }
    ]
  }
}
```

### Date

Date only:
```json
{
  "Due Date": {
    "date": {
      "start": "2024-12-31"
    }
  }
}
```

Date with time:
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
  "Event Period": {
    "date": {
      "start": "2024-12-01",
      "end": "2024-12-31"
    }
  }
}
```

Date range with time:
```json
{
  "Event Period": {
    "date": {
      "start": "2024-12-01T09:00:00.000Z",
      "end": "2024-12-01T17:00:00.000Z",
      "time_zone": "America/New_York"
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

### Files (External URLs only)
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
      },
      {
        "name": "image.png",
        "type": "external",
        "external": {
          "url": "https://example.com/image.png"
        }
      }
    ]
  }
}
```

**Note:** You can only add external file URLs via API. Notion-hosted files cannot be created via API.

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

**Important:** The related database must be shared with your integration.

### Status
```json
{
  "Status": {
    "status": {
      "name": "In progress"
    }
  }
}
```

Or by ID:
```json
{
  "Status": {
    "status": {
      "id": "status-option-id"
    }
  }
}
```

## Read-Only Properties

These properties cannot be set via API - they are computed automatically:

- `formula` - Computed from formula expression
- `rollup` - Aggregated from related pages
- `created_time` - Set when page is created
- `created_by` - Set to creating user/integration
- `last_edited_time` - Updated on any edit
- `last_edited_by` - Updated to editing user/integration
- `unique_id` - Auto-incremented

## Clearing Property Values

To clear a property value, set it to null or empty:

### Clear single value properties
```json
{
  "Due Date": { "date": null },
  "Status": { "select": null },
  "Website": { "url": null },
  "Email": { "email": null },
  "Phone": { "phone_number": null },
  "Priority": { "number": null }
}
```

### Clear array properties
```json
{
  "Tags": { "multi_select": [] },
  "Assignee": { "people": [] },
  "Related Tasks": { "relation": [] },
  "Attachments": { "files": [] },
  "Description": { "rich_text": [] }
}
```

## Rich Text Annotations

All rich text supports these annotations:

```json
{
  "type": "text",
  "text": { "content": "Formatted text" },
  "annotations": {
    "bold": false,
    "italic": false,
    "underline": false,
    "strikethrough": false,
    "code": false,
    "color": "default"
  }
}
```

Colors: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`, and background versions like `gray_background`.

## Rich Text Types

### Text
```json
{
  "type": "text",
  "text": {
    "content": "Plain text",
    "link": null
  }
}
```

### Text with Link
```json
{
  "type": "text",
  "text": {
    "content": "Link text",
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

### Mention Database
```json
{
  "type": "mention",
  "mention": {
    "type": "database",
    "database": { "id": "database-id" }
  }
}
```

### Mention Date
```json
{
  "type": "mention",
  "mention": {
    "type": "date",
    "date": {
      "start": "2024-12-31",
      "end": null
    }
  }
}
```

### Equation (inline)
```json
{
  "type": "equation",
  "equation": {
    "expression": "x^2 + y^2 = z^2"
  }
}
```

## Common Patterns

### Create Page with All Property Types

```javascript
await notion.pages.create({
  parent: { database_id: 'database-id' },
  properties: {
    'Task Name': {
      title: [{ type: 'text', text: { content: 'Complete project' } }]
    },
    'Description': {
      rich_text: [
        { type: 'text', text: { content: 'Important task with ' } },
        {
          type: 'text',
          text: { content: 'deadline' },
          annotations: { bold: true, color: 'red' }
        }
      ]
    },
    'Status': {
      select: { name: 'In Progress' }
    },
    'Priority': {
      select: { name: 'High' }
    },
    'Tags': {
      multi_select: [
        { name: 'urgent' },
        { name: 'client' }
      ]
    },
    'Due Date': {
      date: { start: '2024-12-31' }
    },
    'Assignee': {
      people: [{ id: 'user-id' }]
    },
    'Estimate': {
      number: 8
    },
    'Completed': {
      checkbox: false
    },
    'Documentation': {
      url: 'https://docs.example.com'
    },
    'Contact': {
      email: 'team@example.com'
    },
    'Related Projects': {
      relation: [{ id: 'project-page-id' }]
    }
  }
});
```

### Update Specific Properties

```javascript
await notion.pages.update({
  page_id: 'page-id',
  properties: {
    'Status': { select: { name: 'Done' } },
    'Completed': { checkbox: true },
    'Actual Hours': { number: 10 }
  }
});
```

### Clear Multiple Properties

```javascript
await notion.pages.update({
  page_id: 'page-id',
  properties: {
    'Due Date': { date: null },
    'Assignee': { people: [] },
    'Tags': { multi_select: [] }
  }
});
```

## Best Practices

1. **Match Schema:** Property values must match database property types
2. **Rich Text Arrays:** Title and rich_text are always arrays
3. **Select Auto-Create:** New select/multi-select options are auto-created
4. **Dates:** Use ISO 8601 format
5. **People IDs:** Get user IDs from Users API or existing page properties
6. **Relations:** Related databases must be shared with integration
7. **Validation:** Validate property formats before API calls
8. **Read-Only:** Don't attempt to set formula, rollup, or timestamp properties
