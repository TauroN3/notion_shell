# Creating and Updating Databases

## Database Overview

Databases are collections of pages with a defined schema. When creating a database, you define the properties (columns) that all entries will have.

## API Endpoints

### Create a Database

**POST** `/v1/databases`

```bash
curl -X POST https://api.notion.com/v1/databases \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  --data '{
    "parent": { "page_id": "xxx" },
    "title": [
      { "type": "text", "text": { "content": "My Database" } }
    ],
    "properties": {
      "Name": { "title": {} },
      "Status": {
        "select": {
          "options": [
            { "name": "Not Started", "color": "red" },
            { "name": "Done", "color": "green" }
          ]
        }
      }
    }
  }'
```

**Parameters:**
- `parent` (required) - Page parent where database will be created
- `title` (required) - Database title as rich text array
- `properties` (required) - Database schema (must include one "title" property)
- `icon` (optional) - Emoji or external icon
- `cover` (optional) - Cover image
- `description` (optional) - Database description as rich text array

### Update a Database

**PATCH** `/v1/databases/{database_id}`

```bash
curl -X PATCH https://api.notion.com/v1/databases/xxx \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  --data '{
    "title": [
      { "type": "text", "text": { "content": "Updated Database" } }
    ],
    "properties": {
      "New Property": { "rich_text": {} },
      "Old Property": null
    }
  }'
```

**Updatable fields:**
- `title` - Database name
- `description` - Database description
- `properties` - Add properties (new objects) or remove (set to null)
- `icon` - Change icon
- `cover` - Change cover

## Property Schema Definitions

Every database must have exactly ONE property with type "title".

### Title (Required)
```json
{
  "Name": {
    "title": {}
  }
}
```

### Rich Text
```json
{
  "Description": {
    "rich_text": {}
  }
}
```

### Number
```json
{
  "Price": {
    "number": {
      "format": "dollar"
    }
  }
}
```

Formats: `number`, `number_with_commas`, `percent`, `dollar`, `euro`, `pound`, `yen`, `ruble`, `rupee`, `won`, `yuan`, and many more currency formats.

### Select
```json
{
  "Status": {
    "select": {
      "options": [
        { "name": "Not Started", "color": "red" },
        { "name": "In Progress", "color": "yellow" },
        { "name": "Done", "color": "green" }
      ]
    }
  }
}
```

Colors: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`

### Multi-Select
```json
{
  "Tags": {
    "multi_select": {
      "options": [
        { "name": "urgent", "color": "red" },
        { "name": "bug", "color": "orange" },
        { "name": "feature", "color": "blue" }
      ]
    }
  }
}
```

### Date
```json
{
  "Due Date": {
    "date": {}
  }
}
```

### People
```json
{
  "Assignee": {
    "people": {}
  }
}
```

### Files
```json
{
  "Attachments": {
    "files": {}
  }
}
```

### Checkbox
```json
{
  "Completed": {
    "checkbox": {}
  }
}
```

### URL
```json
{
  "Website": {
    "url": {}
  }
}
```

### Email
```json
{
  "Contact Email": {
    "email": {}
  }
}
```

### Phone Number
```json
{
  "Phone": {
    "phone_number": {}
  }
}
```

### Formula
```json
{
  "Days Until Due": {
    "formula": {
      "expression": "dateBetween(prop(\"Due Date\"), now(), \"days\")"
    }
  }
}
```

### Relation
```json
{
  "Related Tasks": {
    "relation": {
      "database_id": "other-database-id",
      "single_property": {}
    }
  }
}
```

For two-way relations:
```json
{
  "Related Tasks": {
    "relation": {
      "database_id": "other-database-id",
      "dual_property": {
        "synced_property_name": "Projects"
      }
    }
  }
}
```

### Rollup
```json
{
  "Total Hours": {
    "rollup": {
      "relation_property_name": "Related Tasks",
      "rollup_property_name": "Hours",
      "function": "sum"
    }
  }
}
```

Functions: `count`, `count_values`, `empty`, `not_empty`, `unique`, `show_unique`, `percent_empty`, `percent_not_empty`, `sum`, `average`, `median`, `min`, `max`, `range`, `show_original`

### Status
```json
{
  "Status": {
    "status": {
      "options": [
        { "name": "Not started", "color": "gray" },
        { "name": "In progress", "color": "blue" },
        { "name": "Complete", "color": "green" }
      ],
      "groups": [
        {
          "name": "To-do",
          "color": "gray",
          "option_ids": ["option_id_1"]
        },
        {
          "name": "In progress",
          "color": "blue",
          "option_ids": ["option_id_2"]
        },
        {
          "name": "Complete",
          "color": "green",
          "option_ids": ["option_id_3"]
        }
      ]
    }
  }
}
```

### Automatic Properties (Read-only)

These properties are created with empty config and populated automatically:
```json
{
  "Created": { "created_time": {} },
  "Created By": { "created_by": {} },
  "Last Edited": { "last_edited_time": {} },
  "Last Edited By": { "last_edited_by": {} }
}
```

### Unique ID
```json
{
  "ID": {
    "unique_id": {
      "prefix": "TASK-"
    }
  }
}
```

## Common Use Cases

### Create Full Database Schema

```javascript
const database = await notion.databases.create({
  parent: { page_id: 'parent-page-id' },
  title: [{ type: 'text', text: { content: 'Project Tasks' } }],
  properties: {
    'Task Name': { title: {} },
    'Status': {
      select: {
        options: [
          { name: 'Backlog', color: 'gray' },
          { name: 'In Progress', color: 'blue' },
          { name: 'Review', color: 'yellow' },
          { name: 'Done', color: 'green' }
        ]
      }
    },
    'Priority': {
      select: {
        options: [
          { name: 'High', color: 'red' },
          { name: 'Medium', color: 'yellow' },
          { name: 'Low', color: 'green' }
        ]
      }
    },
    'Assignee': { people: {} },
    'Due Date': { date: {} },
    'Estimate': {
      number: { format: 'number' }
    },
    'Tags': {
      multi_select: {
        options: [
          { name: 'bug', color: 'red' },
          { name: 'feature', color: 'blue' },
          { name: 'docs', color: 'purple' }
        ]
      }
    },
    'Created': { created_time: {} },
    'Last Updated': { last_edited_time: {} }
  }
});
```

### Add Property to Database

```javascript
await notion.databases.update({
  database_id: 'database-id',
  properties: {
    'Sprint': {
      select: {
        options: [
          { name: 'Sprint 1', color: 'blue' },
          { name: 'Sprint 2', color: 'green' }
        ]
      }
    }
  }
});
```

### Remove Property from Database

```javascript
await notion.databases.update({
  database_id: 'database-id',
  properties: {
    'Obsolete Property': null
  }
});
```

### Rename Property

```javascript
await notion.databases.update({
  database_id: 'database-id',
  properties: {
    'old_property_id': {
      name: 'New Name'
    }
  }
});
```

### Update Select Options

```javascript
await notion.databases.update({
  database_id: 'database-id',
  properties: {
    'Status': {
      select: {
        options: [
          { name: 'Backlog', color: 'gray' },
          { name: 'Todo', color: 'red' },
          { name: 'In Progress', color: 'blue' },
          { name: 'Done', color: 'green' }
        ]
      }
    }
  }
});
```

## Best Practices

1. **Schema Size:** Keep database schema under 50KB
2. **One Title:** Every database must have exactly one title property
3. **Property Names:** Use clear, descriptive property names
4. **Select Options:** Define common options upfront (new options auto-create when setting values)
5. **Relations:** Related databases must also be shared with your integration
6. **Permissions:** Share database parent page with integration
7. **Property IDs:** Property IDs are stable even if names change
8. **Formulas:** Test formulas in Notion UI before using in API
