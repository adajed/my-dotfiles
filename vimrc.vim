"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Original_version:
"       Amir Salihefendic
"       http://amix.dk - amix@amix.dk
"       https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
"
" Sections:
"    -> General
"    -> Vundle
"    -> Plugins setup
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files, backups and undo
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Editing mappings
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" => General {{{
" Sets how many lines of history VIM has to remember
set history=500

syntax on
" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nnoremap <leader>w :w!<cr>

set mouse=a

set number
set relativenumber

" For faster command input
nnoremap ; :
nnoremap : ;

" foldmethod (mainly for this vimrc)
set foldmethod=marker

" }}}

" => Vundle {{{
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"""" NERDTree
" NERDTree, file system explorer
Plugin 'scrooloose/nerdtree'
" support git in NERDTree
Plugin 'xuyuanp/nerdtree-git-plugin'

"""" git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

"""" autocompletion
Plugin 'valloric/youcompleteme'

"""" syntax check
Plugin 'scrooloose/syntastic'

" shell inside vim
Plugin 'shougo/vimproc.vim'
Plugin 'shougo/vimshell.vim'

"""" fuzzy finder
Plugin 'ctrlpvim/ctrlp.vim'

"""" supertab
Plugin 'ervandew/supertab'

"""" vim-airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

"""" Sublime multicursor
Plugin 'terryma/vim-multiple-cursors'

"""" Snippets
Plugin 'sirver/ultisnips'
Plugin 'honza/vim-snippets'

Plugin 'scrooloose/nerdcommenter'

Plugin 'tpope/vim-unimpaired'

Plugin 'fs111/pydoc.vim'

" haskell
Plugin 'neovimhaskell/haskell-vim'
" typescript
Plugin 'leafgarland/typescript-vim'
" html
" Plugin 'mattn/emmet-vim'

Plugin 'edkolev/tmuxline.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" }}}

" => Plugins setup {{{

""""""""""""""""""""""""""""""""""""""""
"               Syntastic              "
""""""""""""""""""""""""""""""""""""""""
" general
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Syntactic cpp settings
let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_compiler_options = "-Wall -std=c++14"

" Syntastic python settings
let g:syntastic_python_checkers = ['flake8']
let g:Syntactic_python_flake8_args = '--select=E'

" Syntastic latex checkers
let g:syntastic_latex_checkers = []
let g:syntastic_tex_checkers = []

""""""""""""""""""""""""""""""""""""""""
"           YouCompleteMe              "
""""""""""""""""""""""""""""""""""""""""
let g:ycm_server_python_interpreter = 'python3'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_add_preview_to_completeopt = 1
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/youcompleteme/third_party/ycmd/cpp/ycm/.ycm_entra_conf.py'


""""""""""""""""""""""""""""""""""""""""
"           vim-airline                "
""""""""""""""""""""""""""""""""""""""""
" let g:airline_left_sep = '▶'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_mode_map = { '__' : '-', 'n'  : 'N',
            \ 'i': 'I', 'R': 'R', 'c' : 'C',
            \ 'v': 'V', 'V': 'V', '': 'V',
            \ 's': 'S', 'S': 'S', '': 'S', }

""""""""""""""""""""""""""""""""""""""""
"               NERDTree               "
""""""""""""""""""""""""""""""""""""""""
" highlights files with given extension
function! NERDTreeHighlightFile(extension, fg)
    exec 'augroup NERDTreeHighlight_' . a:extension
    exec 'autocmd!'
    exec 'autocmd FileType nerdtree highlight ' . a:extension .
                \ ' ctermbg=none' .' ctermfg=' . a:fg .
                \ ' guibg=none guifg=none'
    exec 'autocmd FileType nerdtree syn match ' . a:extension .
                \ ' #^\s\+.*' . a:extension . '$#'
    exec 'augroup END'
endfunction

function! NERDTreeStartUp()
    call NERDTreeHighlightFile('py', '32')
    " call NERDTreeHighlightFile('c', '11', 'none', 'none', 'none')
    call NERDTreeHighlightFile('h', '50')
    call NERDTreeHighlightFile('cc', '50')
    call NERDTreeHighlightFile('cpp', '50')
    call NERDTreeHighlightFile('sh', '34')
    call NERDTreeHighlightFile('js', '66')
    call NERDTreeHighlightFile('ts', '172')
    if argc() == 0 && !exists("s:std_in")
        NERDTree
    endif
endfunction

augroup NERDTreeGroup
    autocmd!

    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * call NERDTreeStartUp()
augroup END

let NERDTreeIgnore=['\.hi$', '\.pyc$', '\.o$']

""""""""""""""""""""""""""""""""""""""""
"           vimhaskell                 "
""""""""""""""""""""""""""""""""""""""""
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
let g:haskell_indent_if = 3


""""""""""""""""""""""""""""""""""""""""
"             UltiSnips                "
""""""""""""""""""""""""""""""""""""""""
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<c-e>"
let g:UltiSnipsJumpForwardTrigger = "<c-e>"
let g:UltiSnipsJumpBackwardTrigger = "<c-z>"

""""""""""""""""""""""""""""""""""""""""
"       sublime multicursor            "
""""""""""""""""""""""""""""""""""""""""
" turn off defaults, so you can customize it
let g:mutli_cursor_use_default_mapping = 0

let g:multi_cursor_quit_key = '<C-c>'

" exiting insert and visual mode will not delete cursors
let g:multi_cursor_exit_from_visual_mode = 0
let g:multi_cursor_exit_from_insert_mode = 0

" this must be set for "kj" shortcut to work
"   in multicursor
let g:multi_cursor_insert_maps = {'k':1, 'j':1}

let g:NERDSpaceDelims = 1

" }}}

" => VIM user interface {{{
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1

" Show trailing tabs and spaces
set listchars=tab:>-,trail:.
set list

match ErrorMsg '\%>120v.\+'
match ErrorMsg '\s\+$'
" }}}

" => Colors and Fonts {{{
" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

colorscheme monokai

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac
"}}}

" => Files, backups and undo {{{
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowritebackup
set noswapfile
" }}}

" => Text, tab and indent related {{{
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set linebreak
set textwidth=500

set autoindent "Auto indent
set wrap "Wrap lines
" }}}

" => Visual mode related {{{
function! CmdLine(str) abort
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range abort
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
" }}}

" => Moving around, tabs, windows and buffers {{{

" kj for switching to normal mode
inoremap kj <Esc>
"inoremap <Esc> <nop>

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
nnoremap <space> /
nnoremap <c-space> ?

" Disable highlight when <leader><cr> is pressed
noremap <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" Useful mappings for managing tabs
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tm :tabmove<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nnoremap <Leader>tl :exe "tabn ".g:lasttab<CR>
autocmd TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
augroup BufRaadPostGroup
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END
" }}}

" => Editing mappings {{{
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
" Delete trailing white space on save, useful for some filetypes ;)
function! CleanExtraSpaces() abort
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    augroup CleanExtraSpacesCmd
        autocmd!
        autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
    augroup END
endif
" }}}

" => Helper functions {{{
" Returns true if paste mode is enabled
function! HasPaste() abort
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt() abort
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" }}}
