---
cairn: spec
capability: listing
status: current
---

# Listing

## Requirements

### Requirement: Envelope listing
An empty query SHALL list through `envelope list` and a non-empty one search through `envelope search`, the query passed as one argument. The id of a row SHALL be read from its first cell, whatever it holds. Columns SHALL be highlighted by the names of the header row and by virtual column, so optional columns and any table preset highlight right.
