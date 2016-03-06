set noruler
set noshowmode
set laststatus=2
set noignorecase
set encoding=utf-8

let s:status_text = {
	\ 'n' : '  NORMAL ',
	\ 'no': '  N·MOVE ',
	\ 'i' : '  INSERT ',
	\ 'R' : '  REPLACE ',
	\ 'Rv': '  V·REPLACE ',
	\ 'v' : '  VISUAL ',
	\ 'V' : '  V·LINE ',
	\ '': '  V·BLOCK',
	\ 's' : '  SELECT ',
	\ 'S' : '  S·LINE ',
	\ '' : '  S·BLOCK ',
	\ 'c' : '  COMMAND ',
	\ 'cv': '  VIM·EX ',
	\ 'ce': '  EX ',
	\ 'r' : '  PROMPT ',
	\ 'rm': '  MORE ',
	\ 'r?': '  CONFIRM ',
	\ '!' : '  SHELL ',
	\}

function! StatuslineMode(mode)
	" find the current mode and set highlight
	if a:mode ==# 'n'
		hi statusline ctermbg=blue ctermfg=white guifg=black guibg=blue
	elseif a:mode ==# 'no'
		hi statusline ctermbg=blue ctermfg=grey guifg=darkgrey guibg=blue
	elseif a:mode ==# 'i'
		hi statusline ctermbg=green ctermfg=white guifg=black guibg=green
	elseif (a:mode ==# 'R' || a:mode ==# 'Rv')
		hi statusline ctermbg=magenta ctermfg=white guifg=black guibg=purple
	elseif (a:mode ==# 'v' || a:mode ==# 'V' || a:mode ==# '' || a:mode ==# 's' || a:mode ==# 'S' || a:mode ==# '')
		hi statusline ctermbg=yellow ctermfg=white guifg=black guibg=yellow
	elseif (a:mode ==# 'c' || a:mode ==# 'cv' || a:mode ==# 'ce')
		hi statusline ctermbg=30 ctermfg=white guifg=black guibg=cyan
	else
		hi statusline ctermbg=red ctermfg=white guifg=black guibg=red
		echo a:mode
		echo 'unknown option'
	endif

	" use the text defined in the dictionary above
	if has_key(s:status_text, a:mode)
		return s:status_text[a:mode]
	else
		echo a:mode
		return 'UNKNOWN'
	endif
endfunction

function! Tidbits()
	let l:special = 0 " Boolean set to false unless file is special
	let l:info=''

	" tests
	if &modified
		let l:info = join([l:info, ' +'],'')
		let l:special = 1
	endif
	if &readonly
		let l:info = join([l:info, ' !!'],'')
		let l:special = 1
	endif

	" final output
	if l:special
		let l:info = join(['<-', l:info, ' '],'')
	endif
	return l:info
endfunction

function! PasteMode()
	if &paste
		return '(paste mode)'
	endif
	" else
	return ''
endfunction

hi User1 ctermfg=white guifg=white ctermbg=235 guibg=#262626 cterm=none
hi User2 ctermfg=white guifg=white ctermbg=105 guibg=#8787ff
hi User3 ctermfg=white guifg=white ctermbg=60 guibg=#5f5f87 cterm=bold

" Mode
set statusline=%{StatuslineMode(mode())}
" Buffer
set statusline+=%1*
set statusline+=%{PasteMode()}
" Split
set statusline+=%=
" Line Info
set statusline+=%2*
set statusline+=\  
set statusline+=%l
set statusline+=/
set statusline+=%L
set statusline+=,
set statusline+=%c%V
set statusline+=\  
" Filename
set statusline+=%3*
set statusline+=\  
set statusline+=%f "filename
set statusline+=(%n) "buffer number
set statusline+=\  
set statusline+=%{Tidbits()}

autocmd BufEnter,BufLeave,BufUnload * call StatuslineMode(mode())
autocmd WinEnter,WinLeave * call StatuslineMode(mode())
autocmd TabEnter,TabLeave * call StatuslineMode(mode())
"autocmd FileType * call StatuslineMode(mode())
autocmd CmdWinEnter,CmdWinLeave * call StatuslineMode(mode())
autocmd InsertEnter,InsertLeave * call StatuslineMode(mode())
"autocmd InsertChange * call StatuslineMode(mode())
