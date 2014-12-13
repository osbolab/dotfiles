set nocompatible
set ttyfast

function! EnsureDirExists(dir)
  if !isdirectory(a:dir)
    if exists("*mkdir")
      call mkdir(a:dir,'p')
      echo "Created directory: " . a:dir
    else
      echo "Please create directory: " . a:dir
    endif
  endif
endfunction

if has('win32') || has('win64')
  """ Vim on windows doesn't normally use $HOME/.vim for some reason
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" ==========================================================
" Pathogen plugin loader (in $VIM/bundle)
" ==========================================================
" Load pathogen with docs for all plugins
call pathogen#infect()
call pathogen#helptags()


" ==========================================================
" Basic Settings
" ==========================================================
""" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>
set title                 " show title in console title bar

""" Display
if has("gui_running")
    set guifont=Consolas\ 10
    set clipboard=unnamed
    set background=light
    colorscheme solarized
    highlight colorcolumn guibg=Black
    au ColorScheme * hi colorcolumn guibg=Black
    set guioptions-=m  " No menu bar
    set guioptions-=T   " No toolbar
    set guioptions-=r   " No RHS scrollbar
    set guioptions-=L   " No LHS scrollbar
else
    """ Set your terminal emulator's pallet;
    """ you can't get good colors from vim.
    """ For solarized set t_Co=16
    set t_Co=256
    colorscheme Tomorrow-Night
    highlight colorcolumn ctermbg=236
endif

syntax on                 " syntax highlighing
filetype on               " try to detect filetypes
filetype plugin indent on " enable loading indent file for filetype[3~[3~[3~[3~[3~
""" Don't use relative numbers for big files (syntax highlighting gets slow)
let g:big_file_size = 50 * 1024
if getfsize(expand('%%:p')) > g:big_file_size
  set number
  set norelativenumber
  set nocursorline
else
  set relativenumber
  set cursorline
endif
set numberwidth=1         " using only 1 column (and 1 space) while possible
set colorcolumn=80        " Highlight the column width limit for wrapping
""" Autocomplete
set wildmenu              " Menu completion in command mode on <Tab>
set wildmode=full         " <Tab> cycles between all matching choices.
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**

""" Insert completion
""" Don't select first item, follow typing in autocomplete
"set completeopt=menuone,longest
"set pumheight=6           " Keep a small completion window
"""" Select the item in the list with enter
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"""" close preview window automatically when we move around
"au CursorMovedI * if pumvisible() == 0|pclose|endif
"au InsertLeave * if pumvisible() == 0|pclose|endif

""" Moving Around/Editing
set ruler                 " show the cursor position all the time
set nostartofline         " Avoid moving cursor to BOL when jumping around
set virtualedit=all       " Let cursor move past the last char in <C-v> mode
set scrolloff=15          " Keep 3 context lines above and below the cursor
set backspace=2           " Allow backspacing over autoindent, EOL, and BOL
set showmatch             " Briefly jump to a paren once it's balanced
set nowrap                " Don't wrap text
set tw=80                 " If we did wrap text, wrap it at this column
set formatoptions-=t      " No auto text wrapping! NO
set linebreak             " Don't wrap text in the middle of a word
set autoindent            " Always set autoindenting on
set nosmartindent         " Smartindent messes up python comments
set cinkeys-=0#           " Fix # alignment
set tabstop=2             " <tab> inserts 4 spaces,
set shiftwidth=2          "   but an indent level is 2 spaces wide.
set softtabstop=2         " <BS> over an autoindent deletes both spaces.
set expandtab             " Use spaces, not tabs, for autoindent/tab key.
set shiftround            " Round indent to a multiple of shiftwidth
set matchpairs+=<:>       " show matching <> (html mainly) as well
set foldmethod=indent     " allow us to fold on indents
set foldlevel=99          " don't fold by default
""" Use sane camelwords movement always
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
omap <silent> iw <Plug>CamelCaseMotion_iw
xmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
xmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
xmap <silent> ie <Plug>CamelCaseMotion_ie
""" We can't use <C-BS> because of SSH so use <C-Back> and <C-Word> to delete
inoremap <C-b> <C-\><C-o>dB
inoremap <C-w> <C-\><C-o>dW
inoremap <C-h> <C-\><C-o>db
inoremap <C-l> <C-\><C-o>dw
""" Auto-select everything between braces when jumping to match
noremap % v%

""" Use the same keys to switch between vim windows and tmux panes
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> h :TmuxNavigateLeft<cr>
nnoremap <silent> j :TmuxNavigateDown<cr>
nnoremap <silent> k :TmuxNavigateUp<cr>
nnoremap <silent> l :TmuxNavigateRight<cr>
nnoremap <silent> ; :TmuxNavigatePrevious<cr>

set lazyredraw
vnoremap <silent> <C-y> :!push<cr>gv
nnoremap <silent> <C-y> :silent! execute "!push " . shellescape(getline('.'), 1)<cr>:redraw!<cr>
noremap <silent> <C-p> :read !pop ~<cr>


""" Reading/Writing
set noautowrite           " Never write a file unless I request it.
set noautowriteall        " NEVER.
set autoread              " Automatically re-read changed files.
set modeline              " Allow vim options to be embedded in files;
set modelines=5           " they must be within the first or last 5 lines.
set ffs=unix,dos,mac      " Try recognizing dos, unix, and mac line endings.
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o><C-s>
""" Show training whitespace
if !has('win32') && !has('win64')
  set list listchars=tab:»·,trail:·
endif
""" Remove trailing whitespace from code files
autocmd FileType c,cpp,java,php,pl,python,vim
        \ autocmd BufWritePre <buffer> :%s/\s\+$//e

" Autodetect filetype on first save
augroup FiletypeOnSave
  au!
  au BufWritePost * if &ft == "" | filetype detect | endif
augroup END


""" Backup
set backup
call EnsureDirExists($HOME.'/.backup/vim')
call EnsureDirExists($HOME.'/.swap/vim')
set backupdir=~/.backup/vim
set directory=~/.swap/vim

""" Messages, Info, Status
set ls=2                  " allways show status line
set noeb vb t_vb=         " Disable all bells. Seriously, no.
au GUIEnter * set vb t_vb=
set confirm               " Y-N-C prompt if closing with unsaved changes.
set showcmd               " Show incomplete normal mode commands as I type.
set report=0              " : commands always print changed line count.
set shortmess+=a          " Use [+]/[RO]/[w] for modified/readonly/written.

""" Searching and Patterns
set ignorecase            " Default to using case insensitive searches,
set smartcase             " unless uppercase letters are used in the regex.
set smarttab              " Handle tabs more intelligently
set incsearch             " Incrementally search while typing a /regex
set nohlsearch            " Don't highlight searches by default.
  " hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>


" ==========================================================
" Airline - style the VIM status bar
" ==========================================================
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#fnamecollapse = 0
let g:airline#extensions#virtualenv#enabled = 0
let g:airline#extensions#tmuxline#enabled = 1
let g:airline_inactive_collapse = 1
let g:virtualenv_auto_activate = 0
set laststatus=2          " Always show statusline, even if only 1 window.
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '' : 'V',
    \ 's'  : 'S',
    \ 'S'  : 'S',
    \ '' : 'S'
    \ }

let g:airline_section_z = airline#section#create(['linenr', ':%3c '])
let g:airline_section_x = airline#section#create_right(['tagbar'])
let g:airline_section_y = airline#section#create_right(['filetype', 'ffenc'])

" ==========================================================
" Tmuxline - style the tbux status bar to look like VIM
" ==========================================================
let g:tmuxline_theme = 'airline_insert'
let g:tmuxline_preset = {
    \ 'a': '#S',
    \ 'b': '#F',
    \ 'c': '#W',
    \ 'win': ['#I', '#W'],
    \ 'cwin': ['#I', '#W'],
    \ 'x': '%a',
    \ 'y': ['%b %d', '%R'] }

" ==========================================================
" Promptline - style the bash prompt to include git info
" ==========================================================
let g:promptline_theme = 'airline'
let g:promptline_preset = {
    \'b': [ promptline#slices#cwd({'dir_limit': 8}) ],
    \'warn': [ promptline#slices#last_exit_code() ]}



" ==========================================================
"  TOOL WINDOWS
" ==========================================================

" ----------------------------------------------------------
"  Quickfix - Shows compiler errors after :make
" ----------------------------------------------------------
" open/close the quickfix window
" nmap <leader>c :copen<CR>
" nmap <leader>cc :cclose<CR>

" ----------------------------------------------------------
"  CommandT - Fuzzy file searching
" ----------------------------------------------------------
map <silent> <F1> :CommandT<CR>
""" Disable optimizations that delay rendering during input
let g:CommandTInputDebounce = 0
let g:CommandTTraverseSCM = "dir"
let g:CommandTWildIgnore = "build/*,**/build/*,ext/*,**/ext/*"

" ----------------------------------------------------------
"  NERDTree - File browser
" ----------------------------------------------------------
let g:Toolwin_Nerd = -1
let g:Toolwin_Ctags = -1

function! Toggle_Toolwin_NerdTree()
  if g:Toolwin_Nerd < 0
    if g:Toolwin_Ctags >= 0
      :TagbarClose
      let g:Toolwin_Ctags = -1
    endif
    :NERDTree
    let g:Toolwin_Nerd = winnr()
  else
    let g:Toolwin_Nerd = -1
    :NERDTreeClose
  endif
endfunction
map <silent> <F2> :call Toggle_Toolwin_NerdTree()<CR>

let g:NERDTreeWinPos = "right"
let g:NERDTreeQuitOnOpen = 1
" Open NERDTree if no files were specified
"au StdinReadPre * let s:std_in=1
"au VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | let g:Toolwin_Nerd=winnr() | endif

" ----------------------------------------------------------
"  CTAGS - Symbol navigation
" ----------------------------------------------------------
" Find tags starting from `pwd` to $HOME
set tags=./tags;$HOME
""" Default to a pretty thin toolwindow
let g:tagbar_width = 30
function! Toggle_Toolwin_Ctags()
  if g:Toolwin_Ctags < 0
    if g:Toolwin_Nerd >= 0
      :NERDTreeClose
      let g:Toolwin_Nerd = -1
    endif
    :TagbarOpen
    let g:Toolwin_Ctags = winnr()
  else
    let g:Toolwin_Ctags = -1
    :TagbarClose
  endif
endfunction
nmap <silent> <F3> :call Toggle_Toolwin_Ctags()<CR>

""" Open the window automatically if there's enough room
function! AutoTagbar()
  let l:width=winwidth(0)
  if (l:width >= 80+g:tagbar_width)
    :TagbarOpen
    let g:Toolwin_Ctags = winnr()
  endif
endfunction
"au FileType c,cpp :call AutoTagbar()


" ----------------------------------------------------------
"  Gundo - Undo tree visualization
" ----------------------------------------------------------
noremap <silent> <F4> :GundoToggle<CR>
""" Persistent undo
set undodir=$HOME/.vim/.undo
silent! call EnsureDirExists(&undodir)
set undofile

" ----------------------------------------------------------
"  Make - build environment
" ----------------------------------------------------------
map <silent> <F5> :make<CR>
""" Automatically show errors in the quickwindow
au QuickFixCmdPost [^l]* nested cwindow
au QuickFixCmdPost    l* nested lwindow



" ==========================================================
"  General Shortcuts
" ==========================================================
let mapleader=","
""" Respond to typos
command! W :w
command! Q :q
""" sudo write this (if we opened without permissions by mistake)
cmap W! w !sudo tee % >/dev/null
""" Reload Vimrc
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe
    \ ":echo 'vimrc reloaded'"<CR>

" ----------------------------------------------------------
"  Window management
" ----------------------------------------------------------
" make these all work in insert mode too (<C-O> makes next cmd
"  happen as if in command mode)
imap <C-W> <C-O><C-W>

""" Always split windows down and to the right
set splitright
set splitbelow

" ctrl-jklm  changes to that split
map <c-L> <c-W>l
map <c-H> <c-W>h
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

" ----------------------------------------------------------
"  Window management - Resizing
" ----------------------------------------------------------
""" Enter window sizing mode for one second when <Window>[-=,.] is pressed
""" Synonyms for -+/<>, but don't use those because they require shift
call tinymode#ModeMsg("winsize", "Change window size +/-")
call tinymode#ModeArg("winsize", "timeoutlen", 1000)
call tinymode#EnterMap("winsize", "<C-W>=", "+")
call tinymode#EnterMap("winsize", "<C-W>-", "-")
call tinymode#EnterMap("winsize", "<C-W>,", "<")
call tinymode#EnterMap("winsize", "<C-W>.", ">")
call tinymode#Map("winsize", "=", "2wincmd +")
call tinymode#Map("winsize", "-", "2wincmd -")
call tinymode#Map("winsize", ",", "2wincmd <")
call tinymode#Map("winsize", ".", "2wincmd >")

" ----------------------------------------------------------
"  Window management - Splitting
" ----------------------------------------------------------
""" Split optimally given the window size
function! SplitWindow()
  let l:height=winheight(0) * 2
  let l:width=winwidth(0)
  if (l:height > l:width)
     :split
  else
     :vsplit
  endif
endfunction
" I inevitably forget to hold or release C for the second stroke
nmap <silent> <C-W><C-M> :call SplitWindow()<CR>
nmap <silent> <C-W>m :call SplitWindow()<CR>
""" Toggle the scroll bind on this window
nmap <silent> <C-W><C-B> :set scb!<CR>

" ----------------------------------------------------------
"  Buffer management (use buffers like people use tabs)
" ----------------------------------------------------------
" List open buffers
nnoremap <leader>bl :ls<CR>
" Open a new, empty, buffer
nnoremap <silent> <leader>e :enew<CR>
" Close this buffer and go to the previous one
nnoremap <silent> <leader>q :silent! :bp <BAR> bd #<CR>:redraw!<CR>
" Navigate between buffers - right hand (normal vim idiom)
nnoremap <silent> <leader>h :silent! bprevious<CR>:redraw!<CR>
nnoremap <silent> <leader>l :silent! bnext<CR>:redraw!<CR>
" Left hand bindings (since <leader> is on the right)
nmap <leader>a <leader>h
nmap <leader>d <leader>l
" There's got to be a better way to do this
nnoremap <silent> <leader>1 :buf 1<CR>
nnoremap <silent> <leader>2 :buf 2<CR>
nnoremap <silent> <leader>3 :buf 3<CR>
nnoremap <silent> <leader>4 :buf 4<CR>
nnoremap <silent> <leader>5 :buf 5<CR>
nnoremap <silent> <leader>6 :buf 6<CR>
nnoremap <silent> <leader>7 :buf 7<CR>
nnoremap <silent> <leader>8 :buf 8<CR>
nnoremap <silent> <leader>9 :buf 9<CR>
nnoremap <silent> <leader>0 :buf 0<CR>

""" Use Tab for escape
nnoremap <Tab> <Esc>
vnoremap <Tab> <Esc>gV
onoremap <Tab> <Esc>
inoremap <Tab> <Esc>`^
""" Use left+right hand chord for inserting/removing tabs in insert mode
inoremap <C-]> <Tab>
""" Something fucked up S-BS to make it delete words... kills me
inoremap  


" ==========================================================
" Language specific stuff
" ==========================================================

" ----------------------------------------------------------
"  C++
" ----------------------------------------------------------
""" Stop auto-continuing line comments
au FileType c,cpp setlocal comments-=:// comments+=f://

""" Find a project config file
let g:include_path_config_file = ".includedirs"
" Stop searching here
let g:include_path_config_path_top = expand("$HOME/code")
fu! SourceProjectConfig(dir)
  if a:dir == g:include_path_config_path_top || a:dir == '/' | return | endif
  if !exists('&g:syntastic_cpp_include_dirs') | let g:syntastic_cpp_include_dirs = [] | endif
  for f in glob(fnameescape(a:dir).'/{,.}*', 1, 1)
    if fnamemodify(f, ':t') ==# g:include_path_config_file
      for line in readfile(f)
        let line = fnamemodify(a:dir.'/'.fnameescape(line), ':p')
        let g:syntastic_cpp_include_dirs = g:syntastic_cpp_include_dirs + [line]
        let &path = &path . ',' . line
      endfor
      return
    endif
  endfor
  call SourceProjectConfig(fnamemodify(a:dir, ':h'))
endfunction

au FileType cpp call SourceProjectConfig(getcwd())

au BufRead */wscript setf python
au BufWritePost */wscript setf python
au FileType python setlocal shiftwidth=2 tabstop=2 expandtab

au BufRead */c++/* setf cpp
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++11'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_auto_refresh_includes = 1
let g:syntastic_cpp_config_file = ".syntastic"

""" Use clang compiler for autocomplete
"let g:clang_use_library=1
"""" Display compile errors
"let g:clang_complete_copen=1
"let g:clang_complete_macros=1
"let g:clang_complete_patterns=0
"""" HATE
"let g:clang_snippets = 0
"
"let g:clang_memory_percent=70
"let g:clang_user_options=' -std=c++11 || exit 0'
"""" 0: Don't select the first completion item
"""" 1: Select the first completion item and insert it on <Enter>
"""" 2: Automatically insert what clang thinks is right
"let g:clang_auto_select=1

""" Use clang for source formatting
""" Pick up the format from each project
let g:clang_format#detect_style_file = 1
""" Format on save
let g:clang_format#auto_format = 0
noremap <silent> <F12> :silent! :ClangFormat<CR>

""" Update ctags in the background
"let g:easytags_async = 1
"""" Separate tags into lanuage-specific files (duh)
"let g:easytags_by_filetype="~/.tags"
"""" Apparently generates much larger files, but members are kind of important
"let g:easytags_include_members = 1
