# Reading from Databases

## Database Overview

Databases are collections of pages that can be filtered, sorted, and organized. Think of databases as tables where:
- **Columns** = Database properties (schema)
- **Rows** = Pages (items/entries)
- **Cells** = Page property values

## Database Object Structure

```json
{
  "object": "database",
  "id": "2f26ee68-df30-4251-aad4-8ddc420cba3d",
  "created_time": "2020-03-17T19:10:00.000Z",
  "last_edited_time": "2020-03-17T21:49:00.000Z",
  "title": [
    { "type": "text", "text": { "content": "Tasks" } }
  ],
  "description": [
    { "type": "text", "text": { "content": "Project tasks database" } }
  ],
  "icon": { "type": "emoji", "emoji": "?" },
  "cover": null,
  "properties": {
    "Name": {
      "id": "title",
      "name": "Name",
      "type": "title",
      "title": {}
    },
    "Status": {
      "id": "status_id",
      "name": "Status",
      "type": "select",
      "select": {
        "options": [
          { "name": "Not Started", "color": "red" },
          { "name": "In Progress", "color": "yellow" },
          { "name": "Done", "color": "green" }
        ]
      }
    }
  },
  "parent": {
    "type": "page_id",
    "page_id": "xxx"
  },
  "url": "https://www.notion.so/xxx",
  "archived": false,
  "is_inline": false
}
```

## Finding Database IDs

### From Notion URL
1. Open database as full page in Notion
2. Use Share menu → Copy link
3. Extract from URL: `https://www.notion.so/{workspace}/{database_id}?v={view_id}`
4. The 32-character string is your database ID (hyphens optional)

### Via API
- Use Search endpoint to find databases by title
- Store IDs when creating databases programmatically

## API Endpoints

### Retrieve a Database

**GET** `/v1/databases/{database_id}`

```bash
curl https://api.notion.com/v1/databases/xxx \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Notion-Version: 2022-06-28"
```

Returns database object with full schema. To get database entries (pages), use Query Database endpoint.

### Query a Database

**POST** `/v1/databases/{database_id}/query`

The most powerful endpoint - filter, sort, and paginate database entries.

```bash
curl -X POST https://api.notion.com/v1/databases/xxx/query \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  --data '{
    "filter": {
      "property": "Status",
      "select": {
        "equals": "In Progress"
      }
    },
    "sorts": [
      {
        "property": "Due Date",
        "direction": "ascending"
      }
    ],
    "page_size": 100
  }'
```

**Parameters:**
- `filter` (optional) - Filter criteria (see Filters section below)
- `sorts` (optional) - Sort order array (see Sorts section below)
- `page_size` (optional) - Number of results (max 100, default 100)
- `start_cursor` (optional) - Pagination cursor from previous response

**Response:**
```json
{
  "object": "list",
  "results": [...], // Array of page objects
  "has_more": true,
  "next_cursor": "xxx",
  "type": "page"
}
```

## Database Filters

Filters find pages matching specific criteria. Each property type has different filter conditions.

### Single Property Filter

```json
{
  "property": "Status",
  "select": {
    "equals": "Done"
  }
}
```

### Compound Filters (AND/OR)

**AND - All conditions must match:**
```json
{
  "and": [
    { "property": "Status", "select": { "equals": "In Progress" } },
    { "property": "Priority", "multi_select": { "contains": "High" } }
  ]
}
```

**OR - Any condition must match:**
```json
{
  "or": [
    { "property": "Status", "select": { "equals": "Done" } },
    { "property": "Status", "select": { "equals": "Archived" } }
  ]
}
```

### Filter Conditions by Property Type

**Text (title, rich_text, url, email, phone_number):**
- `equals`, `does_not_equal`, `contains`, `does_not_contain`
- `starts_with`, `ends_with`
- `is_empty`, `is_not_empty`

**Number:**
- `equals`, `does_not_equal`, `greater_than`, `less_than`
- `greater_than_or_equal_to`, `less_than_or_equal_to`
- `is_empty`, `is_not_empty`

**Checkbox:**
- `equals`, `does_not_equal`

**Select:**
- `equals`, `does_not_equal`, `is_empty`, `is_not_empty`

**Multi-select:**
- `contains`, `does_not_contain`, `is_empty`, `is_not_empty`

**Date:**
- `equals`, `before`, `after`, `on_or_before`, `on_or_after`
- `past_week`, `past_month`, `past_year`
- `next_week`, `next_month`, `next_year`
- `this_week` (Monday-Sunday), `is_empty`, `is_not_empty`

**People:**
- `contains`, `does_not_contain`, `is_empty`, `is_not_empty`

**Files:**
- `is_empty`, `is_not_empty`

**Relation:**
- `contains`, `does_not_contain`, `is_empty`, `is_not_empty`

**Formula (depends on formula result type):**
- Same conditions as result type (text, number, date, checkbox)

**Rollup (depends on rollup type):**
- Same conditions as rollup result type

**Timestamps (created_time, last_edited_time):**
- Same conditions as date type

### Filter Examples

**Find completed tasks:**
```json
{
  "filter": {
    "property": "Status",
    "select": { "equals": "Done" }
  }
}
```

**Find high-priority incomplete tasks:**
```json
{
  "filter": {
    "and": [
      { "property": "Status", "select": { "does_not_equal": "Done" } },
      { "property": "Priority", "multi_select": { "contains": "High" } }
    ]
  }
}
```

**Find overdue tasks:**
```json
{
  "filter": {
    "and": [
      { "property": "Due Date", "date": { "before": "2024-11-05" } },
      { "property": "Status", "select": { "does_not_equal": "Done" } }
    ]
  }
}
```

**Find tasks due this week:**
```json
{
  "filter": {
    "property": "Due Date",
    "date": { "this_week": {} }
  }
}
```

## Database Sorts

Sorts order query results by property values or timestamps.

### Sort Object Structure

```json
{
  "property": "Due Date",  // OR use "timestamp"
  "direction": "ascending" // OR "descending"
}
```

### Sort Types

**By Property:**
```json
{
  "property": "Priority",
  "direction": "descending"
}
```

**By Timestamp:**
```json
{
  "timestamp": "created_time",  // OR "last_edited_time"
  "direction": "descending"
}
```

### Multiple Sorts

Array of sort objects applied in order:
```json
{
  "sorts": [
    { "property": "Status", "direction": "ascending" },
    { "property": "Due Date", "direction": "ascending" },
    { "timestamp": "created_time", "direction": "descending" }
  ]
}
```

## Common Use Cases

### Get All Pages in Database

```javascript
// No filter - returns all pages
const response = await notion.databases.query({
  database_id: 'xxx'
});
```

### Get All Pages with Pagination

```javascript
let allPages = [];
let hasMore = true;
let startCursor = undefined;

while (hasMore) {
  const response = await notion.databases.query({
    database_id: 'xxx',
    start_cursor: startCursor,
    page_size: 100
  });

  allPages.push(...response.results);
  hasMore = response.has_more;
  startCursor = response.next_cursor;
}
```

### Complex Query Example

```javascript
const response = await notion.databases.query({
  database_id: 'xxx',
  filter: {
    and: [
      {
        or: [
          { property: 'Status', select: { equals: 'In Progress' } },
          { property: 'Status', select: { equals: 'Not Started' } }
        ]
      },
      { property: 'Assignee', people: { contains: 'user-id' } }
    ]
  },
  sorts: [
    { property: 'Priority', direction: 'ascending' },
    { property: 'Due Date', direction: 'ascending' }
  ]
});
```

## Best Practices

1. **Pagination:** Always handle pagination for databases with many entries
2. **Filtering:** Use filters to reduce API calls and response sizes
3. **Indexing:** Properties are not indexed - complex queries may be slow on large databases
4. **Permissions:** Share database with integration before API access
5. **Property IDs:** Use property names OR property IDs - names are more readable but IDs are stable if names change
6. **Relation Properties:** Related databases must also be shared with your integration

## Linked Databases

Linked databases (identified by ↗ arrow in UI) are views of a source database. They are NOT currently supported by the API. Always share and work with the source database, not linked versions.
