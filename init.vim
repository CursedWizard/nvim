
call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
	Plug 'potatoesmaster/i3-vim-syntax'

	" Useful tools
    Plug 'jiangmiao/auto-pairs' " Auto pairs for '(' '[' '{'
	Plug 'xuhdev/vim-latex-live-preview'
	Plug 'scrooloose/nerdtree' "filesystem in vim
	Plug 'tpope/vim-commentary' "comment stuff out using gcc
	Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

	" Plug 'ap/vim-buftabline' "Open buffers in new tabs
	Plug 'vimwiki/vimwiki' "for note taking, for files with .wiki
	Plug 'mhinz/vim-startify' "provides a start screen
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'airblade/vim-rooter'

	" Appearence
	Plug 'ryanoasis/vim-devicons' "icons for nerdtree
	Plug 'rakr/vim-one' "default theme, has light and dark version
	Plug 'vim-airline/vim-airline' "theme at the bottom
	Plug 'vim-airline/vim-airline-themes'
	Plug 'gcmt/taboo.vim'

	" Language server
	Plug 'neoclide/coc.nvim', {'branch': 'release'}

	" Better navigation
	Plug 'justinmk/vim-sneak' "find word on the line
	Plug 'unblevable/quick-scope' "switch to word seen on screen, usin s or S

	" Telescope
	Plug 'nvim-lua/popup.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'

call plug#end()


" Setting theme
set background=light " for the light version
colorscheme one

"
" Configs
source /home/funtik/.config/nvim/plug-config/sneak.vim
source /home/funtik/.config/nvim/plug-config/quickscope.vim
source /home/funtik/.config/nvim/plug-config/coc.vim
source /home/funtik/.config/nvim/plug-config/fzf.vim
source /home/funtik/.config/nvim/plug-config/airline.vim
source /home/funtik/.config/nvim/plug-config/telescope.vim
source /home/funtik/.config/nvim/plug-config/rooter.vim
source /home/funtik/.config/nvim/remap.vim

 " Press F12 to switch to UTF-8 encoding


