"------------------------------------
" mktakuyaの.vimrc を盛大にパクらせてもらったJP7FKFの.vimrc
"------------------------------------

" --------------------
" 基本設定
" --------------------
" ファイル読み込み時の設定
set nocp
set filetype=on
filetype plugin indent on
set fileencoding=utf-8
set browsedir=buffer
autocmd BufReadPost * loadview

" 保存時に行末の空白を除去する
fun! StripTrailingWhitespace()
    " don't strip on these filetypes
    if &ft =~ 'modula2\|markdown'
        return
    endif
    %s/^ *$//g
endfun
autocmd BufWritePre * call StripTrailingWhitespace()

" 全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/

set undodir=D:$HOME/.vimbackup

"" ステータスライン
" ステータスラインに文字コード/改行文字種別を表示
" 常にステータス行を表示
set laststatus=2
set statusline =%F%r%h%=
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
"set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]

" バックアップ関連
set backup
set backupdir=$HOME/.vimbackup

" Swapファイル関連
set swapfile
set directory=$HOME/.vimbackup
set updatecount=100
set updatetime=180000

" Backspace関連
set backspace=start,eol,indent

" クリップボード関連の設定
set clipboard=unnamed

" macos iterm2でもsyntax highlight
let OSTYPE = system('uname')
if OSTYPE == "Darwin\n"
  set term=xterm-256color
endif

" 見た目の設定
syntax enable
colorscheme monokai

" setting
"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd


" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
set cursorline
set colorcolumn=80

" マウス関連
set mouse=h
set mousehide

" 検索関連
set incsearch

" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2


" 検索系
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

" --------------------
" 言語別設定
" --------------------
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
"" .md をMarkdownとして扱う
au BufRead,BufNewFile *.md set filetype=markdown

