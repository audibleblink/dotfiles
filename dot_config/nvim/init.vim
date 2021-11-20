" conditional helper
function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" terminal vim only
call plug#begin('~/.local/share/nvim/plugged')
Plug 'yaunj/vim-yara',                 Cond(!exists('g:vscode'), { 'for': 'yar'  })
Plug 'OmniSharp/omnisharp-vim',        Cond(!exists('g:vscode'), { 'for': 'cs'   })
Plug 'fatih/vim-go',                   Cond(!exists('g:vscode'), { 'for': 'go'   })
Plug 'mattn/emmet-vim',                Cond(!exists('g:vscode'), { 'for': ['html',  'javascript.jsx'] })
Plug 'nelstrom/vim-textobj-rubyblock', Cond(!exists('g:vscode'), { 'for': 'ruby' })
Plug 'thoughtbot/vim-rspec',           Cond(!exists('g:vscode'), { 'for': 'ruby' })
Plug 'tpope/vim-bundler',              Cond(!exists('g:vscode'), { 'for': 'ruby' })
Plug 'tpope/vim-cucumber',             Cond(!exists('g:vscode'), { 'for': 'ruby' })
Plug 'junegunn/fzf',                   Cond(!exists('g:vscode'), { 'dir': '~/.fzf', 'do': './install --all' })
Plug 'junegunn/fzf.vim',               Cond(!exists('g:vscode'))
Plug 'jpalardy/vim-slime',             Cond(!exists('g:vscode'))
Plug 'junegunn/goyo.vim',              Cond(!exists('g:vscode'))
Plug 'maralla/completor.vim',          Cond(!exists('g:vscode'))
Plug 'terryma/vim-multiple-cursors',   Cond(!exists('g:vscode'))
Plug 'christoomey/vim-tmux-navigator', Cond(!exists('g:vscode'))
Plug 'cormacrelf/vim-colors-github',   Cond(!exists('g:vscode'))
Plug 'airblade/vim-gitgutter',         Cond(!exists('g:vscode'))
Plug 'audibleblink/hackthebox.vim',    Cond(!exists('g:vscode'))
Plug 'sheerun/vim-polyglot',           Cond(!exists('g:vscode'))
Plug 'dense-analysis/ale',             Cond(!exists('g:vscode'))
Plug 'rust-lang/rust.vim',             Cond(!exists('g:vscode'))
Plug 'tpope/vim-dispatch',             Cond(!exists('g:vscode'))
Plug 'tpope/vim-fugitive',             Cond(!exists('g:vscode'))

" all nvims
Plug 'tpope/vim-endwise',              { 'for': 'ruby' }
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-user'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
call plug#end()

" nvim settings
set autowrite
set colorcolumn=+1
set clipboard+=unnamedplus
set expandtab
set foldlevelstart=99
set foldmethod=manual
set hidden
set list listchars=tab:»·,trail:·,nbsp:·
set nowrap
set numberwidth=3
set relativenumber
set splitbelow
set splitright
set textwidth=99
set timeoutlen=1000 ttimeoutlen=10
set wiw=100
set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn      " Version control
set wildignore+=*.sw?              " Vim swap files
set wildignore+=*.DS_Store         " OSX bullshit


" Custom Mappings
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
" Unmap Enter in the quickfix window
au BufReadPost quickfix nnoremap <buffer> <CR> <CR>

" Leader Mappings
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

if !exists('g:vscode')
" Colorscheme
    if has('termguicolors')
        set termguicolors
        set t_ut=
    endif
    colorscheme hackthebox
    let &colorcolumn="100".join(range(100,999),",")
endif

" Plugin Settings
" Go Completor
let g:completor_cs_omni_trigger = '.*'

" Enable lsp for go by using gopls
let g:completor_filetype_map = {}
let g:completor_filetype_map.go = {'ft': 'lsp', 'cmd': 'gopls'}

" RSpec.vim mappings
let g:rspec_command = "VtrSendCommandToRunner! zeus rspec {spec}"

" Tmux Navigator
" Send :update when leaving vim for tmux
let g:tmux_navigator_save_on_switch = 1

" FZF
" Layout
let g:fzf_layout = { 'down': '~35%'  }
" FZF w/ RipGrep
set grepprg=rg\ --vimgrep
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
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

" EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Ale
let g:ale_completion_enabled = 1
let g:ale_linters = { 'cs': ['OmniSharp'], 'rust': ['rls', 'cargo'] }
" let g:OmniSharp_server_use_mono = 1
" let g:OmniSharp_server_path = '/home/link/.omnisharp/omnisharp-roslyn/OmniSharp.exe'
" let g:OmniSharp_selector_ui = 'fzf'
" let g:OmniSharp_host = 'http://localhost:2000'
" let g:OmniSharp_proc_debug = 1
" let g:OmniSharp_loglevel = 'debug'

" AutoCommands
augroup remember_folds
  autocmd!
  " autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
augroup END

augroup ruby
    autocmd FileType rb nmap <Leader>ra :call RunAllSpecs()<CR>
    autocmd FileType rb nmap <Leader>rl :call RunLastSpec()<CR>
    autocmd FileType rb nmap <Leader>rs :call RunNearestSpec()<CR>
    autocmd FileType rb nmap <Leader>rt :call RunCurrentSpecFile()<CR>
augroup END

augroup omnisharp_commands
    autocmd!
    autocmd FileType *.cs :call OmniSharp#HighlightTypes()

    " Show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <C-]> :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>r :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tp :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>cc :ccl<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>zz
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>zz
    autocmd FileType cs nnoremap <buffer> c* :OmniSharpRename<CR>
    autocmd FileType cs nnoremap <Leader>l :OmniSharpCodeFormat<CR>:OmniSharpFixUsings<CR>
augroup END

au! BufNewFile,BufRead *.svelte set ft=html

" Python Dev
let g:completor_python_binary = '/usr/bin/python3'

" Golang
let g:go_def_reuse_buffer = 1

" Rust
let g:rustfmt_autosave = 1

" Slime
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"}
let g:slime_python_ipython = 1

" Functions
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
