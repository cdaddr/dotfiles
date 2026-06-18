-- C# LSP (official Microsoft Roslyn server) for MonoGame / dotnet projects.
-- The server binary is the `roslyn-language-server` dotnet global tool (see setup.py);
-- roslyn.nvim finds it on PATH, picks the .sln/.csproj, and auto-enables the LSP.
vim.pack.add({ "https://github.com/seblyng/roslyn.nvim" })

require("roslyn").setup({
  -- search up *and* down from the buffer for a solution; handy when opening a
  -- file before nvim's cwd is at the project root.
  broad_search = true,
})

-- nvim treats .csproj/.props/.targets as plain xml by default; tag them so the
-- xml treesitter parser + highlighting kick in.
vim.filetype.add({
  extension = {
    csproj = "xml",
    props = "xml",
    targets = "xml",
  },
})
