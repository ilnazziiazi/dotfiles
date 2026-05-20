return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_view_skim_sync = 1
    vim.g.vimtex_view_skim_activate = 1

    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      build_dir = "",
      callback = 1,
      continuous = 1,
      executable = "latexmk",
      options = {
        "-pdf",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }

    vim.g.vimtex_quickfix_ignore_filters = {
      "Underfull \\hbox",
      "Overfull \\hbox",
      "LaTeX Warning: .\\+ float specifier changed to",
    }
  end,

  keys = {
    { "<localLeader>ll", "<plug>(vimtex-compile)", desc = "VimTeX: Toggle compile" },
    { "<localLeader>lv", "<plug>(vimtex-view)", desc = "VimTeX: View PDF" },
    { "<localLeader>lc", "<plug>(vimtex-clean)", desc = "VimTeX: Clean aux files" },
  },
}
