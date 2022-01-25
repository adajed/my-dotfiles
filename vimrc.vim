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

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","
let maplocalleader = "."

" Fast saving
nnoremap <leader>w :w!<cr>

set mouse=a

set number
set relativenumber

" For faster command input
nnoremap ; :
nnoremap : ;

vnoremap ; :
vnoremap : ;

" foldmethod (mainly for this vimrc)
set foldmethod=marker

" decrement number
nnoremap <leader>- <C-X>

" increment number
nnoremap <leader>= <C-A>

" }}}

" => vim-plug {{{
call plug#begin('~/.vim/plugged')

if has('nvim')
    " Plug 'Shougo/denite.nvim'
    " autocompletion
    Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1

    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch' : 'next',
        \ 'do' : 'bash install.sh',
        \ }

    Plug 'Shougo/neosnippet.vim'
    Plug 'Shougo/neosnippet-snippets'

    Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

    Plug 'neovimhaskell/haskell-vim'
endif


Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"""" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

"""" vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'

" smooth scroll
Plug 'terryma/vim-smooth-scroll'

" colorscheme
Plug 'morhetz/gruvbox'

" tmux
Plug 'christoomey/vim-tmux-navigator'

" All of your Plugins must be added before the following line
call plug#end()
" }}}

" => Plugins setup {{{
try
" => deoplete {{{

let g:deoplete#enable_at_startup = 1

call deoplete#custom#option({
            \ 'auto_complete_delay': 100,
            \ })

" }}}

" => fzf {{{

nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>l :Lines<CR>

nnoremap <leader>s :Ag <CR>
nnoremap <leader>c yiw:Ag <C-R>"<CR>

" }}}

" => neosnippet {{{
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let g:neosnippet#enable_complete_done = 1

" }}}

" => vim-airline {{{
""""""""""""""""""""""""""""""""""""""""
"           vim-airline                "
""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_mode_map = { '__' : '-', 'n'  : 'N',
            \ 'i': 'I', 'R': 'R', 'c' : 'C',
            \ 'v': 'V', 'V': 'V', '': 'V',
            \ 's': 'S', 'S': 'S', '': 'S', }

let g:airline_theme='cool'
" }}}

" => Smooth Scroll {{{
""""""""""""""""""""""""""""""""""""""""
"           vim-smooth-scroll          "
""""""""""""""""""""""""""""""""""""""""

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" }}}

" => vim-fugitive {{{
nnoremap <leader>gs :10Gstatus<CR>
nnoremap <leader>gd :Gvdiff<CR>

nnoremap <leader>gr :diffget<space>//3<CR>:diffupdate<CR>
nnoremap <leader>gl :diffget<space>//2<CR>:diffupdate<CR>

" diffs
nnoremap <leader>gg :diffget<CR>
nnoremap <leader>gp :diffput<CR>
nnoremap <leader>gu :diffupdate<CR>

" }}}

" => nvimgdb {{{
" disable default mappings
let g:nvimgdb_disable_start_keymaps = 1

nnoremap <leader>dd :GdbStart gdb -q --args
nnoremap <leader>db :GdbBreakpointToggle<cr>
nnoremap <leader>dn :GdbNext<cr>
nnoremap <leader>ds :GdbStep<cr>
nnoremap <leader>dc :GdbContinue<cr>

" }}}

" => haskell-vim {{{

let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

" }}}

catch
echo "Plugin setup error: " . v:exception

endtry

" }}}

" => Language Server Protocol {{{

" set completeopt=longest,menuone

let g:LanguageClient_waitOutputTimeout=60

let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'

let g:LanguageClient_serverCommands = {
    \ 'python'  : ['/usr/local/bin/pyls'],
    \ 'sh'      : ['bash-language-server', 'start'],
    \ 'cpp'     : ['/usr/bin/clangd'],
    \ 'c'       : ['/usr/bin/clangd'],
    \ 'haskell' : ['ghcide', '--lsp'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>

let g:LanguageClient_rootMarkers = {
    \ 'cpp'     : ['compile_commands.json', 'build'],
    \ 'c'       : ['compile_commands.json', 'build']
    \ }

let g:LanguageClient_autoStart = 0
let g:LanguageClient_hasSnippetSupport = 1

" }}}

" => VIM user interface {{{
" Set 7 lines to the cursor - when moving vertically using j/k
set so=3

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
set termguicolors
" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

set background=dark
silent! colorscheme gruvbox

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

set cursorline
highlight CursorLine cterm=NONE ctermbg=17

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
function! VisualSelection() range abort
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    " let l:pattern = substitute(l:pattern, "\n$", "", "")

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>
" }}}

" => Moving around, tabs, windows and buffers {{{

" kj for switching to normal mode
inoremap kj <Esc>
if has('nvim')
    tnoremap kj <C-\><C-n>
endif

" Disable highlight when <leader><cr> is pressed
noremap <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" integrate deleting buffers with NERDTree
" nnoremap <leader>bd :bp<CR>:bd #<CR>

" Useful mappings for managing tabs
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tm :tabmove<cr>

" resizing windows
nnoremap <Up>       :resize -5<Cr>
nnoremap <Down>     :resize +5<CR>
nnoremap <Left>     :vertical resize +5<CR>
nnoremap <Right>    :vertical resize -5<CR>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nnoremap <Leader>tl :exe "tabn ".g:lasttab<CR>
autocmd TabLeave * let g:lasttab = tabpagenr()

autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <leader>te :tabedit <c-r>=expand("%:p:h")<cr><cr>
nnoremap <leader>e :e <c-r>=expand("%:p:h")<cr><cr>

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

" => Clipboard mappings {{{
set clipboard=unnamedplus
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
        autocmd BufWritePre *.txt,*.py,*.sh,*.c,*.cc,*.cpp,*.h,*.hpp :call CleanExtraSpaces()
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

function! s:CompleteTags()
    " mapping for completing tags in html files
    inoremap <buffer> ><leader> ><Esc>%y/<[^> ]*/e<CR>:noh<CR>%pa><Esc>%a/<Esc>hi
    inoremap <buffer> >><leader> ><Esc>%y/<[^> ]*/e<CR>:noh<CR>%pa><Esc>%a/<Esc>hi<CR><CR><Esc>ka<Tab>
endfunction

augroup HTMLGroup
    autocmd!
    autocmd BufRead,BufNewFile *.html call s:CompleteTags()
augroup END
" }}}
