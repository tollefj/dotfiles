local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	s("cl", fmta("console.log(<>)", { i(0) })),

	s("fn", fmta(
		[[
function <>(<>) {
  <>
}
]],
		{ i(1, "name"), i(2), i(0) }
	)),

	s("af", fmta("const <> = (<>) =>> <>", { i(1, "name"), i(2), i(0) })),

	s("afn", fmta(
		[[
const <> = async (<>) =>> {
  <>
}
]],
		{ i(1, "name"), i(2), i(0) }
	)),

	s("imp", fmta('import { <> } from "<>"', { i(1), i(2, "module") })),

	s("int", fmta(
		[[
interface <> {
  <>
}
]],
		{ i(1, "Name"), i(0) }
	)),

	s("cls", fmta(
		[[
class <> {
  constructor(<>) {
    <>
  }
}
]],
		{ i(1, "Name"), i(2), i(0) }
	)),

	s("tc", fmta(
		[[
try {
  <>
} catch (<>) {
  <>
}
]],
		{ i(1), i(2, "error"), i(0) }
	)),

	s("forof", fmta(
		[[
for (const <> of <>) {
  <>
}
]],
		{ i(1, "item"), i(2, "items"), i(0) }
	)),
}
