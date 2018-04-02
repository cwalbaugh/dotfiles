" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")


" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

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
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
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

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif


" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
packadd matchit

"Add numbers to the side
set number

" set zz to update the current file if there are changes
" nnoremap zz :update<cr>

" make jk take you from insert to normal
imap jk <Esc> :update<cr>

"map f7 and f8 so as tabn and tabp for tab switching
map <left> :tabp<cr>
map <right> :tabn<cr>
map <up> :tabe<space>
map <down> :wq<cr>

" add emphasis to current line
set cursorline


"use hybrid relative numbers in insert mode, absolute in normal

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END



"vimPlug section
" automatic installaion

if empty(glob('~/.vim/autoload/plug.vim'))
	  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif


call plug#begin('~/.vim/plugged')

Plug 'https://github.com/pangloss/vim-javascript.git'

"Papercolor
Plug 'https://github.com/NLKNguyen/papercolor-theme.git'

"Tpope Surround
Plug 'https://github.com/tpope/vim-surround.git' 

"repeat so that we can repeat surround commands
Plug 'https://github.com/tpope/vim-repeat.git'

call plug#end()


"Space grey 'color' theme

set t_Co=256   " This  may or may not needed.

set background=light
colorscheme PaperColor

"auto insert right bracket and set cursor inbetween with a break
"inoremap { {<CR>}<Esc>O


"set timeout to longer time helps surround.vim work
set timeout timeoutlen=1000 ttimeoutlen=0

"auto close punctuation, ctrl-j to move out of punctuation
"autocomple html tags, ctrl-j to move out of tags
"todo: add some kind of loop that saves the previous leavechar,
"looping so that you can escape nested punctuation
inoremap ( ()<Esc>:let leavechar=")"<CR>i
inoremap [ []<Esc>:let leavechar="]"<CR>i
inoremap { {<CR><CR>}<Esc>:let leavechar="}"<CR>ki<TAB>
inoremap " ""<Esc>:let leavechar="\""<CR>i
inoremap ' ''<Esc>:let leavechar="\'"<CR>i 
"inoremap < <><Esc>:let leavechar=">"<CR>i
"inoremap <buffer> > ></<C-x><C-o><C-y><C-o>%a<Esc>:let leavechar=">"<CR>

imap <C-j> <Esc>:exec "normal f" . leavechar<CR>a

function s:CompleteTags()
  inoremap <buffer> > ></<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR><C-o>:let leavechar=">"<CR>
  inoremap <buffer> ><Leader> >
  inoremap <buffer> ><CR> ></<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR><CR><Tab><CR><Up><C-O>$<C-o>:let leavechar=">"<CR>
endfunction
autocmd BufRead,BufNewFile *.html,*.js,*.xml call s:CompleteTags()
