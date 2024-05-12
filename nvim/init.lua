local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Exmple using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

vim.opt.number = true -- Show the absolute line number for the current line
vim.opt.relativenumber = true -- Show relative line numbers for all other lines




require("lazy").setup({
  "folke/which-key.nvim",
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.g.tokyonight_style = "night"
      vim.g.tokyonight_day_brightness = 0.3
      vim.cmd[[colorscheme tokyonight-night]]
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    }  
  },
  "folke/neodev.nvim",
  "nvim-treesitter/nvim-treesitter",
  "neovim/nvim-lspconfig",
  "github/copilot.vim",
  "tpope/vim-surround",
  "echasnovski/mini.nvim",
  "nanozuki/tabby.nvim",
{
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_save_enabled = true,
			auto_restore_enabled = true,
			auto_save_enabled = true,
			auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
		})

	end
},
  --"gcmt/taboo.vim",	
{
    'dense-analysis/ale',
    config = function()
        -- Configuration goes here.
        local g = vim.g

        g.ale_ruby_rubocop_auto_correct_all = 1

        g.ale_linters = {
		cs = {"OmniSharp"}
        }
    end
},
	"neovim/pynvim",
	"neoclide/coc.nvim",
})

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


local treesitter_config = require('nvim-treesitter.configs')

treesitter_config.setup {
  highlight = {
    enable = true,              -- Enable syntax highlighting
  },
  indent = {
    enable = true,              -- Enable tree-based indentation
  },
  ensure_installed = {
    "bash", "c", "c_sharp",     -- Adding C# (note: use the correct parser name for C#, generally 'c_sharp' or similar)
    "diff", "html", "javascript", "jsdoc", "json", "jsonc",
    "lua", "luadoc", "markdown", "markdown_inline", "python",
    "query", "regex", "toml", "tsx", "typescript",
    "vim", "vimdoc", "xml", "yaml"
  },
  incremental_selection = {
    enable = true,
    keymaps = {                 -- Keymaps for incremental selection
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "gz",
      node_decremental = "<bs>",
    },
  },
  textobjects = {              -- Keymaps for moving around text objects
    move = {
      enable = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer"
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer"
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer"
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer"
      },
    },
  },
}


local minianimate = require('mini.animate').setup()
-- Configuration for OmniSharp
local lspconfig = require('lspconfig')

local pid = vim.fn.getpid()
local omnisharp_bin = "omnisharp" -- adjust the path if necessary

--[[
lspconfig.omnisharp.setup {
    -- Define the command to start the OmniSharp server
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },

    -- Define the root directory conditionally based on project files
    root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln"),

    -- Configuration options specific to OmniSharp
    settings = {
        OmniSharp = {
            useGlobalMono = "never",
            enableRoslynAnalyzers = true,
            enableEditorConfigSupport = true,
        },
    },
    
    -- Handlers, capabilities, and other LSP configurations can be set here
    -- Example of setting up on_attach function to bind LSP key mappings
    on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Define key mappings
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', {noremap=true, silent=true})
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', {noremap=true, silent=true})
    end,
}
--]]


-- Mappings for window navigation using leader 1-8
for i = 1, 8 do
  vim.api.nvim_set_keymap('n', '<leader>' .. i, i .. '<C-w>w', { noremap = true })
end

-- Mappings for tab navigation using leader then shift 1-8 (!@#$%^&*)
local shift_keys = { '!', '@', '#', '$', '%', '^', '&', '*' }
for i = 1, 8 do
  vim.api.nvim_set_keymap('n', '<leader>' .. shift_keys[i], ':tabn ' .. i .. '<CR>', { noremap = true })
end

-- Mapping for moving left and right between windows with left and right arrow keys
vim.api.nvim_set_keymap('n', '<Left>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Right>', '<C-w>l', { noremap = true, silent = true })

-- Mapping for moving left and right between tabs with shift + left and right arrow keys
vim.api.nvim_set_keymap('n', '<S-Left>', ':tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Right>', ':tabnext<CR>', { noremap = true, silent = true })


vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true, silent = true })

-- Make 'd' delete to the null register
vim.api.nvim_set_keymap('n', 'd', '"_d', {noremap = true})
vim.api.nvim_set_keymap('v', 'd', '"_d', {noremap = true})
vim.api.nvim_set_keymap('n', 'x', '"_x', {noremap = true})

-- Make 'm' perform the delete operation using the unnamed register
vim.api.nvim_set_keymap('n', 'm', 'd', {noremap = true})
vim.api.nvim_set_keymap('n', 'mm', 'dd', {noremap = true})
vim.api.nvim_set_keymap('v', 'm', 'd', {noremap = true})

-- Define a global Lua function that can be accessed as an operator function
_G.change_paste = function()
  -- Perform the change operation with the black hole register to preserve the clipboard
  vim.api.nvim_feedkeys('`[v`]"_d', 'n', false)
  -- Paste the previously yanked text
  vim.api.nvim_feedkeys('P', 'n', false)
end

-- Vimscript bridge function to handle the operator
vim.cmd [[
function! ChangePaste(type, ...)
  " Capture the motion provided by the operator use
  let motion = a:type
  " Call the Lua function with the motion
  execute 'lua _G.change_paste()'
endfunction
]]
-- endfunction2 3 4
-- Map 'cp' to this custom operator function
vim.api.nvim_set_keymap('n', 's', ':set opfunc=ChangePaste<CR>g@', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<CR>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"]], { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>r', '<Plug>(coc-rename)', { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { noremap = false, silent = true })

-- Vertical split with leader v
vim.api.nvim_set_keymap('n', '<leader>v', ':vsp<CR>', { noremap = true, silent = true })

-- Open in a new tab with leader t
vim.api.nvim_set_keymap('n', '<leader>t', ':tabnew %<CR>', { noremap = true, silent = true })


vim.cmd [[
hi Normal guibg=NONE ctermbg=NONE
hi NormalNC guibg=NONE ctermbg=NONE
]]
