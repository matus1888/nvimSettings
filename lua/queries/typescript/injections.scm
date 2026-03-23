;TODO!!! 1. Поддержка комментария перед переменной: /* SQL */ const q = `...`
((comment) @injection.language
 (#match? @injection.language "/\\*\\s*SQL\\s*\\*/")
 (#set! injection.language "sql")
 (#combined!))

; 2. Поддержка тега: sql`SELECT ...`
(call_expression
  function: ((identifier) @injection.language (#eq? @injection.language "sql"))
  arguments: (template_string) @injection.content)

; 3. Поддержка внутри методов: db.query(`SELECT ...`)
(call_expression
  function: (member_expression property: (property_identifier) @method)
  (#any-of? @method "query" "execute")
  arguments: (arguments (template_string) @injection.content)
  (#set! injection.language "sql"))
