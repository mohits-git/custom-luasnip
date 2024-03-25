local ls = require("luasnip")
local extras = require("luasnip.extras")

local s = ls.snippet
local i = ls.insert_node
local rep = extras.rep
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require('luasnip.extras.fmt').fmt

vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

function GetFileName()
    local filePath = vim.fn.expand("%:p:t")
    local fileName = string.gsub(filePath, ".[tj]sx$", "")
    local kebabToPascalCase = fileName:gsub("[-_](%w)", function(c) return c:upper() end)
    local snakeToPascalCase = kebabToPascalCase:gsub("_(%w)", function(c) return c:upper() end)
    return snakeToPascalCase:gsub("^%l", string.upper)
end

function DynamicNode(args)
    if (type(args[0]) == "string") then
        return sn(nil, {
            i(1, args[0])
        })
    end
    local fileName = GetFileName()
    if (fileName) then
        return sn(nil, {
            i(1, fileName)
        })
    end
end

ls.add_snippets("typescriptreact", {
    s("snip", fmt([[
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
    ]], {
        d(1, DynamicNode),
        i(2, 'Hello World'),
        rep(1)
    }))
})

ls.add_snippets("javascriptreact", {
    s("snip", fmt([[
    export default function {}() {{
        return (
            <>
                {}
            </>
        )
    }}
    ]], {
        d(1, DynamicNode),
        i(2, "Hello World"),
    }))
})
