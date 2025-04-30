" My vimrc file for NeoVim
"
"
" Required packages:
" * For treesitter: sudo pacman -S extra/tree-sitter-cli extra/tree-sitter
" * For dev icons:
"     * Install patched fonts: sudo pacman -S extra/otf-droid-nerd
"     * Build font information caches: fc-cache -fv
"     * Pick up a font name: fc-list | cut -d: -f2 | sort | uniq | grep Nerd
" * For Ruby LSP: gem install ruby-lsp
" * For COC ruby: gem install solargraph
"     * From the project folder: yard gems
"  * For Telescope: pacman -S fzf ripgrep
"  * Export the COC_NODE env variable to get the COC use a proper Node version
"


""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ List of plugins (vim-plug)
""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin($MYVIMHOME . "/plugged")

" OneDark colorscheme
Plug 'navarasu/onedark.nvim'

" Aniversal set of defaults
Plug 'tpope/vim-sensible'

" Better highlighting based on tree-sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" NvimTree and the fancy icons for it
Plug 'nvim-tree/nvim-web-devicons' " optional
Plug 'nvim-tree/nvim-tree.lua'

" Easier LSP support (autocomplete, code suggestions etc)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Telescope (fuzzy finder) and its dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Telescope file browser (needed because nvim tree can only run one session at
" the time for now)
Plug 'nvim-telescope/telescope-file-browser.nvim'

" Lualine
Plug 'nvim-lualine/lualine.nvim'

" Git blame
Plug 'FabijanZulj/blame.nvim'

" Emmet
Plug 'mattn/emmet-vim'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ General options
""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible       " Disable compatibility with vi which can cause unexpected issues
set number             " Set line numers
set cursorline         " Higlight the current line
set cursorcolumn       " Higlight the current line
set tabstop=2          " Set tab width to 2 spaces by default
set shiftwidth=2       " Set indent width to 2 spaces by default
set expandtab          " Use whitespaces instead of tabs
set colorcolumn=120    " Set the 120 chars line
set signcolumn=yes     " Always show the sign column

set tags=tags;/                " Use project specific tags
set mouse=nvi                  " Enable the mouse
set clipboard+=unnamedplus     " Use system clipboard. Need to install xclip first.
set splitbelow splitright      " More intuitive splitting

" == Search
set hlsearch                   " Highlight searches
set history=1000               " Expand the default history lenght
set ignorecase                 " Ignore case difference when searching
set smartcase                  " Unless you put some caps in your search
set showmatch                  " Show matching brackets 
set incsearch                  " Show matches while you search

" Alway use magic mode for regexp
noremap / /\v

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=500

" Colors
set termguicolors     " Enable 24-bit colour
set t_Co=256          " Enable 256 Colors support
set background=dark   " Set default colors to dark mode
colorscheme onedark   " Set the colorscheme installed previously

" Folding.
" Automatically fold vim files by marker: "{{{ foldable block }}}"
" Shortcuts:
" * zo - Open fold
" * zc - Close fold
" * za - Toggle fold
autocmd FileType vim setlocal foldmethod=marker
set foldcolumn=1      " Display fold columns

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ Treesitter config
""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua << EOF
  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
      "javascript",
      "typescript",
      "tsx",
      "css",
      "html",
      "json",
      "ruby"
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    -- sync_install = false,
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    highlight = {
      enable = true,
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = { 'ruby', 'markdown' },
    },
    indent = { enable = true },
  }
EOF

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ Nvim tree config
""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua << EOF

-- disable netrw at the very start of your init.lua (needed for nvim tree to work properly)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- custom global variable that is responsible for hiding or showing the nvim tree globally
vim.g.display_nvim_tree = false

-- Custom on attach handler to define the key bindings
local function nvim_tree_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true
    }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,  opts('Up'))
  vim.keymap.set('n', '?', api.tree.toggle_help,                opts('Help'))
  vim.keymap.set('n', 't', api.node.open.tab,                   opts('Open: New Tab'))
  vim.keymap.set('n', 'v', api.node.open.vertical,              opts('Open: Vertical Split'))
  vim.keymap.set('n', 's', api.node.open.horizontal,            opts('Open: Horizontal Split'))
  vim.keymap.set('n', 'i', api.node.open.horizontal,            opts('Open: Horizontal Split'))
  vim.keymap.set('n', 'h', api.tree.toggle_hidden_filter,       opts('Show hidden files'))
end

-- Toggle global visibility state for nvim tree
function toggle_nvim_tree_visibility()
  vim.g.display_nvim_tree = not vim.g.display_nvim_tree
  toggle_nvim_tree()
end

-- Either show or hide the nvim tree based on the global state
function toggle_nvim_tree(data)
  local nvim_tree_api = require("nvim-tree.api").tree
  if vim.g.display_nvim_tree then
    nvim_tree_api.open()

    -- If after openning nvim tree it is selected, automatically try to select the buffer to the right of it
    if vim.fn.expand('%:p'):match(".*NvimTree_%d*$") then
      vim.api.nvim_feedkeys(vim.api.nvim_eval('"\\<C-w>l"'), 'm', ture)
    end
  else
    nvim_tree_api.close()
  end
end

-- Automatically open nvim tree
local function open_nvim_tree(data)
  -- buffer is a directory
  -- only works properly with "hijack_directories" property disabled
  local directory = vim.fn.isdirectory(data.file) == 1

  -- change to the directory
  -- vim.print(vim.api.nvim_buf_get_name(0))
  if directory then
    -- vim.print("Debug")
    vim.cmd.enew()                       -- create a new, empty buffer
    vim.g.display_nvim_tree = true       -- the netvim tree should now be opened globally, on every tab
    -- vim.cmd.bw(data.buf)              -- wipe the directory buffer (not sure if that's needed)
    vim.cmd.cd(data.file)                -- change to the directory (not sure if that's needed)
    toggle_nvim_tree(data)
  end
end


-- Close the tab if nvim-tree is the last buffer in the tab (after closing a buffer)
-- Close vim if nvim-tree is the last buffer (after closing a buffer)
-- Close nvim-tree across all tabs when one nvim-tree buffer is manually closed if and only if tabs.sync.close is set.
local function tab_win_closed(winnr)
  local api = require"nvim-tree.api"
  local tabnr = vim.api.nvim_win_get_tabpage(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local buf_info = vim.fn.getbufinfo(bufnr)[1]
  local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
  local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
  if buf_info.name:match(".*NvimTree_%d*$") then               -- close buffer was nvim treed
    -- Close all nvim tree on :q
    if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
      api.tree.close()
    end
  else                                                      -- else closed buffer was normal buffer
    if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
      local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
      if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
        vim.schedule(function ()
          if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
            vim.cmd "quit"                                        -- then close all of vim
          else                                                  -- else there are more tabs open
            vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
          end
        end)
      end
    end
  end
end

-- Bind autocommands to open nvim tree automatically when trying to openning the directory
-- Automatically open or hide nvim tree based on the global status
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
vim.api.nvim_create_autocmd({ "TabNewEntered" }, { callback = toggle_nvim_tree })
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function ()
    local winnr = tonumber(vim.fn.expand("<amatch>"))
    vim.schedule_wrap(tab_win_closed(winnr))
  end,
  nested = true
})

-- Use <F2> to toggle the nvim tree
vim.keymap.set('n', '<F2>', toggle_nvim_tree_visibility)

-- Main nvim tree setup
nt = require("nvim-tree").setup({
  hijack_directories = {
    enable = false,
    auto_open = false,
  },
  filters = {
    dotfiles = true,
  },
  on_attach = nvim_tree_on_attach
})

EOF

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ COC config
""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:coc_config_home = $MYVIMHOME " Store COC configuration file to viver directory

lua << EOF

-- For automated node detection in case if COC_NODE is not set
-- Using the ENV variable for now cause of the outdated node that is being picked up by the asdf in one of the projects
local find_node = io.popen('which node')
vim.g.coc_node_path = os.getenv("COC_NODE") or find_node:read('*a'):gsub("^%s*(.-)%s*$", "%1")
vim.g.coc_global_extensions = {
  'coc-json',
  'coc-git',
  'coc-snippets',
  'coc-pairs',
  -- 'coc-solargraph',
  'coc-tsserver',
  'coc-eslint',
  'coc-prettier',
  'coc-react-refactor',
  'coc-spell-checker'
}

-- https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.lua

-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"

local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-j> to trigger snippets
-- keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})
-- keyset("n", "gs", "call CocAction('jumpDefinition', 'split')<CR>", {silent = true})


-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})


-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

-- Formatting selected code
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})

-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

-- Remap keys for apply refactor code actions.
-- keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
-- keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
-- keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

-- Add (Neo)Vim's native statusline support
-- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- provide custom statusline: lightline.vim, vim-airline
vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")
-- vim.api.nvim_create_autocmd({ "CocStatusChange" }, { callback = redrawstatus })

-- Mappings for CoCList
-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true}
-- Show all diagnostics
keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
-- Manage extensions
keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
-- Show commands
keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
-- Find symbol of current document
keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
-- Search workspace symbols
keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
-- Do default action for next item
keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
-- Do default action for previous item
keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
-- Resume latest coc list
keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
EOF

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}} COC config
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ Telescope config
""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua << EOF
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
  vim.keymap.set('n', '<c- >', builtin.live_grep, { desc = 'Telescope live grep' })
  vim.keymap.set('n', '<leader>ft', builtin.treesitter, { desc = 'Treesitter grep' })


  vim.keymap.set("n", "<leader>fb", function()
    require("telescope").extensions.file_browser.file_browser()
  end)
   -- open file_browser with the path of the current buffer
  -- vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

  -- You dont need to set any of these options. These are the default ones. Only
  -- the loading is important
  require('telescope').setup({
    pickers = {
      live_grep = {
        on_input_filter_cb = function(prompt)
          vim.print(prompt)
          -- AND operator for live_grep like how fzf handles spaces with wildcards in rg
          return { prompt = prompt:gsub("%s", ".*") }
        end,
      },
    },
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--glob",
        "!**/.git/*",
        "--ignore-case",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--trim",
        "--hidden",
        "--no-ignore-files"
      },
      path_display = { "truncate" },
      dynamic_preview_title = true
    },
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                         -- the default case_mode is "smart_case"
      },
      file_browser = {
        hijack_netrw = true, -- disables netrw and use telescope-file-browser in its place
      },
    }
  })
  -- To get fzf loaded and working with telescope, you need to call
  -- load_extension, somewhere after setup function:
  require('telescope').load_extension('fzf')
  require("telescope").load_extension("file_browser")
EOF

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ Lualine config
""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua << END
  require('lualine').setup({
    options = {
      globalstatus = true,
      icons_enabled = true,
      theme = 'onedark',
      component_separators={left='|',right='|'},
      section_separators={left='',right=''},
      sections = { lualine_c = { 'g:coc_status', 'bo:filetype' } }
    }
  })
END

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ Git blame
""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua <<END
  require('blame').setup {}
END

command! Gblame BlameToggle

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ My custom functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <C-j> :cnext<cr>
nnoremap <C-k> :cprev<cr>

" Open quickfix file in a new window when pressing "t"
autocmd FileType qf noremap <buffer> t <C-W><Enter><C-W>T

" Search for a string by pattern
" You can pipe the search result using the system commands like:
" >
" > Ack "SomePattern" | grep -v spec | grep -v log | grep "some_file_name"
" >
function! g:Ack(pattern)
  let l:args = split(a:pattern, "|")

  let l:command = "rg --ignore-case --vimgrep --hidden " .. l:args[0]
  let l:piped_tail = join(l:args[1:-1], "|")
  let l:vim_command = ""

  if trim(l:piped_tail) != ""
    let l:command = l:command .. " | " .. l:piped_tail
  endif 
  let l:vim_command = ":cgetexpr system(\"" .. substitute(l:command, "\"", "\\\\\"", "g") .. "\")\<CR>"

  call feedkeys(l:vim_command)
  call feedkeys(":echon\<CR>")
  call feedkeys(":botright copen\<CR>")
  call feedkeys(":echon\<CR>")
endfunction

:command -nargs=1 -complete=file Ack call Ack(<f-args>)

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""

