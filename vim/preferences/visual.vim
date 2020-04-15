" Visual

" Syntax
syntax enable
set termguicolors

" Copy indentation from previous line
set autoindent

" Expand tabs to spaces
set expandtab

" Tabs equal two spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Hidden characters
set listchars=tab:>\ ,trail:-,nbsp:+,space:⋅,eol:¬

" Do not wrap long horizontal lines
set linebreak
set nowrap

" Ignore case type when searching
set ignorecase
" Override case if using uppercase
set smartcase

" Linenumbers
set nonumber norelativenumber
set numberwidth=1

" Cursor line
set cursorline

" Hide last message when in insert, replace, or visual mode
set noshowmode

" Short Message
" I - Hide intro message
" W - Hide `written` message when saving
" c	- don't give |ins-completion-menu| messages.
" F	- don't give file info
set shortmess=IWacFt

" Show All Characters
set conceallevel=0

" Show Sign Column (git, lint)
set signcolumn=yes:1

" Window Management
set splitbelow
set splitright

" Fold Method
set foldopen-=hor

" Window Sizes
set winwidth=36
set winminwidth=6
set winminheight=0
set winheight=6