"---------------------------------------------------------------------------
colorscheme industry

"---------------------------------------------------------------------------
" タブを表示するときの幅
set tabstop=4
" タブを挿入するときの幅
set shiftwidth=4
" タブをタブとして扱う(スペースに展開しない)
set noexpandtab
" 
set softtabstop=0

"---------------------------------------------------------------------------
"  zxcv配列の代替キー インクリメント、デクリメントのショートカット
nnoremap <A-a> <C-a>
nnoremap <A-S> <C-s>
nnoremap <A-z> <C-z>
nnoremap <A-x> <C-x>
nnoremap <A-c> <C-c>
nnoremap <A-v> <C-v>

"  bashキーバインドの再現
inoremap <C-h> <BS>
inoremap <C-k> <C-o>d$
"inoremap <C-u> <C-o>d0
inoremap <C-s> <ESC>/
inoremap <C-r> <ESC>?
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
cnoremap <C-h> <BS>
cnoremap <C-d> <DEL>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-y> <C-o>p

"---------------------------------------------------------------------------
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

