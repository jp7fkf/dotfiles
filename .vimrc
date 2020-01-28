"------------------------------------
" JP7FKF's vimrc
"------------------------------------

" --------------------
" General
" --------------------
set nocp
set filetype=on
filetype plugin indent on
set fileencoding=utf-8
set browsedir=buffer
autocmd BufReadPost * loadview
set incsearch

" delete whitespace of line ends
fun! StripTrailingWhitespace()
    " don't strip on these filetypes
    if &ft =~ 'modula2\|markdown'
        return
    endif
    %s/^ *$//g
endfun
autocmd BufWritePre * call StripTrailingWhitespace()

" backups
set backup
set backupdir=$HOME/.vimbackup
set undodir=D:$HOME/.vimbackup

" Swap files
set swapfile
set directory=$HOME/.vimbackup
set updatecount=100
set updatetime=180000

" Backspace
set backspace=start,eol,indent

" clipboard
set clipboard=unnamed

" set character code UTF-8
set fenc=utf-8
" no baskup files
set nobackup
" no swp files
set noswapfile
" reload when file changes
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" show inputting command
set showcmd

" --------------------
" Visual
" --------------------
" syntax highlight
syntax enable
colorscheme monokai
" show line numbers
set number
" Highlighting current line(horizontal)
set cursorline
" Highlighting current line(vertical)
set cursorcolumn
" cursor can go to the end of line +1
set virtualedit=onemore
set smartindent
set visualbell
" highlight corrensponding bracket
set showmatch
set colorcolumn=80

" syntax highlight on iterm2,macos
let OSTYPE = system('uname')
if OSTYPE == "Darwin\n"
  set term=xterm-256color
endif

"" Status Line
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" visualize FULL width space
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/

" mouse
set mouse=h
set mousehide

" completion of commandlines
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk

" Tabs
" visualize invisible chars(tab)
set list listchars=tab:\▸\-
" whitespace tab
set expandtab
" tab width in single tab
set tabstop=2
" tab width in begin of line
set shiftwidth=2

" Search
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" コード補完関連
set wildmenu wildmode=list:full

" 入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

" --------------------------
" Language Specific Settings
" --------------------------
" 共通
set autoindent smartindent expandtab nocindent tabstop=2 softtabstop=2 shiftwidth=2

" HTML
autocmd FileType html setlocal nocindent tabstop=2 softtabstop=2 shiftwidth=2

" CSS
autocmd FileType css setlocal nocindent tabstop=2 softtabstop=2 shiftwidth=2

" C言語
autocmd FileType c setlocal cindent tabstop=8 softtabstop=8 shiftwidth=8

" Python
autocmd FileType python setl cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=2

" Ruby
autocmd FileType ruby setl tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" erb
autocmd FileType eruby setl tabstop=2 shiftwidth=2 softtabstop=2

" slim
autocmd FileType slim setl tabstop=2 shiftwidth=2 softtabstop=2

autocmd FileType scss setl tabstop=2 shiftwidth=2 softtabstop=2

" Javascript
autocmd filetype javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab

" JSON
autocmd BufNewFile,BufRead *.json  set filetype=json
autocmd BufNewFile,BufRead *.json  set tabstop=2 shiftwidth=2 expandtab

" Coffee Script
autocmd FileType coffee setl tabstop=2 shiftwidth=2 softtabstop=2

" Jinja
autocmd FileType jinja setl tabstop=8 softtabstop=2 shiftwidth=2

" Markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown

" TeX
let g:tex_conceal=''

" YAML
autocmd FileType yaml,yml setl tabstop=2 shiftwidth=2 softtabstop=2

"------------------------------------
" indent guides
"------------------------------------
hi IndentGuidesOdd  ctermbg=white
hi IndentGuidesEven ctermbg=white
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

"------------------------------------
" 外部ファイル
"------------------------------------
" 補完関連
" source ~/dotfiles/.vimrc.completion

" unite.vim
" source ~/dotfiles/.vimrc.unite

" neobundle
" source ~/dotfiles/.vimrc.neobundle

"------------------------------------
" プラグイン設定
"------------------------------------
"" vim-quickrun
"" let g:quickrun_config = {'*': {'hook/time/enable': '1'},}
"
"
"" vim-nodejs-complete
"setl omnifunc=jscomplete#CompleteJS
"if !exists('g:neocomplcache_omni_functions')
"  let g:neocomplcache_omni_functions = {}
"endif
"let g:neocomplcache_omni_functions.javascript = 'nodejscomplete#CompleteJS'
"let g:node_usejscomplete = 1
"
"" neocomplcache
""" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
"let g:neocomplcache_force_overwrite_completefunc=1
"let g:neocomplcache_enable_camel_case_completion = 0
"
"" taglist.vim
"set tags=tags
"nmap <F8> :Tlist
"
"" NERDTreeToggle
"nmap <F9> :NERDTreeToggle
"let NERDTreeShowHidden = 1
"let g:NERDTreeWinSize = 40
"
"set fileformats=unix,dos,mac
"" □とか○の文字があってもカーソル位置がずれないようにする
"if exists('&ambiwidth')
"  set ambiwidth=double
"endif
"
"" vim-go
"let g:go_fmt_command = "goimports"
"

