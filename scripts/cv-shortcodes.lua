-- cv-shortcodes.lua
--
-- Pandoc lua filter that rewrites Zola/Tera shortcodes used in
-- content/cv/_index.md into plain markdown structure pandoc can render.
--
-- Handles:
--   {% cv_entry(title=..., org=..., meta=...) %} body {% end %}
--   {{ cv_entry(title=..., org=..., meta=...) }}    (inline form, no body)
--   {{ icon_link(icon=..., url=..., label=...) }}   (inline list items)
--   {{ skills(list="a, b, c") }}                    (single paragraph)
--   <figure class="cv-margin-photo">…</figure>      (dropped)

local function parse_args(s)
  local args = {}
  for k, v in s:gmatch('([%w_%-]+)%s*=%s*"([^"]*)"') do
    args[k] = v
  end
  return args
end

local function meta_line(args)
  local parts = {}
  if args.org and args.org ~= "" then table.insert(parts, args.org) end
  if args.meta and args.meta ~= "" then table.insert(parts, args.meta) end
  return table.concat(parts, " · ")
end

local function entry_blocks(args)
  local out = {}
  table.insert(out, pandoc.Header(3, args.title or "Untitled"))
  local m = meta_line(args)
  if m ~= "" then
    table.insert(out, pandoc.Para({ pandoc.Emph({ pandoc.Str(m) }) }))
  end
  return out
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

function Pandoc(doc)
  local out = pandoc.List()
  for _, blk in ipairs(doc.blocks) do
    if blk.t == "RawBlock" and blk.format == "html"
       and blk.text:find("cv%-margin%-photo") then
      -- drop margin-photo figures from PDF
    elseif blk.t == "Para" or blk.t == "Plain" then
      local txt = as_text(blk)
      local args_str = match_block_open(txt) or match_inline_call(txt)
      if args_str then
        for _, b in ipairs(entry_blocks(parse_args(args_str))) do
          out:insert(b)
        end
      elseif match_block_end(txt) then
        -- drop {% end %}
      else
        local skills_args = match_skills(txt)
        if skills_args then
          local list = skills_args:match('list%s*=%s*"([^"]*)"') or ""
          if list ~= "" then
            out:insert(pandoc.Para({ pandoc.Str(list) }))
          end
        else
          out:insert(blk)
        end
      end
    else
      out:insert(blk)
    end
  end
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
