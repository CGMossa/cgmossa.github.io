-- cv-shortcodes.lua
--
-- Pandoc lua filter that rewrites Zola/Tera shortcodes used in
-- content/cv/_index.md into structure pandoc can render to typst,
-- using basic-resume helpers (#edu / #work) where applicable.
--
-- Handles:
--   {% cv_entry(title=..., org=..., meta=...) %} body {% end %}
--   {{ cv_entry(title=..., org=..., meta=...) }}    (inline form, no body)
--   {{ icon_link(icon=..., url=..., label=...) }}   (inline list items)
--   {{ skills(list="a, b, c") }}                    (single paragraph)
--   <figure class="cv-margin-photo">…</figure>      (dropped)
--
-- Section-specific transforms:
--   "Education"   entries -> #edu(...)
--   "Experience"  entries -> #work(...)
--   "Conferences" -> #grid(columns: 2, ...)  (one cell per cv_entry)
--   "Coursework"  -> #grid(columns: 3, ...)  (smaller text size)
--   "Links"       bullet list flattened to a single " · "-joined line.

local function parse_args(s)
  local args = {}
  for k, v in s:gmatch('([%w_%-]+)%s*=%s*"([^"]*)"') do
    args[k] = v
  end
  return args
end

local function escape_typst(s)
  if not s then return "" end
  return s:gsub("\\", "\\\\"):gsub('"', '\\"')
end

local function meta_line(args)
  local parts = {}
  if args.org and args.org ~= "" then table.insert(parts, args.org) end
  if args.meta and args.meta ~= "" then table.insert(parts, args.meta) end
  return table.concat(parts, " · ")
end

local function edu_call(args)
  return string.format(
    '#block[#edu(\n  institution: "%s",\n  dates: "%s",\n  degree: "%s",\n)]',
    escape_typst(args.org),
    escape_typst(args.meta),
    escape_typst(args.title)
  )
end

local function work_call(args)
  return string.format(
    '#block[#work(\n  title: "%s",\n  dates: "%s",\n  company: "%s",\n)]',
    escape_typst(args.title),
    escape_typst(args.meta),
    escape_typst(args.org)
  )
end

local function entry_blocks(args, section)
  if section == "Education" then
    return { pandoc.RawBlock("typst", edu_call(args)) }
  elseif section == "Experience" then
    return { pandoc.RawBlock("typst", work_call(args)) }
  else
    local out = {}
    table.insert(out, pandoc.Header(3, args.title or "Untitled"))
    local m = meta_line(args)
    if m ~= "" then
      table.insert(out, pandoc.Para({ pandoc.Emph({ pandoc.Str(m) }) }))
    end
    return out
  end
end

local function as_text(blk)
  return pandoc.utils.stringify(blk):gsub("[\r\n]+", " ")
end

local function match_block_open(txt)
  return txt:match("^%s*{%%%s*cv_entry%s*%((.-)%)%s*%%}%s*$")
end

local function match_inline_call(txt)
  return txt:match("^%s*{{%s*cv_entry%s*%((.-)%)%s*}}%s*$")
end

local function match_block_end(txt)
  return txt:match("^%s*{%%%s*end%s*%%}%s*$")
end

local function match_skills(txt)
  return txt:match("^%s*{{%s*skills%s*%((.-)%)%s*}}%s*$")
end

local function flatten_bullet_list(bl)
  local inlines = pandoc.List()
  for i, item in ipairs(bl.content) do
    if i > 1 then
      inlines:insert(pandoc.Space())
      inlines:insert(pandoc.Str("·"))
      inlines:insert(pandoc.Space())
    end
    for _, blk in ipairs(item) do
      if blk.t == "Para" or blk.t == "Plain" then
        for _, ii in ipairs(blk.content) do inlines:insert(ii) end
      end
    end
  end
  return pandoc.Para(inlines)
end

local SECTION_GRID = {
  Conferences = { count = 2, text_size = nil },
  Coursework  = { count = 3, text_size = "8.5pt" },
}

local function blocks_to_typst(blocks)
  local doc = pandoc.Pandoc(blocks)
  return pandoc.write(doc, "typst")
end

function Pandoc(doc)
  local out = pandoc.List()
  local current_section = nil
  local grid_cfg = nil
  local grid_cells = pandoc.List()
  local current_cell = pandoc.List()

  local function flush_cell()
    if #current_cell > 0 then
      grid_cells:insert(current_cell)
      current_cell = pandoc.List()
    end
  end

  local function emit_grid()
    if not grid_cfg then return end
    flush_cell()
    if #grid_cells == 0 then
      grid_cfg = nil
      return
    end
    local parts = {}
    table.insert(parts, string.format("#grid(\n  columns: %d,\n  gutter: 1em,", grid_cfg.count))
    for _, cell in ipairs(grid_cells) do
      local cell_typst = blocks_to_typst(cell)
      table.insert(parts, "  [\n" .. cell_typst .. "  ],")
    end
    table.insert(parts, ")")
    local grid_call = table.concat(parts, "\n")
    if grid_cfg.text_size then
      grid_call = string.format("#[\n#set text(size: %s)\n%s\n]", grid_cfg.text_size, grid_call)
    end
    out:insert(pandoc.RawBlock("typst", grid_call))
    grid_cells = pandoc.List()
    grid_cfg = nil
  end

  local function place(b)
    if grid_cfg then
      current_cell:insert(b)
    else
      out:insert(b)
    end
  end

  local i = 1
  while i <= #doc.blocks do
    local blk = doc.blocks[i]

    if blk.t == "Header" and blk.level == 2 then
      emit_grid()
      out:insert(blk)
      current_section = pandoc.utils.stringify(blk)
      grid_cfg = SECTION_GRID[current_section]
      grid_cells = pandoc.List()
      current_cell = pandoc.List()
      if current_section == "Links" then
        local nxt = doc.blocks[i + 1]
        if nxt and nxt.t == "BulletList" then
          out:insert(flatten_bullet_list(nxt))
          i = i + 1
        end
      end
    elseif blk.t == "RawBlock" and blk.format == "html"
       and blk.text:find("cv%-margin%-photo") then
      -- drop margin-photo figures from PDF
    elseif blk.t == "Para" or blk.t == "Plain" then
      local txt = as_text(blk)
      local args_str = match_block_open(txt) or match_inline_call(txt)
      if args_str then
        if grid_cfg then
          flush_cell()
          for _, b in ipairs(entry_blocks(parse_args(args_str), current_section)) do
            current_cell:insert(b)
          end
        else
          for _, b in ipairs(entry_blocks(parse_args(args_str), current_section)) do
            out:insert(b)
          end
        end
      elseif match_block_end(txt) then
        -- drop {% end %}
      else
        local skills_args = match_skills(txt)
        if skills_args then
          local list = skills_args:match('list%s*=%s*"([^"]*)"') or ""
          if list ~= "" then
            place(pandoc.Para({ pandoc.Str(list) }))
          end
        else
          place(blk)
        end
      end
    else
      place(blk)
    end
    i = i + 1
  end
  emit_grid()
  doc.blocks = out
  return doc
end

-- Rewrite {{ icon_link(...) }} that appears inline (e.g. in list items)
-- into a plain markdown link [label](url).
function Inlines(inlines)
  local txt = pandoc.utils.stringify(inlines)
  if not txt:find("icon_link") then return inlines end
  local replaced, n = txt:gsub("{{%s*icon_link%s*%((.-)%)%s*}}", function(args)
    local url   = args:match('url%s*=%s*"([^"]*)"')   or ""
    local label = args:match('label%s*=%s*"([^"]*)"') or url
    if url == "" then return label end
    return string.format("[%s](%s)", label, url)
  end)
  if n == 0 then return inlines end
  local doc = pandoc.read(replaced, "markdown")
  local new = pandoc.List()
  for _, blk in ipairs(doc.blocks) do
    if blk.t == "Para" or blk.t == "Plain" then
      for _, ii in ipairs(blk.content) do new:insert(ii) end
    end
  end
  return new
end
