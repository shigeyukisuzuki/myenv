"設定ファイルを有効にするにはvimのフォルダパスを環境変数$VIMに定義する。
"
"---------------------------------------------------------------------------
"エンコード設定
"fileencodings:ファイルを読み込むときに入力ファイルの取り扱い文字コード形式のリストで左側から評価される
set fileencodings=utf-16le,utf-8,cp932,guess,ucs-bom,ucs2le,ucs-2,iso-2022-jp-3,euc-jisx0213,euc-jp
"fileencoding:ファイルを出力する際に指定する文字コード形式
"encoding:読み込んだファイルを画面に表示するときの文字コード形式
"utf-8とcp932は似ているので、エラー無でエンコーディングされることがある
"ただし、fileencodingsでutf-8を先に設定すると今のところ問題なく動作cp932<utf-8?

"---------------------------------------------------------------------------
"GUI表示
" カラー設定:
"colorscheme asu1dark
" 透明度設定:
autocmd GUIEnter    * set transparency=220
autocmd FocusGained * set transparency=220
autocmd FocusLost   * set transparency=220

"---------------------------------------------------------------------------
" クリップボード設定:
source $VIMRUNTIME/mswin.vim

"---------------------------------------------------------------------------
" 自作コマンド読込み
"""source $VIM¥¥mycommand.vim
"source G:¥¥Documents¥¥tools¥¥vim81-kaoriya-win64¥¥mycommand.vim

"---------------------------------------------------------------------------
" 印刷設定
"source $VIM¥¥vimfiles¥¥macros¥¥printrc.vim

"---------------------------------------------------------------------------
"swap fileの設定
" swapfileの更新設定
" 更新文字数 default=200
set updatecount=200
"set updatecount=0
"　更新頻度ミリ秒 default=4000
set updatetime=4000
" swapfileの生成 
set swapfile
"set noswapfile
" 保存先 default :set directory=.c:¥tmp,c:¥temp
" 保存先がデフォルトではファイルの変更を許可しない場合、そのファイルのセキュリ
" ティ設定を変更し、編集可能にする必要がある。
" これはswapfileだけでなく、backupファイル、viminfoファイルにも言える。
" ファイルアドレスに空白が入るときは¥でエスケープする
"set directory=C:¥¥Program¥ Files¥¥vim74-kaoriya-win32
"set directory=G:¥¥Desktop
set directory=$VIM¥¥vimfiles¥¥swap

"---------------------------------------------------------------------------
"undo fileの設定
set undofile
set undodir=$VIM¥¥vimfiles¥¥undo

"---------------------------------------------------------------------------
"viminfoファイルの保存先
"set viminfo='100,<50,s10,h,rA:,rB:,nC:¥¥Program¥ Files¥¥vim74-kaoriya-win32¥¥viminfo
set viminfo='100,<50,s10,h,rA:,rB:,nD:¥¥

"---------------------------------------------------------------------------
" フォント設定:
if has('win32')
  " Windows用
  "set guifont=IPAGothic:h14:cSHIFTJIS
  set guifont=MS_Gothic:h14:cSHIFTJIS
  "set guifont=MS_Mincho:h12:cSHIFTJIS
  " 行間隔の設定
  set linespace=1
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('mac')
  set guifont=Osaka−等幅:h14
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  set guifontset=a14,r14,k14
endif

"---------------------------------------------------------------------------
"ウインドウに関する設定
" ウインドウの左上の位置
winpos 0 0
" ウインドウの幅
set columns=80
" ウインドウの高さ
"set lines=39
set lines=500
" コマンドラインの高さ(GUI使用時)
set cmdheight=2

"--------------------------------------------------------
" redirのshortcut
nnoremap q> :call RedirMode()<CR>
let g:redirMode=0
function! RedirMode()
	if g:redirMode == 0
		redir @"
		let g:redirMode=1
	else
		redir END
		let g:redirMode=0
	endif
endfunction

"---------------------------------------------------------------------------
"netrwの設定
"  ファイルツリーの表示形式、1にするとls -laのような表示になります
let g:netrw_liststyle=1
"  ヘッダを非表示にする
let g:netrw_banner=0
"  サイズを(K,M,G)で表示する
let g:netrw_sizestyle="H"
"  日付フォーマットを yyyy/mm/dd(曜日) hh:mm:ss で表示する
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
"  プレビューウィンドウを垂直分割で表示する
let g:netrw_preview=1
"  CVSと.で始まるファイルは表示しない
"  let g:netrw_list_hide = 'CVS,¥(^¥|¥s¥s¥)¥zs¥.¥S¥+'
"  'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
let g:netrw_altv = 1
"  'o'でファイルを開くときは下側に開く。(デフォルトが上側なので入れ替え)
let g:netrw_alto = 1

"yankringのショートカット
"if has('win32')
"	let g:yankring_replace_n_pkey = '<Char-172>'
"	let g:yankring_replace_n_nkey = '<Char-174>'
"endif

"yankroundのショートカット
"nmap p <Plug>(yankround-p)
"xmap p <Plug>(yankround-p)
"nmap P <Plug>(yankround-P)
"nmap gp <Plug>(yankround-gp)
"xmap gp <Plug>(yankround-gp)
"nmap gP <Plug>(yankround-gP)
"nmap <C-p> <Plug>(yankround-prev)
"nmap <C-n> <Plug>(yankround-next)

"---------------------------------------------------------------------------
"Align plugin設定
let g:Align_xstrlen    = 3  " for japanese string
let g:DrChipTopLvlMenu = '' " remove 'DrChip' menu
"yankring設定
let g:yankring_manual_clipboard_check = 0

"---------------------------------------------------------------------------
"  ソース編集中にそのまま、開いているファイルを実行する
function! s:Exec()
"  ローカルスコープ(s:)で式Execを定義。引数なし
    exe "!" . &ft . " %"        
:endfunction         
"  ノーマルモードでのコマンド名割り当て
command! Exec call <SID>Exec() 
"  ショートカットのキー割り当て
"  キーマップを変更。<silent>はキーを押下時にプロンプトのメッセージを表示せず。
"<C-P>を入力することが以降の文字列を順にノーマルモードで入力することを意味する。
map <silent> <C-P> :call <SID>Exec()<CR>

"  検索URL
"  coachandfour https://www.shoten.co.jp/rel/searchbook/result.asp?title=カーハッカー
"  honto https://honto.jp/netstore/search.html?detailFlg=1&seldt=2021%2Fall%2Fall%2Fbefore&srchf=1&store=1&prdNm=ブラウザハック
function! HandleURI()
  let s:uri = matchstr(getline("."), '[a-z]*:¥/¥/[^ >,;:]*')
  echo s:uri
  if s:uri != ""
    exec "!start ¥"" . s:uri . "¥""
  else
    echo "No URI found in line."
  endif
endfunction
nnoremap g# :call HandleURI()<CR>
inoremap <C-#> :call HandleURI()<CR>
map <Leader>w :call HandleURI()<CR>

function! Listise()
    "yank
    silent normal gvyy
    let text = @"
"    let list = []
"    call add(list, @")
    "let text = substitute(text, "(¥r¥n|¥r|¥n)", ", ", "g")
    let list = split(text, "(¥r¥n|¥r|¥n)")
"    let text = join(list, ",")
    echo list
endfunction
vnoremap <Leader>l :<C-u>call Listise()<CR>

"  commentise / uncommentise
nnoremap <leader>/ :s/^/"/g<CR>:nohlsearch<CR>
nnoremap <leader>? :s/^"//g<CR>:nohlsearch<CR>
vnoremap <leader>/ :s/^/"/g<CR>:nohlsearch<CR>`[V`]
vnoremap <leader>? :s/^"//g<CR>:nohlsearch<CR>`[V`]
"  <C-/>と<C-?>が機能しなかった。

"---------------------------------------------------------------------------
"  カレント位置の行番号取得
command! LineNumber :echo line(".")
"  カレント位置の桁番号取得
command! ColumnNumber :echo col(".")

"---------------------------------------------------------------------------
"  Knuth Subtractive Random Number Generator
let knuth_random = { 'index': 0, 'state': repeat([0], 56) }

function! knuth_random.seed(seed) dict
	let l:seed = 161803398 - (a:seed < 0 ? -a:seed : a:seed)
	let self.state[55] = l:seed
	let [l:i, l:j, l:k] = [0, 0, 1]
	for l:i in range(1, 54)
		let l:j = (21 * l:i) % 55
		let self.state[l:j] = l:k
		let l:k = l:seed - l:k
		if l:k < 0
			let l:k = l:k + 2147483647
		endif
		let l:seed = self.state[l:j]
	endfor
	for l:j in range(1, 4)
		for l:i in range(1, 55)
			let self.state[l:i] = self.state[l:i] - self.state[1 + (l:i + 30) % 55]
			if self.state[l:i] < 0
				let self.state[l:i] = self.state[l:i] + 2147483647
			endif
		endfor
	endfor
	let self.index = 0
endfunction

function! knuth_random.next() dict
	let self.index = self.index + 1
	if self.index >= 56
		let self.index = 1
	endif
	let l:r = self.state[self.index]
	if self.index <= 34
		let l:r = l:r - self.state[self.index + 21]
	else
		let l:r = l:r - self.state[self.index - 34]
	endif
	if l:r < 0
		let l:r = l:r + 2147483647
	endif
	return l:r
endfunction

" GUIウインドウが立ち上がるdefaultショートカットを変更
noremap <C-F> <PageDown>
noremap! <C-F> <Right>
noremap <C-H> <BS>
noremap! <C-H> <BS>

