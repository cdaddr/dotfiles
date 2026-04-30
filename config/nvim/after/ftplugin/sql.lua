vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.makeprg = "psql -d $DATABASE_URL -f %"
-- psql errors: "psql:file:line: SEVERITY:  message"; ignore context lines
vim.bo.errorformat = [[psql:%f:%l: %trror:  %m,]] .. [[psql:%f:%l: %tARNING:  %m,]] .. [[%m]]
