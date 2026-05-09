-- cv-shortcodes.lua
--
-- Pandoc lua filter that rewrites Zola/Tera shortcodes used in
-- content/cv/_index.md into structure pandoc can render to typst,
-- using the helpers defined by templates/pandoc-cv.typ.
--
-- Handles:
--   {% cv_entry(title=..., org=..., meta=...) %} body {% end %}
--   {{ cv_entry(title=..., org=..., meta=...) }}    (inline form, no body)
--   {{ icon_link(icon=..., url=..., label=...) }}   (inline list items)
--   {{ skills(list="a, b, c") }}                    (single paragraph)
--   <figure class="cv-margin-photo">…</figure>      (dropped)
--
-- Section-specific transforms:
--   "Highlights"         bullet list wrapped in #[#set list(spacing: 0.7em) … ]
--   "Education"          entries -> #edu(...)
--   "Experience"         entries -> #work(...)
--   "Research Software"  entries -> #work(...)
--   "Teaching Portfolio" entries -> #work(...)
--   "Conferences"        entries -> #work(...) cells inside a single-column
--                          #grid(gutter: 1em, …) so each conference gets its
--                          own breathing room.
--   "Coursework"         flattens each cv_entry's bullets into a "; "-joined
--                          inline body and emits #course-group(title, dates,
--                          body); whole section wrapped in #[ … ].
--   "Online Learning"    bullets prefixed with brand icon
--   "Links"              bullet list flattened to a single " · "-joined line
--                          wrapped in #align(center)[…].

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

local WORK_SECTIONS = {
  ["Experience"] = true,
  ["Research Software"] = true,
  ["Teaching Portfolio"] = true,
  ["Conferences"] = true,
}

local function entry_blocks(args, section)
  if section == "Education" then
    return { pandoc.RawBlock("typst", "\n" .. edu_call(args)) }
  elseif WORK_SECTIONS[section] then
    return { pandoc.RawBlock("typst", "\n" .. work_call(args)) }
  else
    local out = {}
    table.insert(out, pandoc.Header(3, args.title or "Untitled"))
    local parts = {}
    if args.org and args.org ~= "" then table.insert(parts, args.org) end
    if args.meta and args.meta ~= "" then table.insert(parts, args.meta) end
    if #parts > 0 then
      table.insert(out, pandoc.Para({ pandoc.Emph({ pandoc.Str(table.concat(parts, " · ")) }) }))
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

local PLATFORM_ICONS = {
  DataCamp = "/static/icons/datacamp.svg",
  Exercism = "/static/icons/exercism.svg",
}

local LINK_ICONS = {
  orcid    = "/static/icons/orcid.svg",
  github   = "/static/icons/github.svg",
  linkedin = "/static/icons/linkedin.svg",
  datacamp = "/static/icons/datacamp.svg",
  exercism = "/static/icons/exercism.svg",
  mail     = "/static/icons/mail.svg",
}

local function prefix_item_with_icon(item)
  local item_text = pandoc.utils.stringify(item)
  local icon_path
  for keyword, path in pairs(PLATFORM_ICONS) do
    if item_text:find(keyword) then
      icon_path = path
      break
    end
  end
  if not icon_path then return item end
  local icon_inline = pandoc.RawInline(
    "typst",
    string.format('#box(image("%s", height: 0.9em)) ', icon_path)
  )
  local first = item[1]
  if first and (first.t == "Para" or first.t == "Plain") then
    local new_inlines = pandoc.List()
    new_inlines:insert(icon_inline)
    for _, ii in ipairs(first.content) do new_inlines:insert(ii) end
    local new_item = pandoc.List()
    new_item:insert(pandoc.Plain(new_inlines))
    for j = 2, #item do new_item:insert(item[j]) end
    return new_item
  end
  return item
end

local function flatten_bullet_list(bl, sep)
  sep = sep or " · "
  local inlines = pandoc.List()
  for i, item in ipairs(bl.content) do
    if i > 1 then
      inlines:insert(pandoc.Str(sep))
    end
    for _, blk in ipairs(item) do
      if blk.t == "Para" or blk.t == "Plain" then
        for _, ii in ipairs(blk.content) do inlines:insert(ii) end
      end
    end
  end
  return pandoc.Para(inlines)
end

-- Parse "Title (2010–2013)" -> title, dates.
local function split_title_dates(s)
  local title, dates = s:match("^(.-)%s*%((.-)%)%s*$")
  if title and dates then return title, dates end
  return s, ""
end

local function inlines_to_typst(inlines)
  return pandoc.write(pandoc.Pandoc({ pandoc.Plain(inlines) }), "typst")
    :gsub("\n+$", "")
end

local function blocks_to_typst(blocks)
  return pandoc.write(pandoc.Pandoc(blocks), "typst")
end

function Pandoc(doc)
  local out = pandoc.List()
  local current_section = nil

  -- Conferences: collect entries into grid cells and emit one #grid call.
  local conf_cells = pandoc.List()
  local conf_cell = pandoc.List()
  local in_conferences = false

  -- Coursework: pending (title, dates) waiting for the bullets that follow.
  local pending_course = nil
  local in_coursework = false

  local function flush_conf_cell()
    if #conf_cell > 0 then
      conf_cells:insert(conf_cell)
      conf_cell = pandoc.List()
    end
  end

  local function emit_conferences()
    flush_conf_cell()
    if #conf_cells == 0 then
      in_conferences = false
      return
    end
    local parts = {}
    table.insert(parts, "#grid(\n  columns: 1,\n  gutter: 1em,")
    for _, cell in ipairs(conf_cells) do
      local cell_typst = blocks_to_typst(cell)
      table.insert(parts, "  [\n" .. cell_typst .. "  ],")
    end
    table.insert(parts, ")")
    out:insert(pandoc.RawBlock("typst", "\n" .. table.concat(parts, "\n")))
    conf_cells = pandoc.List()
    in_conferences = false
  end

  local function flush_pending_course()
    if pending_course then
      out:insert(pandoc.RawBlock(
        "typst",
        string.format(
          '\n#course-group([%s], [%s], [])',
          pending_course.title,
          pending_course.dates
        )
      ))
      pending_course = nil
    end
  end

  local function close_coursework()
    if in_coursework then
      flush_pending_course()
      out:insert(pandoc.RawBlock("typst", "\n]"))
      in_coursework = false
    end
  end

  local function place(b)
    if in_conferences then
      conf_cell:insert(b)
    else
      out:insert(b)
    end
  end

  local i = 1
  while i <= #doc.blocks do
    local blk = doc.blocks[i]

    if blk.t == "Header" and blk.level == 3
        and current_section == "Publications" then
      out:insert(blk)
      local nxt = doc.blocks[i + 1]
      if nxt and nxt.t == "BulletList" then
        local typst = blocks_to_typst({ nxt })
        out:insert(pandoc.RawBlock(
          "typst",
          "\n#[#set list(spacing: 0.78em)\n#set par(leading: 0.62em)\n" .. typst .. "]"
        ))
        i = i + 1
      end
    elseif blk.t == "Header" and blk.level == 2 then
      if in_conferences then emit_conferences() end
      close_coursework()
      current_section = pandoc.utils.stringify(blk)
      out:insert(blk)
      if current_section == "Conferences" then
        in_conferences = true
        conf_cells = pandoc.List()
        conf_cell = pandoc.List()
      elseif current_section == "Coursework" then
        in_coursework = true
        out:insert(pandoc.RawBlock("typst", "\n#["))
      elseif current_section == "Highlights" then
        -- Wrap the next bullet list in #[#set list(spacing: 0.7em) … ].
        local nxt = doc.blocks[i + 1]
        if nxt and nxt.t == "BulletList" then
          local typst = blocks_to_typst({ nxt })
          out:insert(pandoc.RawBlock(
            "typst",
            "\n#[#set list(spacing: 0.7em)\n" .. typst .. "]"
          ))
          i = i + 1
        end
      elseif current_section == "Links" then
        local nxt = doc.blocks[i + 1]
        if nxt and nxt.t == "BulletList" then
          -- Flatten the bullet list to inline content. The Inlines filter has
          -- already replaced each {{ icon_link(...) }} with a raw-typst inline
          -- that wraps the icon and label, so we just join the items with " · ".
          local parts = pandoc.List()
          for j, item in ipairs(nxt.content) do
            if j > 1 then
              parts:insert(pandoc.RawInline("typst", " #h(0.5em)·#h(0.5em) "))
            end
            for _, ib in ipairs(item) do
              if ib.t == "Para" or ib.t == "Plain" then
                for _, ii in ipairs(ib.content) do parts:insert(ii) end
              end
            end
          end
          local body_typst = inlines_to_typst(parts):gsub("\n+", " ")
          out:insert(pandoc.RawBlock(
            "typst",
            "\n#align(center)[\n" .. body_typst .. "\n]\n"
          ))
          i = i + 1
        end
      end
    elseif blk.t == "RawBlock" and blk.format == "html"
       and blk.text:find("cv%-margin%-photo") then
      -- drop margin-photo figures from PDF
    elseif in_coursework and blk.t == "BulletList" then
      if pending_course then
        local parts = pandoc.List()
        for j, item in ipairs(blk.content) do
          if j > 1 then parts:insert(pandoc.Str("; ")) end
          for _, ib in ipairs(item) do
            if ib.t == "Para" or ib.t == "Plain" then
              for _, ii in ipairs(ib.content) do parts:insert(ii) end
            end
          end
        end
        local body_typst = inlines_to_typst(parts):gsub("\n", " ")
        out:insert(pandoc.RawBlock(
          "typst",
          string.format(
            '\n#course-group([%s], [%s], [%s.])',
            pending_course.title,
            pending_course.dates,
            body_typst
          )
        ))
        pending_course = nil
      end
    elseif blk.t == "BulletList" and current_section == "Online Learning" then
      local new_items = pandoc.List()
      for _, item in ipairs(blk.content) do
        new_items:insert(prefix_item_with_icon(item))
      end
      place(pandoc.BulletList(new_items))
    elseif blk.t == "Para" or blk.t == "Plain" then
      local txt = as_text(blk)
      local args_str = match_block_open(txt) or match_inline_call(txt)
      if args_str then
        local args = parse_args(args_str)
        if in_coursework then
          flush_pending_course()
          local title, dates = split_title_dates(args.title or "")
          pending_course = { title = title, dates = dates }
        elseif in_conferences then
          flush_conf_cell()
          for _, b in ipairs(entry_blocks(args, current_section)) do
            conf_cell:insert(b)
          end
        else
          for _, b in ipairs(entry_blocks(args, current_section)) do
            out:insert(b)
          end
        end
      elseif match_block_end(txt) then
        if in_coursework then
          flush_pending_course()
        end
      else
        local skills_args = match_skills(txt)
        if skills_args then
          local list = skills_args:match('list%s*=%s*"([^"]*)"') or ""
          if list ~= "" then
            local parts = {}
            for skill in list:gmatch("[^,]+") do
              skill = skill:gsub("^%s+", ""):gsub("%s+$", "")
              table.insert(parts,
                string.format('#skill-chip("%s")', escape_typst(skill)))
            end
            place(pandoc.RawBlock("typst", "\n" .. table.concat(parts, " #h(0.4em) ")))
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
  if in_conferences then emit_conferences() end
  close_coursework()
  doc.blocks = out
  return doc
end

-- Rewrite {{ icon_link(...) }} occurrences. If the icon is in LINK_ICONS,
-- emit a raw-typst inline that wraps the link with the icon. Otherwise emit
-- a plain markdown link [label](url).
function Inlines(inlines)
  local txt = pandoc.utils.stringify(inlines)
  if not txt:find("icon_link") then return inlines end
  local replaced, n = txt:gsub("{{%s*icon_link%s*%((.-)%)%s*}}", function(args)
    local icon  = args:match('icon%s*=%s*"([^"]*)"')  or ""
    local url   = args:match('url%s*=%s*"([^"]*)"')   or ""
    local label = args:match('label%s*=%s*"([^"]*)"') or url
    local icon_path = LINK_ICONS[icon]
    if icon_path and url ~= "" then
      return string.format(
        '`#link(%q)[#link-icon(%q, [%s])]`{=typst}',
        url, icon_path, label)
    elseif url ~= "" then
      return string.format("[%s](%s)", label, url)
    else
      return label
    end
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
