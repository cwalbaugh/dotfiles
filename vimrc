set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

"enable mouse
if has('mouse')
  set mouse=a
endif


"Add numbers to the side
set number

" make jk take you from insert to normal
imap jk <Esc> :update<cr>

"map arrow keys to add and switch between tabs
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

"Pangloss"
""Plug 'https://github.com/pangloss/vim-javascript.git'

"Papercolor
"Plug 'https://github.com/NLKNguyen/papercolor-theme.git'
Plug 'https://github.com/altercation/vim-colors-solarized.git'

"Tpope Surround
Plug 'https://github.com/tpope/vim-surround.git' 

"repeat so that we can repeat surround commands
Plug 'https://github.com/tpope/vim-repeat.git'

"makes the '%' command work better
Plug 'https://github.com/tmhedberg/matchit.git'

"NERDtree for navigation
Plug 'https://github.com/scrooloose/nerdtree.git'


call plug#end()

"Shortcut for opening NERDtree
map <C-n> :NERDTreeToggle<CR>

"PaperColor 'color' theme

"set t_Co=256   " This is may or may not needed.
"syntax enable
"set background=light
"colorscheme PaperColor

set t_Co=256
syntax enable
set background=light
colorscheme solarized


"set timeout to longer time helps surround.vim work
set timeout timeoutlen=1000 ttimeoutlen=0


"AUTO COMPLETE SYMETTRIC SYMBOLS <-----------------

"behavior one: insert symbol and matching symbol is added while cursor remains inside both characters. tab to escape.
"behavior two: insert symbol and hit leader key just enters the symbol like it would normally.
"behavior three: insert symbol and hit enter key to enter both opening and closing symbols serparated by a line. tab to escape.

"tab + leader in insert mode just adds a tab



"problem: setting up remmapings for each kind of symbol is annoying
"todo: make some kind of loop that allows us to just add the opening and closing symbols we want and then it remaps it for us.

"problem: sometimes we have to jump out of multiple nestings in a row and hitting tab a ton of times is annoying
"todo: add super TAB that escapes to global level, ie. cntrl-tab=escape all punctuation

"problem: we have to type :set filetype=html on html files for tag completion to work
"todo: add autodetect of filetype so you don't have to type :set filetype=html

"problem: stack only remembers the '>' character for html tags and has trouble with deeply nested tags
"todo: add record of html completed tags to the stack to allow us to escape nested tags. Or use a better function which doesn't just remember the closing symbols used, but is smarter and knows the nesting of the cursor position.

"problem: autoindent and smartindent add extra tabs where we don't want them sometimes.
"todo: add section to handle the potential of autoindent or smart indent being set on, ie., turn them off

"problem: when symbols are added to the stack, and then we navigated out of one nested area to another without tab, the stack is no longer relevent to that location
"todo: change from a strategy that uses a stack to one that has a smarter function which recognizes the current nesting of the cursor

"Old method for autocomplete, kept for reference

"auto close punctuation, ctrl-j to move out of punctuation
"autocomple html tags, ctrl-j to move out of tags
"todo: add some kind of loop that saves the previous leavechar,
"looping so that you can escape nested punctuation
""inoremap ( ()<Esc>:let leavechar=")"<CR>i
""inoremap [ []<Esc>:let leavechar="]"<CR>i
""inoremap { {<CR><CR>}<Esc>:let leavechar="}"<CR>ki<TAB>
""inoremap " ""<Esc>:let leavechar="\""<CR>i
""inoremap ' ''<Esc>:let leavechar="\'"<CR>i
"""inoremap < <><Esc>:let leavechar=">"<CR>i
"""inoremap <buffer> > ></<C-x><C-o><C-y><C-o>%a<Esc>:let leavechar=">"<CR>
""
""imap <C-j> <Esc>:exec "normal f" . leavechar<CR>a

"End of old method


"Auto complete for html tags and punctuation

"html tag completion
function s:CompleteTags()
  inoremap <buffer> > ></<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR><C-o>:call BC_AddChar(">")<CR>
  inoremap <buffer> ><Leader> >
  inoremap <buffer> ><CR> ></<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR><CR><Tab><CR><Up><C-O>$<C-o>:call BC_AddChar(">")<CR>
endfunction
autocmd BufRead,BufNewFile *.html,*.js,*.xml call s:CompleteTags()

"insert matching tag and run BC_AddChar, then insert at correct location
inoremap ( ()<Esc>:call BC_AddChar(")")<CR>i
inoremap (<Leader> (
inoremap (<CR> (<CR>)<Esc>:call BC_AddChar(")")<CR><Esc>kA<CR><TAB>

inoremap { {}<Esc>:call BC_AddChar("}")<CR>i
inoremap {<Leader> {
inoremap {<CR> {<CR>}<Esc>:call BC_AddChar("}")<CR><Esc>kA<CR>

inoremap [ []<Esc>:call BC_AddChar("]")<CR>i
inoremap [<Leader> [
inoremap [<CR> [<CR>]<Esc>:call BC_AddChar("]")<CR><Esc>kA<CR><TAB>

inoremap /* /**/<Esc>:call BC_AddChar("*/")<CR>hi
inoremap /*<Leader> /*
inoremap /*<CR> /*<CR>*/<Esc>:call BC_AddChar("*/")<CR><Esc>kA<CR>

inoremap " ""<Esc>:call BC_AddChar("\"")<CR>i
inoremap "<Leader> "
inoremap "<CR> "<CR>"<Esc>:call BC_AddChar("\"")<CR><Esc>kA<CR>

inoremap ' ''<Esc>:call BC_AddChar("\'")<CR>i
inoremap '<Leader> '
inoremap '<CR> '<CR>'<Esc>:call BC_AddChar("\'")<CR><Esc>kA<CR>

" jump out of parenthesis
inoremap <TAB> <Esc>:call search(BC_GetChar(), "W")<CR>a

"adds punctuation character to stack to be called back later
function! BC_AddChar(schar)
 if exists("b:robstack")
 let b:robstack = b:robstack . a:schar
 else
 let b:robstack = a:schar
 endif
endfunction

"gets the character to use to escape pundtuation
function! BC_GetChar()
 let l:char = b:robstack[strlen(b:robstack)-1]
 let b:robstack = strpart(b:robstack, 0, strlen(b:robstack)-1)
 return l:char
endfunction

"disable vim's autocomment. This is necessary for remmapping of comments done above to work
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"for the times when you just actually need the tab key
inoremap <TAB><Leader> <TAB>

"END AUTO COMPLETE SYMETTRIC SYMBOLS <-------------------

