"Helper for conditional Plug loads {{{
function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction   
"}}}

"   Plugins {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.local/share/nvim/plugged')
Plug 'yaunj/vim-yara',                 Cond(!exists('g:vscode'), { 'for': 'yar'  })
Plug 'OmniSharp/omnisharp-vim',        Cond(!exists('g:vscode'), { 'for': 'cs'   })
Plug 'fatih/vim-go',                   Cond(!exists('g:vscode'), { 'for': 'go'   })
Plug 'mattn/emmet-vim',                Cond(!exists('g:vscode'), { 'for': ['html',  'javascript.jsx'] })
Plug 'nelstrom/vim-textobj-rubyblock', Cond(!exists('g:vscode'), { 'for': 'ruby' })
Plug 'thoughtbot/vim-rspec',           Cond(!exists('g:vscode'), { 'for': 'ruby' })
Plug 'tpope/vim-bundler',              Cond(!exists('g:vscode'), { 'for': 'ruby' })
Plug 'tpope/vim-cucumber',             Cond(!exists('g:vscode'), { 'for': 'ruby' })
Plug 'junegunn/fzf',                   Cond(!exists('g:vscode'), { 'do': './install --all --xdg' })
Plug 'junegunn/fzf.vim',               Cond(!exists('g:vscode'))
Plug 'jpalardy/vim-slime',             Cond(!exists('g:vscode'))
Plug 'junegunn/goyo.vim',              Cond(!exists('g:vscode'))
Plug 'terryma/vim-multiple-cursors',   Cond(!exists('g:vscode'))
Plug 'christoomey/vim-tmux-navigator', Cond(!exists('g:vscode'))
Plug 'cormacrelf/vim-colors-github',   Cond(!exists('g:vscode'))
Plug 'airblade/vim-gitgutter',         Cond(!exists('g:vscode'))
Plug 'audibleblink/hackthebox.vim',    Cond(!exists('g:vscode'))
Plug 'sheerun/vim-polyglot',           Cond(!exists('g:vscode'))
Plug 'rust-lang/rust.vim',             Cond(!exists('g:vscode'))
Plug 'tpope/vim-dispatch',             Cond(!exists('g:vscode'))
Plug 'tpope/vim-fugitive',             Cond(!exists('g:vscode'))
Plug 'lukas-reineke/indent-blankline.nvim',             Cond(!exists('g:vscode'))

Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'kyazdani42/nvim-web-devicons'

" all nvims
Plug 'tpope/vim-endwise',              { 'for': 'ruby' }
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-user'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'

" last to ensure others plugins don't overwrite coc-generated bindings
Plug 'neoclide/coc.nvim',               Cond(!exists('g:vscode'), { 'branch': 'release' })
call plug#end()

filetype plugin on
" }}}

"   Settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autowrite
set colorcolumn=+1
set clipboard+=unnamedplus
set expandtab
" set foldlevelstart=0
" set foldmethod=marker
set hidden
set list listchars=tab:»\ ,trail:·,nbsp:·
set nowrap
set numberwidth=3
set relativenumber | set number
set relativenumber
set splitbelow
set splitright
set textwidth=0
set timeoutlen=1000 ttimeoutlen=10
set wiw=100
set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn      " Version control
set wildignore+=*.sw?              " Vim swap files
set wildignore+=*.DS_Store         " OSX bullshit

if !exists('g:vscode')
" Colorscheme
    " set statusline=%f\ \ %y%m%r%h%w%=[%l,%v]\ \ \ \ \ \ [%L,%p%%]\ %n

    if has('termguicolors')
        set termguicolors
        set t_ut=
    endif
    colorscheme hackthebox
    let &colorcolumn="100".join(range(100,999),",")
    lua require('evilline')
    set noshowmode
endif
" }}}

"   Custom Mappings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap jk <ESC>
cnoremap jk <ESC>
nnoremap c* *Ncgn
nnoremap <CR> :
vnoremap <CR> :

" places selected text in a search/replace command
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Store relative line number jumps in the jumplist. Also treat
" long lines as break lines (useful when moving around in them).
noremap <expr> j v:count > 1 ? 'm`' . v:count . 'j' : 'gj'
noremap <expr> k v:count > 1 ? 'm`' . v:count . 'k' : 'gk'

" Make Yank behave
vnoremap y myy`y
vnoremap Y myY`y
noremap Y y$
"
" Unmap Enter in the quickfix window
au BufReadPost quickfix nnoremap <buffer> <CR> <CR>

" Tab accepts current selection
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" }}}

"   Leader Mappings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = " "
if !exists('g:vscode')
    map      <Leader>b  :Buffers<CR>
    map      <Leader>m  :Marks<CR>
    map      <Leader>p  :Files<CR>
    map      <Leader>r  :BTags<CR>
    map      <Leader>t  :Tags<CR>
    map      <Leader>f  :Find<CR>
    nnoremap <Leader>z  :wincmd _<cr>:wincmd \|<cr>
    nnoremap <Leader>Z  :wincmd =<cr>
    nnoremap <Leader><Up> :History:<CR>
    nnoremap <silent> <Leader>n :call Cycle_numbering()<CR>
endif
map      <Leader>c  :noh<CR>
nmap     <Leader>e  :vsp ~/.config/nvim/init.vim<CR>
nmap     <Leader>ee :source ~/.config/nvim/init.vim<CR>
nnoremap <Leader>gs :sp /tmp/scratch<CR>
map      <Leader>/  gcc
vmap     <Leader>/  gc
nnoremap <silent> <Leader>w :call Zap()<CR>
nmap     <Leader><Tab> :b#<CR>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" CoC suggested settings {{{
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
" set signcolumn=number

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Highlight the symbol and its references when holding the cursor.
hi default CocHighlightText  guibg=Cyan guifg=Black
hi default link CocHighlightRead  CocHighlightText
hi default link CocHighlightWrite  CocHighlightText
autocmd CursorHold * silent call CocActionAsync('highlight')
" }}}

" Go Completor {{{
let g:completor_auto_trigger = 0
" let g:completor_cs_omni_trigger = '.*'
" let g:completor_go_omni_trigger = '.*'

" Enable lsp for go by using gopls
" let g:completor_filetype_map = {}
" let g:completor_filetype_map.go = {'ft': 'lsp', 'cmd': 'gopls'}
" }}}

" Tmux Navigator {{{
"
" Send :update when leaving vim for tmux
let g:tmux_navigator_save_on_switch = 1
" }}}

" EasyAlign  {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}}

" Slime {{{
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"}
let g:slime_python_ipython = 1
" }}}

" FZF {{{
" Layout
let g:fzf_layout = { 'down': '~35%'  }
" FZF w/ RipGrep
set grepprg=rg\ --vimgrep
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
"  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
" }}}

" Ale {{{
" let g:ale_completion_enabled = 1
" let g:ale_linters = { 'cs': ['OmniSharp'], 'rust': ['rls', 'cargo'] }
" let g:OmniSharp_server_use_mono = 1
" let g:OmniSharp_server_path = '/home/link/.omnisharp/omnisharp-roslyn/OmniSharp.exe'
" let g:OmniSharp_selector_ui = 'fzf'
" let g:OmniSharp_host = 'http://localhost:2000'
" let g:OmniSharp_proc_debug = 1
" let g:OmniSharp_loglevel = 'debug'
" }}}

" Language Stuff I'm too lazy to move to /ftplugin {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Svelte
au! BufNewFile,BufRead *.svelte set ft=html

" Golang
let g:go_def_reuse_buffer = 1

" Rust
let g:rustfmt_autosave = 1
" }}}

"   Functions {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Cycle through relativenumber + number, number (only), and no numbering.
function! Cycle_numbering() abort
    if exists('+relativenumber')
        execute {
                    \ '00': 'set relativenumber   | set number',
                    \ '01': 'set norelativenumber | set number',
                    \ '10': 'set norelativenumber | set nonumber',
                    \ '11': 'set norelativenumber | set number' }[&number . &relativenumber]
    else
        " No relative numbering, just toggle numbers on and off.
        set number!<CR>
    endif
endfunction


" Zap trailing whitespace.
function! Zap() abort
    let l:pos=getcurpos()
    let l:search=@/
    keepjumps %substitute/\s\+$//e
    let @/=l:search
    nohlsearch
    call setpos('.', l:pos)
endfunction

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh :call Zap()
endif

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" }}}

" vim: foldlevelstart=0 foldmethod=marker
