" Based on:
" https://gist.github.com/simonista/8703722
" https://dougblack.io/words/a-good-vimrc.html

" Base Setup {{{
set nocompatible              " be iMproved, required
set encoding=utf-8

set backspace=indent,eol,start " Cursor motion

" Blink cursor on error instead of beeping (grr)
set visualbell

set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h14
" }}}
" VimPlug {{{
call plug#begin('~/.vim/plugged')

Plug 'mhartington/oceanic-next'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'simnalamburt/vim-mundo'
Plug 'junegunn/vim-easy-align'
Plug 'christoomey/vim-tmux-navigator'

" All of your Plugins must be added before the following line

call plug#end()
" }}}
" Colors {{{
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax enable           " enable syntax processing
colorscheme OceanicNext
" }}}
" Spaces & Tabs {{{
set tabstop=4 " 4 space tab
set expandtab " use spaces for tabs
set softtabstop=4 " 4 space tab
set shiftwidth=4
set modelines=1
set autoindent
" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" }}}
" UI Layout {{{
set number     " show line numbers
set showmode
set showcmd    " show command in bottom bar
set cursorline " highlight current line
set wildmenu
set lazyredraw
set showmatch  " higlight matching parenthesis
set fillchars+=vert:┃
" }}}
" Searching {{{
set ignorecase          " ignore case when searching
set incsearch           " search as characters are entered
set hlsearch            " highlight all matches
" }}}
" Folding {{{
"=== folding ===
set foldmethod=indent   " fold based on indent level
set foldnestmax=10      " max 10 depth
set foldenable          " don't fold files by default on open
nnoremap <space> za
set foldlevelstart=10   " start with fold level of 1
" }}}
" Splits {{{
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" }}}
" Line Shortcuts {{{
nnoremap j gj
nnoremap k gk
nnoremap gV `[v`]
" }}}
" Leader Shortcuts {{{
let mapleader=","
nnoremap <leader>l :call <SID>ToggleNumber()<CR>
nnoremap <leader><space> :noh<CR>
nnoremap <leader>1 :set number!<CR>
nnoremap <leader>s :mksession<CR>
vnoremap <leader>y "+y
nnoremap <leader>u :MundoToggle<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
" map <leader>l :set list!<CR> " Toggle tabs and EOL
" }}}
" AutoGroups {{{
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md,*.rb :call <SID>StripTrailingWhitespaces()
    autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
    autocmd BufEnter *.py setlocal tabstop=4
    autocmd BufEnter *.md setlocal ft=markdown
    autocmd BufEnter *.go setlocal noexpandtab
    autocmd BufEnter *.avsc setlocal ft=json
augroup END
" }}}
" Backups {{{
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup
" }}}
" CtrlP {{{
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = '\vbuild/|dist/|venv/|target/|\.(o|swp|pyc|egg)$'
" }}}
" FZF {{{
nmap <leader>f :GFiles<CR>
nmap <leader>F :Files<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>t :BTags<CR>
" }}}
" mundo {{{
" Enable persistent undo so that undo history persists across vim sessions
set undofile
set undodir=~/.vim/undo
" }}}
" NERDTree {{{
" autocmd vimenter * NERDTree  " open a NERDTree when vim opens
" }}}
" airline {{{
set laststatus=2
let g:airline_theme = 'oceanicnext'
" }}}
" EasyAlign {{{
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" }}}
" Custom Functions {{{
 function! <SID>ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunc

" vim:foldmethod=marker:foldlevel=0
