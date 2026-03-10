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
    t(os.date("%Y-%m-")),           -- static year + month
    i(1, os.date("%d")),            -- jump 1: numeric day (e.g. 09)
    t(" "),
    i(2, os.date("%a")),            -- jump 2: short weekday (e.g. Mon)
    t(">"),
    i(0),                           -- final exit
  }),

	-- 	s("tdate", {
	--   t("<" .. os.date("%Y/%m/")),
	--   i(1, os.date("%d")),
	--   t(">"),
	--   i(0),
	-- }),
}
