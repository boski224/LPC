
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set nu
" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
" if has('mouse')
"   set mouse=a
" endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
"  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" #### Moje opcje #########################
" Aby poprzegladac ustawienia: :options		:browse options
" :browse

syntax enable		" Wlacza podswietlanie skladni
set showmode		" Pokazuje aktywny tryb pracy
set showcmd		" Pokazuje wpusywana komende w pasku stanu
set wildmenu		" Wlacza uzupelnianie polecen w trybie wykonywania
set ruler 		" Wlacza info o stanie edytora u dolu ekranu
"runtime ftplugin/man/vim	" Wlacza obsluge stron man. Uzycie -> :Man <temat>
set expandtab		" Zmienia tab na ciag spacji
set nowrap		" Nie zawijaj wierszy
set hlsearch		" Podswietla wszystkie wyniki wyszukiwania
set showmatch		" Podswietla odpowiadajace nawiasy, klamry, etc...
" set ignorecase 		" Ignoruje wielkosc znakow podczas wyszukiwania
set smartcase 		" Jesli szukana fraza zawiera wielka litere, wylacza 'ignorecase'
" set path=., .., ~, 	" Ustawia domyslne sciezki wyszukiwania plikow
set spelllang=pl_pl	" Ustawia sprawdzanie pisowni w j. polskim 

set tabstop=4  		" Standardowe taby o szer 8 znakow
set shiftwidth=2 	" 4-znakowe wciecia
set shiftround 		" Zmieniaj wciecie wyrownojac do wartosci shiftwidth
set autoindent 		" Automatycznie ustawiaj wciecie w nowej linii


syntax on
set number

"--< 
" ===============### PARTIALLY FORM AKAM ###===============================
"Setting from jakilinux.org (
"http://jakilinux.org/aplikacje/konsola/terminal-do-pracy-czesc-3-screen/ )
">--"
"
""--< GENERAL >--"
set smartindent
set nobackup
"--< set nowrap >--"
"set history=32
"set ruler
"set showcmd
"set incsearch
"set hlsearch
"set tabstop=8
"set shiftwidth=8
set paste
"set autoindent
"
""--< COLORS / SYNTAX >--"
"syntax on

"--< TABS BINDINGS >--"
map <C-t>       :tabnew<CR>
"map <C-w>       :tabclose<CR> " Turned off because <C-w> id used to nawigate between splitted windows
map <C-h>       :tabp<CR>
map <C-l>       :tabn<CR>
map <C-k>       :tabfirst<CR>
map <C-j>       :tablast<CR>
""--< New mappings 20150410 >--"
map <F9>        :wq<CR>
map <F10>       :q!<CR>
map <F2>        :w<CR>
"--< map <C-F9> :qa!<CR> >--"
