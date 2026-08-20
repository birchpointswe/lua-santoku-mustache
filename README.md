# santoku-mustache

A Mustache template renderer for the santoku ecosystem, built on base
[`santoku`](../lua-santoku/README.md). It bundles the upstream
[mustach](https://gitlab.com/jobol/mustach) C library and renders templates
against a Lua value. All mustach extensions are enabled
(`Mustach_With_AllExtensions`).

This README is a usage guide, not an API reference. **The tests are the spec**:
`test/spec/santoku/mustache.lua` exercises the full surface; read it for the
exhaustive case list. For Mustache template syntax itself (sections, partials,
delimiters, the comparison and object-iteration extensions), see the upstream
mustach project.

## Surface

The module is a single function. Calling it compiles a template and returns a
render function; calling the render function with data produces a string.

```lua
local mustache = require("santoku.mustache")

local render = mustache("{{greeting}} {{target}}")
render({ greeting = "hello", target = "world" })   -- "hello world"
```

Compile takes an optional second table argument:

- `dedent` (boolean, default `true`): strip the shared leading whitespace from
  every line, then drop a single leading newline. Pass `dedent = false` to keep
  the template verbatim.
- `partials` (table): a name to partial map. Each value is a template string or a
  compiled render function (whose source is reused).

Render takes one argument, the context: a Lua `table`, `number`, `boolean`, or
`nil`. Any other type is a render error.

```lua
-- Lua table context
mustache("{{a.b.c}}")({ a = { b = { c = "value" } } })   -- "value"

-- array section, {{.}} is the current element
mustache("{{#items}}{{.}}{{/items}}")({ items = { 1, 2, 3 } })   -- "123"

-- partials, value may be a string or a compiled render function
local item = mustache("<li>{{.}}</li>")
local list = mustache("{{#items}}{{>item}}{{/items}}", { partials = { item = item } })
list({ items = { 1, 2, 3 } })   -- "<li>1</li><li>2</li><li>3</li>"
```

Covers (`test/spec/santoku/mustache.lua`): variables, missing keys, dot notation,
sections and inverted sections, array and object-list iteration, scalar root
context, nested context, string and compiled partials, dedent on and off, and
HTML escaping (`{{x}}` escaped, `{{{x}}}` and `{{&x}}` raw).

## Conventions

- **Compile once, render many.** `mustache(template)` returns a render closure that
  holds the (optionally dedented) source and its partials; reuse it across calls.
- **Value formatting.** `nil` renders as the empty string, booleans as `"true"` or
  `"false"`, numbers with `"%.14g"`, strings as is.
- **Table shape.** A table with consecutive integer keys from 1 and no holes is
  treated as an array and iterated; any other non-empty table is an object. An
  empty table is falsy for section purposes.
- **Truthiness for sections.** `nil`, `false`, `0`, `""`, and `{}` are falsy;
  everything else is truthy.
- **In-memory partials only.** There is no filesystem lookup; a partial that is not
  in the `partials` table is a render error.
- **Nesting limit.** Sections nest up to 256 levels deep.

## License

Copyright 2025 Birch Point SWE

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the “Software”), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
