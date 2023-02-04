-- use the flag --lua-filter=FILE like this:
-- `--lua-filter=$pandoc/assets/link2html.lua`


function Link(el)
    el.target = string.gsub(el.target, "%.md", ".html")
    return el
end
