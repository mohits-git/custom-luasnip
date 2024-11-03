local ls = require 'luasnip'
local extras = require 'luasnip.extras'

local s = ls.snippet
local i = ls.insert_node
local rep = extras.rep
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require('luasnip.extras.fmt').fmt

-- Keybindings
-- control-j or k to jump to next or previous nodes
vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })
--------------------------------------------------

-- Helper function to get file name in PascalCase
function GetFileName()
  local filePath = vim.fn.expand '%:p:t'
  local fileName = string.gsub(filePath, '.[tj]sx$', '')
  local kebabToPascalCase = fileName:gsub('[-_](%w)', function(c)
    return c:upper()
  end)
  local snakeToPascalCase = kebabToPascalCase:gsub('_(%w)', function(c)
    return c:upper()
  end)
  return snakeToPascalCase:gsub('^%l', string.upper)
end

-- Dynamic Node to get file name
function DynamicNode(args)
  if type(args[0]) == 'string' then
    return sn(nil, {
      i(1, args[0]),
    })
  end
  local fileName = GetFileName()
  if fileName then
    return sn(nil, {
      i(1, fileName),
    })
  end
end

-- Inheritence (sort of) -------------------------
-- typescriptreact -> javascriptreact -> typescript -> javascript
ls.filetype_extend('typescriptreact', { 'javascriptreact', 'typescript', 'javascript' });
ls.filetype_extend('javascriptreact', { 'typescript', 'javascript' });
ls.filetype_extend('typescript', { 'javascript' });
--------------------------------------------------

-- React Snippets
ls.add_snippets('typescriptreact', {
  s(
    'tsrfce',
    fmt(
      [[
    import React from "react";

    interface Props {{

    }}

    export function {}({{}}: Props) {{
        return (
            <>
                {}
            </>
        )
    }}
    ]],
      {
        d(1, DynamicNode),
        rep(1),
      }
    )
  ),
})
 -- older version
ls.add_snippets('typescriptreact', {
  s(
    'tsrfce2',
    fmt(
      [[
    import React from "react";

    type Props = {{

    }}

    const {}: React.FC<Props> = () => {{
        return (
            <>
                {}
            </>
        )
    }}

    export default {}
    ]],
      {
        d(1, DynamicNode),
        rep(1),
        rep(1),
      }
    )
  ),
})

ls.add_snippets('javascriptreact', {
  s(
    'jsrefce',
    fmt(
      [[
    export default function {}() {{
        return (
            <>
                {}
            </>
        )
    }}
    ]],
      {
        d(1, DynamicNode),
        rep(1),
      }
    )
  ),
})
--------------------------------------------------

-- React Native snippet ------------------------
ls.add_snippets('typescriptreact', {
  s(
    'rnfe',
    fmt(
      [[
    import {{ View, Text }} from "react-native";

    export function {}() {{
        return (
            <View>
                <Text>{}</Text>
            </View>
        );
    }}
    ]],
      {
        d(1, DynamicNode),
        rep(1),
      }
    )
  ),
})
--------------------------------------------------

-- trycatch, sometimes useful
ls.add_snippets('javascript', {
  s(
    'trycatch',
    fmt(
      [[
    try {{
        {}
    }} catch (error) {{
        console.error(error);
    }}
    ]],
      {
        i(1),
      }
    )
  ),
})
--------------------------------------------------

-- stupid console log snippet
ls.add_snippets('javascript', {
  s('clog', fmt('console.log({})', i(1))),
})
--------------------------------------------------
