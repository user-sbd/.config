---@diagnostic disable: undefined-global
--- https://www.lua.org/pil/20.2.html


local ls = require("luasnip")
local s = ls.s
local t = ls.text_node

return {
	s("date", t(os.date("%Y-%m-%d"))),
	s("mail", t("him.nitin@icloud.com")),
	s("gh", t("github.com/user-sbd")),
}
