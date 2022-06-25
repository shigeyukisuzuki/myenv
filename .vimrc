"---------------------------------------------------------------------------
" タブを表示するときの幅
set tabstop=4
" タブを挿入するときの幅
set shiftwidth=4
" タブをタブとして扱う(スペースに展開しない)
set noexpandtab
" 
set softtabstop=0

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
inoremap <C-n> <Down>
inoremap <C-p> <Up>
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

