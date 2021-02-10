
" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
echohl ErrorMsg
echomsg a:msg
echohl NONE
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)

	if empty(a:buffer)
		let btarget = bufnr('%')
	elseif a:buffer =~ '^\d\+$'
		let btarget = bufnr(str2nr(a:buffer))
	else
		let btarget = bufnr(a:buffer)
	endif


	if btarget < 0
		call s:Warn('No matching buffer for '.a:buffer)
		return
	endif

	if empty(a:bang) && getbufvar(btarget, '&modified')
		call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
		return
	endif

	" Numbers of windows that view target buffer which we will delete.
	let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
	if !g:bclose_multiple && len(wnums) > 1
		call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
		return
	endif

	let wcurrent = winnr()
	for w in wnums
		execute w.'wincmd w'
		let prevbuf = bufnr('#')
		if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
			buffer #
		else
			bprevious
		endif

		if btarget == bufnr('%')
			" Numbers of listed buffers which are not the target to be deleted.
			let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
			" Listed, not target, and not displayed.
			let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
			" Take the first buffer, if any (could be more intelligent).
			let bjump = (bhidden + blisted + [-1])[0]

			if bjump > 0
				execute 'buffer '.bjump
			else
				execute 'enew'.a:bang
			endif
		endif
	endfor
	execute 'bdelete'.a:bang.' '.btarget
	execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose('<bang>', '<args>')

function CloseBuffer()
	if bufname("") == "NERD_tree_1"
		return
	endif
	let lenBuffers = len(getbufinfo({'buflisted':1}))
	if lenBuffers == 1
		NERDTreeClose
		q!
	else
		Bclose
	endif
	" echo len(a:buffer)
	" :NERDTreeClose<CR>
endfunction

function CloseAll()
	if bufname("") == "NERD_tree_1"
		return
	endif
	NERDTreeClose
	q!
endfunction

" command! -bang -complete=buffer -nargs=? Bnum call BufferNumber('<bang>', '<args>')

function CheckNerd(where)
	if bufname("") != "NERD_tree_1"
		if a:where == "next"
			bnext
		else
			bprev
		endif
	endif
endfunction



" Moving between buffers
nnoremap <silent> <TAB> :call CheckNerd("next")<CR>
nnoremap <silent> <S-TAB> :call CheckNerd("prev")<CR>


nnoremap <silent> <A-q> :call CloseBuffer()<CR>
nnoremap <silent> <C-q> :call CloseAll()<CR>
nnoremap <silent> <C-P> :call CheckNerd()<CR>
" map <C-P> :NERDTreeClose<CR>
nnoremap <silent> <Leader>bD :Bclose!<CR>

nnoremap <F12> :e ++enc=cp1251<CR>

" dont leave visual mode upon indenting
vnoremap < <gv
vnoremap > >gv
map <F1> <Nop>

set showtabline=0
set hidden

set nowrap "show long lines as one
set mouse=a " enable mouse
set number relativenumber
set shell=bash

map <silent> <C-t> :NERDTreeToggle<CR>
map <silent> <C-B> :bdelete<CR> <bar> :blast<CR> <bar> :NERDTreeToggle<CR>

nnoremap <silent> <C-s> :w<CR>

"Run terminal
nnoremap <A-t> :silent exec "!setsid alacritty"<CR>
nnoremap <A-r> :silent exec "!setsid fish -c '$TERM -e ranger'"<CR>

" Puttin a colon at the end of the line
" inoremap <C-q>  <C-o>ma<C-o><S-a>;<C-o>`a
" nnoremap <C-q>  ma<S-a>;<esc>`a
" nnoremap <C-i>  <C-^>
inoremap <C-z>  <C-^>
inoremap <C-я>  <C-^>

function! Get_visual_selection()
    "Get the position of left start visual selection
    let [line_start, column_start] = getpos("'<")[1:2]
    "Get the position of right end visual selection
    let [line_end, column_end] = getpos("'>")[1:2]
    "gotta catch them all.
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    "edge cases and cleanup.
    let lines[-1] = lines[-1][: column_end - 1]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function Save_visually_selected_text_to_file()
    let selected_text = Get_visual_selection()
	echom system("xsel -i --clipboard", selected_text)
    " call writefile(split(selected_text, "\n"), "./something.txt")
endfunction



" Use system clipboard for all yank, delete, change and put operations
" set clipboard=unnamedplus
" set clipboard=unnamedplus

" vnoremap <C-x> :call Save_visually_selected_text_to_file()<cr> <bar> "_c
vnoremap <C-x> "_c
vnoremap <C-c> :call Save_visually_selected_text_to_file()<cr>
" vnoremap <C-c> "0y
" nnoremap <C-v> "0p

" vnoremap c "_c
" nnoremap cc "_cc
" nnoremap cw "_cw
" nnoremap ce "_ce
" nnoremap cl "_cl

nmap <silent><space>= :vertical resize +5<CR>
nmap <silent><space>- :vertical resize -5<CR>

nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

set shiftwidth=4
set autoindent
set tabstop=4

set encoding=utf-8 " The encoding displayed
set fileencoding=utf-8 " The encoding written to file

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

