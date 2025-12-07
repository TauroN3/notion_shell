# Quick Reference: Common Write Tasks

This guide provides quick recipes for writing data to Notion.

## Authentication & Setup

### Get Your Integration Token
1. Go to https://www.notion.so/my-integrations
2. Create or select your integration
3. Ensure "Insert content" and "Update content" capabilities are enabled
4. Copy the "Internal Integration Token"
5. Store securely: `NOTION_API_KEY`

### Share Pages with Integration
**Before API access works, you MUST share pages/databases:**
1. Open page in Notion
2. Click ••• menu (top right)
3. Scroll to "Add connections"
4. Search and select your integration

## Database Operations

### Create a New Database
```javascript
const database = await notion.databases.create({
  parent: { page_id: 'parent-page-id' },
  title: [{ type: 'text', text: { content: 'My Database' } }],
  properties: {
    'Name': { title: {} },  // Required: one title property
    'Status': {
      select: {
        options: [
          { name: 'Not Started', color: 'red' },
          { name: 'Done', color: 'green' }
        ]
      }
    },
    'Due Date': { date: {} },
    'Tags': {
      multi_select: {
        options: [
          { name: 'urgent', color: 'red' },
          { name: 'bug', color: 'orange' }
        ]
      }
    }
  }
});
```

### Add Property to Existing Database
```javascript
await notion.databases.update({
  database_id: 'database-id',
  properties: {
    'New Column': { rich_text: {} }
  }
});
```

### Remove Property from Database
```javascript
await notion.databases.update({
  database_id: 'database-id',
  properties: {
    'Column to Remove': null
  }
});
```

### Update Database Title
```javascript
await notion.databases.update({
  database_id: 'database-id',
  title: [{ type: 'text', text: { content: 'New Title' } }]
});
```

## Page Operations

### Create a Simple Page
```javascript
const page = await notion.pages.create({
  parent: { page_id: 'parent-page-id' },
  properties: {
    title: {
      title: [{ type: 'text', text: { content: 'My Page Title' } }]
    }
  }
});
```

### Create Page with Content
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

### Add Page to Database
```javascript
const page = await notion.pages.create({
  parent: { database_id: 'database-id' },
  properties: {
    'Name': {  // Must match database properties
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
    'Completed': { checkbox: true },
    'Notes': {
      rich_text: [
        { type: 'text', text: { content: 'Completed ahead of schedule' } }
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

### Set Page Icon and Cover
```javascript
await notion.pages.update({
  page_id: 'page-id',
  icon: {
    type: 'emoji',
    emoji: '🚀'
  },
  cover: {
    type: 'external',
    external: { url: 'https://example.com/cover.jpg' }
  }
});
```

## Content Operations

### Add Content to Page
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
            text: { content: 'This is a new paragraph' }
          }
        ]
      }
    },
    {
      object: 'block',
      type: 'heading_2',
      heading_2: {
        rich_text: [
          {
            type: 'text',
            text: { content: 'New Section' }
          }
        ]
      }
    }
  ]
});
```

### Update Block Content
```javascript
await notion.blocks.update({
  block_id: 'block-id',
  paragraph: {
    rich_text: [
      {
        type: 'text',
        text: { content: 'Updated paragraph text' }
      }
    ]
  }
});
```

### Delete Block
```javascript
await notion.blocks.delete({
  block_id: 'block-id'
});
```

## Text Formatting

### Bold, Italic, Underline Text
```javascript
{
  type: 'text',
  text: { content: 'Formatted text' },
  annotations: {
    bold: true,
    italic: true,
    underline: true,
    strikethrough: false,
    code: false,
    color: 'default'
  }
}
```

### Colored Text
```javascript
{
  type: 'text',
  text: { content: 'Red text' },
  annotations: {
    bold: false,
    italic: false,
    underline: false,
    strikethrough: false,
    code: false,
    color: 'red'
  }
}
```

Colors: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`

### Text with Link
```javascript
{
  type: 'text',
  text: {
    content: 'Click here',
    link: { url: 'https://example.com' }
  }
}
```

### Inline Code
```javascript
{
  type: 'text',
  text: { content: 'console.log()' },
  annotations: {
    code: true
  }
}
```

### Mention User
```javascript
{
  type: 'mention',
  mention: {
    type: 'user',
    user: { id: 'user-id' }
  }
}
```

### Mention Page
```javascript
{
  type: 'mention',
  mention: {
    type: 'page',
    page: { id: 'page-id' }
  }
}
```

## Complex Structures

### Create Nested List
```javascript
await notion.blocks.children.append({
  block_id: 'page-id',
  children: [
    {
      object: 'block',
      type: 'bulleted_list_item',
      bulleted_list_item: {
        rich_text: [{ type: 'text', text: { content: 'Parent item' } }],
        children: [
          {
            object: 'block',
            type: 'bulleted_list_item',
            bulleted_list_item: {
              rich_text: [{ type: 'text', text: { content: 'Child item 1' } }]
            }
          },
          {
            object: 'block',
            type: 'bulleted_list_item',
            bulleted_list_item: {
              rich_text: [{ type: 'text', text: { content: 'Child item 2' } }]
            }
          }
        ]
      }
    }
  ]
});
```

### Create To-Do List
```javascript
await notion.blocks.children.append({
  block_id: 'page-id',
  children: [
    {
      object: 'block',
      type: 'to_do',
      to_do: {
        rich_text: [{ type: 'text', text: { content: 'Task 1' } }],
        checked: false
      }
    },
    {
      object: 'block',
      type: 'to_do',
      to_do: {
        rich_text: [{ type: 'text', text: { content: 'Task 2' } }],
        checked: true
      }
    }
  ]
});
```

### Add Table
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

const tableId = table.results[0].id;

// 2. Add table rows
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
          [{ type: 'text', text: { content: 'Row 1 Col 1' } }],
          [{ type: 'text', text: { content: 'Row 1 Col 2' } }],
          [{ type: 'text', text: { content: 'Row 1 Col 3' } }]
        ]
      }
    }
  ]
});
```

### Add Image
```javascript
{
  object: 'block',
  type: 'image',
  image: {
    type: 'external',
    external: {
      url: 'https://example.com/image.png'
    },
    caption: [
      { type: 'text', text: { content: 'Image caption' } }
    ]
  }
}
```

### Add Code Block
```javascript
{
  object: 'block',
  type: 'code',
  code: {
    rich_text: [{
      type: 'text',
      text: {
        content: 'function hello() {\n  console.log("Hello!");\n}'
      }
    }],
    language: 'javascript',
    caption: []
  }
}
```

### Add Callout
```javascript
{
  object: 'block',
  type: 'callout',
  callout: {
    rich_text: [{
      type: 'text',
      text: { content: 'Important information here' }
    }],
    icon: {
      type: 'emoji',
      emoji: '💡'
    },
    color: 'blue_background'
  }
}
```

### Add Toggle List
```javascript
{
  object: 'block',
  type: 'toggle',
  toggle: {
    rich_text: [{
      type: 'text',
      text: { content: 'Click to expand' }
    }],
    children: [
      {
        object: 'block',
        type: 'paragraph',
        paragraph: {
          rich_text: [{ type: 'text', text: { content: 'Hidden content' } }]
        }
      }
    ]
  }
}
```

## Comments

### Add Comment to Page
```javascript
await notion.comments.create({
  parent: { page_id: 'page-id' },
  rich_text: [{
    type: 'text',
    text: { content: 'This is a comment' }
  }]
});
```

## Tips & Best Practices

1. **Always share pages** with integration before API access
2. **Store IDs** when creating resources for later use
3. **Use rich text** format for all text, never plain strings
4. **Property Matching:** Page properties must match database schema
5. **Batch operations** when possible (max ~100 blocks per request)
6. **Block limits:** Maximum ~2000 characters per block
7. **Handle rate limits** with exponential backoff
8. **Validate data** before sending to API
9. **Keep tokens secret** - never commit to source control
10. **Select options** are auto-created if they don't exist in schema
