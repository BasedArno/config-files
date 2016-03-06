""" VIMRC
"" Arno Byrd

"" basic setup
set nocompatible
set backspace=indent,eol,start
set history=100
set incsearch
set hidden " switch between buffers without saving
set autoread " automatically reload externally edited files
set mouse=a
set scrolloff=4 " cursor position while scrolling
set wildmode=longest,list " better tab expansion
set notitle
filetype plugin indent on

" tabs
set smartindent
set autoindent
" but keep the indent for lines starting with #
inoremap # X#
set smarttab
set tabstop=4 " existing tabs
set shiftwidth=4 " <gv and >gv indent
set softtabstop=4 " inserted tabs

" folding
set foldenable
set foldmethod=syntax
set foldlevel=1

" accidental capital letters
command! W w
command! Q q
"" ------

"" colors
syntax on
filetype on
colorscheme wombat
autocmd BufNewFile,BufRead *.bash* set filetype=sh " for .bashrc, .bash_functions, etc...
autocmd BufNewFile,BufRead *.functions* set filetype=sh " for .bashrc, .bash_functions, etc...
autocmd BufNewFile,BufRead *.alias* set filetype=sh " for .bashrc, .bash_functions, etc...
" show trailing whitespace as well as tab/space mixing before a function
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+\%#\@<!$/
"" ------

"" user commands
let mapleader=' ' " space bar ftw
" indenting operators
vnoremap < <gv
vnoremap > >gv
" for inserting/removing comments
noremap <leader># I#<esc>
noremap <leader>$ F#x
" save and exit in insert mode
inoremap XX <esc>:x
inoremap WW <esc>:w
inoremap QQ <esc>:q!
inoremap ZZ <esc>
noremap Q gQ
" editing vimrc
noremap <leader>s :source ~/.vimrc<CR>
noremap <leader>v :e ~/.vimrc<CR>
" buffer scrolling
" maps to Ctrl-Pgdn
nmap [1;3C :next<CR>
" maps to Ctrl-Pgup
nmap [1;3D :prev<CR>
" for overriding read-only files
cmap w!! w !sudo tee % >/dev/null
"" ------

"" help
function GetHelp()
	" clear the `w` register
	normal qwq
	" put the word under the cursor intor register `w`
	normal "Wyiw
	" call the help function on it
	execute "help"  @w
endfunction
map <F1> :call GetHelp()<CR>
imap <F1> <C-O>:call GetHelp()<CR>
"" ------

"" toggle paste
set pastetoggle=<F2>
" you can turn paste on in insert mode but not off
"" ------

"" toggle numbering
let g:numbers_enabled = 0
function ToggleNumbers()
	if g:numbers_enabled
		set nonumber
		let g:numbers_enabled = 0
	else
		set number
		let g:numbers_enabled = 1
	endif
endfunction
map <F3> :call ToggleNumbers()<CR>
imap <F3> <C-O>:call ToggleNumbers()<CR>
"" ------

"" list maps
"map <F12> :call map()<CR>
"imap <F12> <C-O>:call map()<CR>
"" ------

"" my-statusline
runtime! status.vim
"" ------

"" Conque-Terminal
function Shell(args)
	execute "ConqueTerm" a:args
endfunction
command! -nargs=* Shell call Shell('<args>')
"" ------

"" file explorer (netrw)
let g:netrw_browse_split=4
"" ------

"" julia-vim
runtime macros/matchit.vim
"" ------

"" latex-to-unicode
function Togglelatexmode()
	call LaTeXtoUnicode#Toggle()
	if b:l2u_enabled
		echo 'LaTeX mode on'
	else
		echo 'LaTeX mode off'
	endif
endfunction
noremap <expr> <F7> Togglelatexmode()
inoremap <expr> <F7> Togglelatexmode()
"" ------

"" wrapping
set nowrap
"set textwidth=120
set colorcolumn=80
let &colorcolumn=join(range(81,999),",")
hi colorcolumn ctermbg=235 guibg=#2c2d27
"" ------

"" multiline f command
function FindChar(flag)
	let c = nr2char( getchar() )
	let match = search('\V' . c, a:flag)
endfunction
onoremap u :call FindChar('W')<CR>
onoremap U :call FindChar('Wb')<CR>
noremap <leader>u :call FindChar('W')<CR>
noremap <leader>U :call FindChar('Wb')<CR>
"" ------
""" ---------
