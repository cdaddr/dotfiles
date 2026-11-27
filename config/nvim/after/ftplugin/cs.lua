vim.cmd.compiler("dotnet")
vim.bo.makeprg = vim.bo.makeprg .. " --no-incremental"
