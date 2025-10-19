---@diagnostic disable: undefined-global

return {
	s("date", t(os.date("%Y/%m/%d"))),
	s("mail", t("him.nitin@icloud.com")),
	s("(", { t("("), i(1), t(")") }),
	s("[", { t("["), i(1), t("]") }),
	s("{", { t("{"), i(1), t("}") }),
	s("<", { t("<"), i(1), t(">") }),
}


