---@diagnostic disable: undefined-global

return {
  -- math modes
  s({ trig = "mt", snippetType = "autosnippet" },
    fmta("$<>$ ", { i(1) })
  ),
  s({ trig = "mmt", snippetType = "autosnippet" },
    fmta("$ <> $ ", { i(1) })
  ),
  s({ trig = "i" },
    fmt("==>", {})
  ),
  s({ trig = "cent" },
    fmta("#align(center)[<>]", { i(1) })
  ),
  s({ trig = "p" },
    fmta([[_Proof_: $quad$ <>]], { i(1) })
  ),
  s({ trig = "pi" },
    fmta([[
_Proof_: We use induction on $n$. \
Base case: For $n=1$, $<>$ \
Inductive Step: Suppose now as inductive hypothesis that $<>$. Then since <>
    ]], { i(1), i(2), i(3) })
  ),
  s({ trig = "v" },
    fmta("#let <> = <>", { i(1), i(2) })
  ),
  s({ trig = "f" },
    fmta([[
#let <> = (<>) = {
<>
}]], { i(1), i(2), i(3) })
  ),

  -- ───────────────────────────────────────
  --          modern-mla templates
  -- ───────────────────────────────────────

  s({ trig = "mlat" },
    fmta([[
#import "@preview/modern-mla:0.1.0": *

#show: mla.with(
  title:      "<>",
  author: (
    firstname: "<>",
    lastname:  "<>"
  ),
  professor:  "<>",           // none or "Prof. Smith"
  course:     "<>",           // [English 101] or none
  date:       "<>",           // [February 27, 2026] or datetime.today()...
  bibliography-file: none,
)

<>
    ]],
    { i(1, "Title of the Paper"),
      i(2, "First"),
      i(3, "Last"),
      i(4, "Prof. Jane Doe"),
      i(5, "English 102"),
      i(6, "February 27, 2026"),
      i(0) }
  ),

  s({ trig = "mlamin" },
    fmta([[
#import "@preview/modern-mla:0.1.0": *

#show: mla.with(
  title:  "<>",
  author: (
    firstname: "<>",
    lastname:  "<>"
  ),
)

<>
    ]],
    { i(1, "My Essay Title"),
      i(2, "Your"),
      i(3, "Name"),
      i(0) }
  )
}
