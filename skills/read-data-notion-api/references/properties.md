# Property Types - Reading Values

## Overview

Properties are the structured data in Notion pages. This reference covers how to read and interpret property values.

## Property Value Objects

When you retrieve a page, properties appear as value objects:

```json
{
  "Name": {
    "id": "title",
    "type": "title",
    "title": [
      { "type": "text", "text": { "content": "My Page" } }
    ]
  },
  "Status": {
    "id": "abc123",
    "type": "select",
    "select": {
      "id": "xyz",
      "name": "Done",
      "color": "green"
    }
  }
}
```

## All Property Types

### Title

```json
{
  "Name": {
    "type": "title",
    "title": [
      {
        "type": "text",
        "text": { "content": "Page Title" },
        "plain_text": "Page Title"
      }
    ]
  }
}
```

**Extract value:**
```javascript
const title = page.properties.Name.title[0]?.plain_text || '';
```

### Rich Text

```json
{
  "Description": {
    "type": "rich_text",
    "rich_text": [
      {
        "type": "text",
        "text": { "content": "Detailed description" },
        "plain_text": "Detailed description",
        "annotations": {
          "bold": true,
          "italic": false
        }
      }
    ]
  }
}
```

**Extract value:**
```javascript
const description = page.properties.Description.rich_text
  .map(rt => rt.plain_text).join('');
```

### Number

```json
{
  "Price": {
    "type": "number",
    "number": 99.99
  }
}
```

**Extract value:**
```javascript
const price = page.properties.Price.number || 0;
```

### Select

```json
{
  "Status": {
    "type": "select",
    "select": {
      "id": "yyy",
      "name": "In Progress",
      "color": "yellow"
    }
  }
}
```

**Extract value:**
```javascript
const status = page.properties.Status.select?.name || null;
```

### Multi-Select

```json
{
  "Tags": {
    "type": "multi_select",
    "multi_select": [
      { "id": "xxx", "name": "urgent", "color": "red" },
      { "id": "yyy", "name": "bug", "color": "red" }
    ]
  }
}
```

**Extract value:**
```javascript
const tags = page.properties.Tags.multi_select.map(t => t.name);
```

### Date

```json
{
  "Due Date": {
    "type": "date",
    "date": {
      "start": "2024-12-31",
      "end": null,
      "time_zone": null
    }
  }
}
```

**With time:**
```json
{
  "Due Date": {
    "type": "date",
    "date": {
      "start": "2024-12-31T14:30:00.000Z",
      "end": null,
      "time_zone": "America/New_York"
    }
  }
}
```

**Date range:**
```json
{
  "Due Date": {
    "type": "date",
    "date": {
      "start": "2024-12-01",
      "end": "2024-12-31",
      "time_zone": null
    }
  }
}
```

**Extract value:**
```javascript
const dueDate = page.properties['Due Date'].date?.start || null;
const endDate = page.properties['Due Date'].date?.end || null;
```

### People

```json
{
  "Assignee": {
    "type": "people",
    "people": [
      {
        "object": "user",
        "id": "user-id-1",
        "name": "John Doe",
        "avatar_url": "https://..."
      }
    ]
  }
}
```

**Extract value:**
```javascript
const assignees = page.properties.Assignee.people.map(p => ({
  id: p.id,
  name: p.name
}));
```

### Files

```json
{
  "Attachments": {
    "type": "files",
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
        "type": "file",
        "file": {
          "url": "https://s3.aws...",
          "expiry_time": "2024-12-31T23:59:59.999Z"
        }
      }
    ]
  }
}
```

**Extract value:**
```javascript
const files = page.properties.Attachments.files.map(f => ({
  name: f.name,
  url: f.type === 'external' ? f.external.url : f.file.url
}));
```

### Checkbox

```json
{
  "Completed": {
    "type": "checkbox",
    "checkbox": true
  }
}
```

**Extract value:**
```javascript
const completed = page.properties.Completed.checkbox;
```

### URL

```json
{
  "Website": {
    "type": "url",
    "url": "https://example.com"
  }
}
```

**Extract value:**
```javascript
const website = page.properties.Website.url || null;
```

### Email

```json
{
  "Contact Email": {
    "type": "email",
    "email": "user@example.com"
  }
}
```

**Extract value:**
```javascript
const email = page.properties['Contact Email'].email || null;
```

### Phone Number

```json
{
  "Phone": {
    "type": "phone_number",
    "phone_number": "+1-555-123-4567"
  }
}
```

**Extract value:**
```javascript
const phone = page.properties.Phone.phone_number || null;
```

### Formula (Read-only)

```json
{
  "Days Until Due": {
    "type": "formula",
    "formula": {
      "type": "number",
      "number": 25
    }
  }
}
```

Formula results can be: `string`, `number`, `boolean`, `date`

**Extract value:**
```javascript
const formula = page.properties['Days Until Due'].formula;
const value = formula[formula.type]; // Gets the value based on type
```

### Relation

```json
{
  "Related Tasks": {
    "type": "relation",
    "relation": [
      { "id": "page-id-1" },
      { "id": "page-id-2" }
    ],
    "has_more": false
  }
}
```

**Extract value:**
```javascript
const relatedIds = page.properties['Related Tasks'].relation.map(r => r.id);
```

### Rollup (Read-only)

```json
{
  "Total Hours": {
    "type": "rollup",
    "rollup": {
      "type": "number",
      "number": 42,
      "function": "sum"
    }
  }
}
```

**Extract value:**
```javascript
const rollup = page.properties['Total Hours'].rollup;
const value = rollup[rollup.type];
```

### Status

```json
{
  "Status": {
    "type": "status",
    "status": {
      "id": "yyy",
      "name": "In progress",
      "color": "blue"
    }
  }
}
```

**Extract value:**
```javascript
const status = page.properties.Status.status?.name || null;
```

### Created Time (Read-only)

```json
{
  "Created": {
    "type": "created_time",
    "created_time": "2024-01-01T12:00:00.000Z"
  }
}
```

**Extract value:**
```javascript
const createdTime = new Date(page.properties.Created.created_time);
```

### Created By (Read-only)

```json
{
  "Created By": {
    "type": "created_by",
    "created_by": {
      "object": "user",
      "id": "user-id"
    }
  }
}
```

### Last Edited Time (Read-only)

```json
{
  "Last Edited": {
    "type": "last_edited_time",
    "last_edited_time": "2024-01-01T15:30:00.000Z"
  }
}
```

### Last Edited By (Read-only)

```json
{
  "Last Edited By": {
    "type": "last_edited_by",
    "last_edited_by": {
      "object": "user",
      "id": "user-id"
    }
  }
}
```

### Unique ID (Read-only)

```json
{
  "ID": {
    "type": "unique_id",
    "unique_id": {
      "number": 42,
      "prefix": "TASK-"
    }
  }
}
```

Displays as "TASK-42" in Notion.

**Extract value:**
```javascript
const uniqueId = page.properties.ID.unique_id;
const display = `${uniqueId.prefix || ''}${uniqueId.number}`;
```

## Paginated Properties

Some property values (rollup, relation with many items) may be too large for the page response.

**Get paginated property:**
```bash
GET /v1/pages/{page_id}/properties/{property_id}
```

```javascript
const propertyItems = await notion.pages.properties.retrieve({
  page_id: 'page-id',
  property_id: 'property-id'
});
```

## Common Patterns

### Extract All Properties

```javascript
function extractProperties(page) {
  const props = {};

  for (const [name, prop] of Object.entries(page.properties)) {
    switch (prop.type) {
      case 'title':
        props[name] = prop.title[0]?.plain_text || '';
        break;
      case 'rich_text':
        props[name] = prop.rich_text.map(rt => rt.plain_text).join('');
        break;
      case 'number':
        props[name] = prop.number;
        break;
      case 'select':
        props[name] = prop.select?.name || null;
        break;
      case 'multi_select':
        props[name] = prop.multi_select.map(s => s.name);
        break;
      case 'date':
        props[name] = prop.date?.start || null;
        break;
      case 'checkbox':
        props[name] = prop.checkbox;
        break;
      case 'url':
        props[name] = prop.url;
        break;
      case 'email':
        props[name] = prop.email;
        break;
      case 'phone_number':
        props[name] = prop.phone_number;
        break;
      case 'formula':
        props[name] = prop.formula[prop.formula.type];
        break;
      case 'relation':
        props[name] = prop.relation.map(r => r.id);
        break;
      case 'rollup':
        props[name] = prop.rollup[prop.rollup.type];
        break;
      case 'people':
        props[name] = prop.people.map(p => p.id);
        break;
      case 'files':
        props[name] = prop.files.map(f =>
          f.type === 'external' ? f.external.url : f.file.url
        );
        break;
      case 'status':
        props[name] = prop.status?.name || null;
        break;
      case 'created_time':
      case 'last_edited_time':
        props[name] = prop[prop.type];
        break;
      case 'created_by':
      case 'last_edited_by':
        props[name] = prop[prop.type].id;
        break;
      case 'unique_id':
        props[name] = `${prop.unique_id.prefix || ''}${prop.unique_id.number}`;
        break;
    }
  }

  return props;
}
```

## Best Practices

1. **Null Checks:** Always check for null/undefined values
2. **Rich Text Arrays:** Title and rich_text are arrays - handle empty arrays
3. **Property IDs:** Use IDs instead of names for stability
4. **Pagination:** Handle paginated properties for relation/rollup with many values
5. **Dates:** Parse dates using `new Date()` for manipulation
6. **File URLs:** Notion-hosted files have expiry times - don't cache long-term
