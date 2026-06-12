local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	s("def", fmta(
		[[
def <>(<>):
    <>
]],
		{ i(1, "name"), i(2), i(0) }
	)),

	s("defm", fmta(
		[[
def <>(self<>):
    <>
]],
		{ i(1, "name"), i(2), i(0) }
	)),

	s("cls", fmta(
		[[
class <>:
    def __init__(self<>):
        <>
]],
		{ i(1, "Name"), i(2), i(0) }
	)),

	s("main", fmta(
		[[
if __name__ == "__main__":
    <>
]],
		{ i(0, "main()") }
	)),

	s("try", fmta(
		[[
try:
    <>
except <> as <>:
    <>
]],
		{ i(1), i(2, "Exception"), i(3, "e"), i(0) }
	)),

	s("with", fmta(
		[[
with open(<>) as <>:
    <>
]],
		{ i(1, '"path"'), i(2, "f"), i(0) }
	)),

	s("for", fmta(
		[[
for <> in <>:
    <>
]],
		{ i(1, "item"), i(2, "items"), i(0) }
	)),

	s("pr", fmta('print(f"<>")', { i(0) })),
}
