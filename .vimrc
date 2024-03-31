"---------------------------------------------------------------------------
"plugin設定
" vimの機能を有効化する
set nocompatible
" ファイル形式別pluginを有効化する
" pythonファイルを編集時にタブが自動でexpandされるため、使用しない
"filetype plugin on 

"---------------------------------------------------------------------------
"表示
" カラーテーマ
colorscheme industry
" 現在行数の表示
set number
" 相対行数の表示
set relativenumber
" 行番号の色
highlight LineNr ctermfg=darkyellow
" コマンドラインの画面の行数
set cmdheight=2
" 保存されていないファイルがあるときでも別のファイルを開けるようにする
set hidden
" シンタックスハイライト
syntax on
" vimの行番号・相対行番号を表示
function! Number()
	set number
	set relativenumber
endfunction
" vimの行番号・相対行番号を非表示
function! NoNumber()
	set nonumber
	set norelativenumber
endfunction
" タブの表示
set list listchars=tab:\|\  
"---------------------------------------------------------------------------
"検索
" 検索ワードの最初の文字を入力した時点で検索を開始する
set incsearch
" 大文字と小文字を区別しない
set ignorecase
" 検索ワードに大文字が入ると、ignorecaseを無効とする
set smartcase

"---------------------------------------------------------------------------
"タブ
" タブを表示するときの幅
set tabstop=4
" タブを挿入するときの幅
set shiftwidth=4
" タブをタブとして扱う(スペースに展開しない)
set noexpandtab
" 
set softtabstop=0

"---------------------------------------------------------------------------
"SHELL
" Linuxの場合
if has('linux')
"     bashに設定
	set shell=/bin/bash
" Windowsの場合
elseif has('win32')
	"""コマンドプロンプト用設定
	"set shell=cmd
	"""Powershell用設定
	"set shell=powershell
	"""bash用設定
	set shell=C:¥¥WINDOWS¥¥System32¥¥bash.exe
	"set shelltype=
	"set shellpipe=
	"set shellslash=
	"set shellredir=
	set shellquote=
	set shellxescape=
	set shellxquote=
	set shellcmdflag=-c
	if has('kaoriya')
		set ambiwidth=auto
	endif
endif

"---------------------------------------------------------------------------
"バックアップの設定
set nobackup

"---------------------------------------------------------------------------
"キーバインド
"  zxcv配列の代替キー インクリメント、デクリメントのショートカット
nnoremap <A-a> <C-a>
nnoremap <A-s> <C-s>
nnoremap <A-z> <C-z>
nnoremap <A-x> <C-x>
nnoremap <A-c> <C-c>
nnoremap <A-v> <C-v>

"  bashキーバインドの再現
inoremap <C-h> <BS>
inoremap <C-k> <C-o>d$
"inoremap <C-u> <C-o>d0
"inoremap <C-s> <ESC>/
" the following conflict with C-r register paste command.
"inoremap <C-r> <ESC>? 
inoremap <C-d> <DEL>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
" Cancel for code completion.
"inoremap <C-n> <Down>
"inoremap <C-p> <Up>
inoremap <C-y> <C-o>p
inoremap <C-i> <Tab>
inoremap <C-a> <Home>
inoremap <C-e> <End>
" CUIの性質として、Shift + Enterが検出できないようである。
"inoremap <S-Enter> <Enter><Up>

cnoremap <C-h> <BS>
cnoremap <C-d> <DEL>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-y> <C-o>p

"キー設定関連
"  IME設定
set iminsert=0
set imsearch=0
"set imcmdline

"  設定更新
nnoremap     <F1> :help 
nnoremap   <S-F1> :tabnew<CR>:help 
nnoremap   <C-F1> :helpgrep 
nnoremap <C-S-F1> :tabnew<CR>:helpgrep 
nnoremap     <F5> :source $VIM/gvimrc<CR>
nnoremap <C-S-F5> :tabnew D:¥¥myData¥¥Documents¥¥tools¥¥vim74-kaoriya-win64¥¥gvimrc<CR>

"  マクロのshortcut
nnoremap <C-@> @@

"  xやsではregisterにyankしない
nnoremap x "_x
nnoremap s "_s

"  検索中の単語をハイライトする
set hlsearch

"  カーソル下の単語をハイライトする
nnoremap <silent>  <C-h> "+yiw:let @/ = '¥<' . @+ . '¥>'<CR>:set hlsearch<CR>
nnoremap <silent> g<C-h> "+yiW:let @/ =        @+       <CR>:set hlsearch<CR>

"  空行の挿入
nnoremap   <S-CR> mto<ESC>`t
nnoremap <C-S-CR> mtO<ESC>`t

"  行を移動
nnoremap <S-C-k> ddkP
nnoremap <S-C-j> ddp

"  複数行を移動
vnoremap <S-C-k> "txk"tP`[V`]
vnoremap <S-C-j> "tx"tp`[V`]

"  ハイライト解除
"nnoremap <ESC><ESC> <ESC>:noh<CR>:redir END<CR>
nnoremap <silent> <ESC><ESC> :nohlsearch<CR><C-l>

" vimライクなキーバインド
"nunmap <C-f>

" tabのshortcut
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
nnoremap <A-t>m :tabs<CR>
nnoremap <A-t><C-m> :tabs<CR>
nnoremap <A-t>j ;tabnext<CR>
nnoremap <A-t><C-j> ;tabnext<CR>
nnoremap <A-t>k ;tabprevious<CR>
nnoremap <A-t><C-k> ;tabprevious<CR>
nnoremap <A-t>gg ;tabfirst<CR>
nnoremap <A-t><C-g><C-g> ;tabfirst<CR>
nnoremap <A-t>G ;tablast<CR>
nnoremap <A-t><C-G> ;tablast<CR>
nnoremap <A-t>c ;tabclose<CR>
nnoremap <A-t><C-c> ;tabclose<CR>
nnoremap <A-t>o ;tabonly<CR>
nnoremap <A-t><C-o> ;tabonly<CR>
nnoremap <A-t>d ;tabdo
nnoremap <A-t><C-d> ;tabdo

" bufferのshortcut
nnoremap <A-b>m :ls<CR>
nnoremap <A-b><C-m> :ls<CR>
nnoremap <A-b>j :bnext<CR>
nnoremap <A-b><C-j> :bnext<CR>
nnoremap <A-b>k :bprevious<CR>
nnoremap <A-b><C-k> :bprevious<CR>
nnoremap <A-b>gg :bfirst<CR>
nnoremap <A-b><C-g><C-g> :bfirst<CR>
nnoremap <A-b>G :blast<CR>
nnoremap <A-b><C-G> :blast<CR>
nnoremap <A-b>c :bdelete 
nnoremap <A-b><C-c> :bdelete 
nnoremap <A-b>o :buffer 
nnoremap <A-b><C-o> :buffer 
nnoremap <A-b>d :bufdo
nnoremap <A-b><C-d> :bufdo

" quickfixのshortcut
nnoremap <A-q>m :cwindow<CR>
nnoremap <A-q><C-m> :cwindow<CR>
nnoremap <A-q>j :cnext<CR>
nnoremap <A-q><C-j> :cnext<CR>
nnoremap <A-q>k :cprevious<CR>
nnoremap <A-q><C-k> :cprevious<CR>
nnoremap <A-q>gg :cfirst<CR>
nnoremap <A-q><C-g><C-g> :cfirst<CR>
nnoremap <A-q>G :clast<CR>
nnoremap <A-q><C-G> :clast<CR>
nnoremap <A-q>h :colder<CR>
nnoremap <A-q><C-h> :colder<CR>
nnoremap <A-q>l :cnewer<CR>
nnoremap <A-q><C-l> :cnewer<CR>
nnoremap <A-q>Tab :cnfile<CR>
nnoremap <A-q><C-Tab> :cnfile<CR>
nnoremap <A-q><S-Tab> :cpfile<CR>
nnoremap <A-q><S-C-Tab> :cpfile<CR>
nnoremap <A-q>e :cexpr 
nnoremap <A-q><C-e> :cexpr 
nnoremap <A-q>d :cdo
nnoremap <A-q><C-d> :cdo
nnoremap <A-q>f :cdo
nnoremap <A-q><C-f> :cdo

" locationのshortcut
nnoremap <A-l>m :lwindow<CR>
nnoremap <A-l><C-m> :lwindow<CR>
nnoremap <A-l>j :lnext<CR>
nnoremap <A-l><C-j> :lnext<CR>
nnoremap <A-l>k :lprevious<CR>
nnoremap <A-l><C-k> :lprevious<CR>
nnoremap <A-l>gg :lfirst<CR>
nnoremap <A-l><C-g><C-g> :lfirst<CR>
nnoremap <A-l>G :llast<CR>
nnoremap <A-l><C-G> :llast<CR>
nnoremap <A-l>Tab :lnfile<CR>
nnoremap <A-l><C-Tab> :lnfile<CR>
nnoremap <A-l><S-Tab> :lpfile<CR>
nnoremap <A-l><S-C-Tab> :lpfile<CR>
nnoremap <A-l>e :lexpr 
nnoremap <A-l><C-e> :lexpr 
nnoremap <A-l>d :ldo
nnoremap <A-l><C-d> :ldo
nnoremap <A-l>f :ldo
nnoremap <A-l><C-f> :ldo

"---------------------------------------------------------------------------
"動作設定
" 開いたファイルが、無名か空の場合、挿入モードで開始
if expand("%") == ''
	startinsert
endif
autocmd BufReadPost * if line('$') == 1 && getline(1) == '' | startinsert | endif

" 保存する際、末尾にEOLを自動で加えない
"set noeol
"set nofixeol
" 仕様上、crontabを保存する際に、末尾にEOLが必要のため、設定を除外する
"if expand('%:t') != 'crontab'
"	autocmd BufRead * setlocal binary
"	autocmd BufRead * setlocal noeol
"endif

" youtube動画URLリスト化
function! ListiseURLsFromYoutube()
    v/https/d
    v/ytimg/d
    %s#^.*https://i.ytimg.com/vi/##
    %s#/hqdefault.*$##
    %s#^#https://www.youtube.com/watch?v=#
endfunction

" tver動画URLリスト化
function! ListiseURLsFromTVer()
    v/\/episodes\//d
    %s#^.*<a href="\/episodes\/##
    %s#">.*$##
    %s#^#https://tver.jp/episodes/#
endfunction

" Windowsパスでコピーしたfile path一覧の両側にある"記号を削除
function! TruncateQuoationMarks()
	s/\v^"|"$//g
endfunction