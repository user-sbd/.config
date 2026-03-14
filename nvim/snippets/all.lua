---@diagnostic disable: undefined-global
--- https://www.lua.org/pil/20.2.html

local ls = require("luasnip")
local s = ls.s
local t = ls.text_node
local i = ls.insert_node

return {
	s("odate", t(os.date("%Y-%m-%d"))),
	s("mail", t("him.nitin@icloud.com")),
	s("gh", t("github.com/user-sbd")),
	s("tdate", {
		t("<"),
		t(os.date("%Y-%m-")),
		i(1, os.date("%d")),
		t(" "),
		i(2, os.date("%a")),
		t(">"),
		i(0),
	}),
}
