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

" => vim-plug {{{
call plug#begin('~/.vim/plugged')

if has('nvim')
    Plug 'Shougo/denite.nvim'
    " autocompletion
    Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch' : 'next',
        \ 'do' : 'bash install.sh',
        \ }
    let g:deoplete#enable_at_startup = 1

    Plug 'Shougo/neosnippet.vim'
    Plug 'Shougo/neosnippet-snippets'

    Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
endif

"""" NERDTree

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

Plug 'altercation/vim-colors-solarized'

" smooth scroll
Plug 'terryma/vim-smooth-scroll'

Plug 'morhetz/gruvbox'

" All of your Plugins must be added before the following line
call plug#end()
" }}}

" => Plugins setup {{{

" => denite {{{
if has('nvim')
    call denite#custom#option('default', {
        \ 'prompt': '❯'
        \ })

    nnoremap <C-p> :<C-u>Denite file/rec<CR>
    nnoremap <leader>bb :<C-u>Denite buffer<CR>

    call denite#custom#var('file/rec', 'command',
      \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts',
          \ ['--hidden', '--vimgrep', '--smart-case'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    autocmd FileType denite call s:denite_my_settings()
    function! s:denite_my_settings() abort
        nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
        nnoremap <silent><buffer><expr> v
        \ denite#do_map('do_action', 'vsplit')
        nnoremap <silent><buffer><expr> s
        \ denite#do_map('do_action', 'ssplit')
        nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
        nnoremap <silent><buffer><expr> q
        \ denite#do_map('quit')
        nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
        nnoremap <silent><buffer><expr> <Space>
        \ denite#do_map('toggle_select').'j'
    endfunction

    nnoremap <C-p>  :<C-u>Denite file/rec -start-filter<CR>
    nnoremap <leader>/ :<C-u>Denite grep:.<CR>
endif
" }}}

" => Python {{{
let g:deoplete#sources#jedi#server_timeout = 30
let g:deoplete#sources#jedi#python_path = "/usr/bin/python3.5"
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

" => neosnippet {{{

imap <C-k> <Plug>(neosnippet_expand_or_jump)

if has('conceal')
    set conceallevel=2 concealcursor=niv
endif

" imap <expr><TAB>
"         \ neosnippet#expandable_or_jumpable() ?
"         \    "\<Plug>(neosnippet_expand_or_jump)" :
"         \        pumvisible() ? "\<C-n>" : "\<TAB>"
" }}}

" }}}

" => Language Server Protocol {{{

set completeopt=longest,menuone

let g:LanguageClient_serverCommands = {
    \ 'python' : ['/usr/local/bin/pyls'],
    \ 'sh' : ['bash-language-server', 'start'],
    \ 'cpp' : ['/usr/bin/clangd-8'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> rr :call LanguageClient#textDocument_rename()<CR>

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

let g:solarized_termcolors=256
set background=dark
colorscheme gruvbox

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
if has('nvim')
    tnoremap kj <C-\><C-n>
endif
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

" integrate deleting buffers with NERDTree
nnoremap <leader>bd :bp<CR>:bd #<CR>

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
