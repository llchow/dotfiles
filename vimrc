" Vundle packages
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-speeddating'
Plugin 'ervandew/supertab'
Plugin 'davidhalter/jedi-vim'
Plugin 'jpalardy/vim-slime'
Plugin 'kien/ctrlp.vim'
Plugin 'FelikZ/ctrlp-py-matcher'
Plugin 'SirVer/ultisnips'
Plugin 'jceb/vim-orgmode'
Plugin 'Vimjas/vim-python-pep8-indent'


call vundle#end()
filetype plugin indent on

colorscheme desert256
if has("gui_running")
    set guifont=Monospace\ 14
    colorscheme desert
    imap <silent> <S-Insert> <Esc>"*pa
    "map <silent> <S-Insert> "*p
    set guioptions=egmt
    set lines=50
    set columns=168
endif

syntax on

"Information on the following setting can be found with
":help set
set tabstop=4
set expandtab
set autoindent 
set shiftwidth=4  "this is the level of autoindent, adjust to taste
set ruler
set number
set backspace=indent,eol,start
set visualbell
set hlsearch
set incsearch
set ignorecase
set clipboard=unnamedplus

set wildmode=longest,list,full
set wildmenu
ino jk <esc>
ino kj <esc>
cno jk <c-c>
cno kj <c-c>
" Uncomment below to make screen not flash on error
" set vb t_vb=""
" allow unsaved buffers in the background
set hidden
" Show buffers
nnoremap <F8> :buffers<CR>:buffer<Space>
" nno <Leader>l :buffers<CR>:buffer<Space>
nno <silent> <Leader>m :nohlsearch<CR>
" cno <F8> <c-c> <CR>
" ino <F8> <esc>:buffers<CR>:buffer<Space>

" nno <F9> :b#<CR>
" ino <F9> <esc>:b#<CR>
nnoremap ' `
nnoremap ` '

set pastetoggle=<F4>

"let mapleader = "."
"nno \ .
nmap <Leader>pp :set filetype=python<cr>


" tmux stuff
if exists('$TMUX')
  let g:tmux_navigator_no_mappings = 1
  nno <silent> <c-h> :TmuxNavigateLeft<cr>
  nno <silent> <c-j> :TmuxNavigateDown<cr>
  nno <silent> <c-k> :TmuxNavigateUp<cr>
  nno <silent> <c-l> :TmuxNavigateRight<cr>
"  nno <silent> <c-\> :TmuxNavigatePrevious<cr>
"  ino <silent> <c-h> <esc>:TmuxNavigateLeft<cr>
"  ino <silent> <c-j> <esc>:TmuxNavigateDown<cr>
"  ino <silent> <c-k> <esc>:TmuxNavigateUp<cr>
"  ino <silent> <c-l> <esc>:TmuxNavigateRight<cr>
"  ino <silent> <c-\> <esc>:TmuxNavigatePrevious<cr>
else
"  ino <c-h> <esc><c-w>hi
"  ino <c-j> <esc><c-w>ji
"  ino <c-k> <esc><c-w>ki
"  ino <c-l> <esc><c-w>li
"  ino <c-\> <esc><c-w><c-p>i
  nno <c-h> <c-w>h
  nno <c-j> <c-w>j
  nno <c-k> <c-w>k
  nno <c-l> <c-w>l
"  nno <c-\> <c-w><c-p>
endif

"set shellcmdflag=-ic


"set noshowmode
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "0"
let g:jedi#goto_command = "gd"
"let g:jedi#use_tabs_not_buffers = 0
"let g:jedi#use_splits_not_buffers = "right"

let g:SuperTabDefaultCompletionType = "context"

" let g:ogs_app_url = 'https://code.dev.bloomberg.com/opengrok/'
" let g:ogs_project = '/devgit/fipricing'
" let g:ogs_browser_command = '/home/lchow41/bin/elinks'


" slime options and functions
source ~/.vim/startup/slimeopts.vim


" fswitch mappings
nmap <silent> <Leader>fsl :FSRight<cr>
nmap <silent> <Leader>fsL :FSSplitRight<cr>
nmap <silent> <Leader>fsh :FSLeft<cr>
nmap <silent> <Leader>fsH :FSSplitLeft<cr>
nmap <silent> <Leader>fsf :FSHere<cr>


" tag stuff
set tags=./tags;/
"map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
let g:ctrlp_extensions = ['tag']
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_switch_buffer = 'E'
let g:ctrlp_clear_cache_on_exit = 0

nmap <Leader>bb :CtrlPBuffer<cr>
nmap <Leader>bm :CtrlPMixed<cr>
nmap <Leader>bs :CtrlPMRU<cr>
nmap <Leader>bt :CtrlPTag<cr>
nmap <Leader>bd :CtrlPBookmarkDir<cr>

nmap <Leader>df :w !diff % -<cr>

" need ctags -R .
" or ctags -R -f ./.git/tags .

" use space to toggle fold
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>


augroup py
    au FileType python setl foldmethod=indent foldnestmax=2
    au BufRead *.script.py setl foldmethod=marker
    au FileType python normal zR
augroup END


set splitright

" use ag
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    "not fast enough to not cache
    "let g:ctrlp_use_caching = 0
endif

let g:UltiSnipsSnippetDirectories=["UltiSnips", "myultisnips"]
set foldmethod=marker

"" loading cscope
"function! LoadCscope()
"  let db = findfile("cscope.out", ".;")
"  if (!empty(db))
"    let path = strpart(db, 0, match(db, "/cscope.out$"))
"    set nocscopeverbose " suppress 'duplicate connection' error
"    exe "cs add " . db . " " . path
"    set cscopeverbose
"  endif
"endfunction
""au BufEnter /* call LoadCscope()
"
"if has("cscope")
"    set cscopetag
"
"    " check cscope for definition of a symbol before checking ctags: set to 1
"    " if you want the reverse search order.
"    set csto=0
"
"    " show msg when any other cscope db added
"    set cscopeverbose
"endif


"function! s:get_visual_selection()
"  " Why is this not a built-in Vim script function?!
"  let [lnum1, col1] = getpos("'<")[1:2]
"  let [lnum2, col2] = getpos("'>")[1:2]
"  let lines = getline(lnum1, lnum2)
"  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
"  let lines[0] = lines[0][col1 - 1:]
"  return join(lines, "\n")
"endfunction
