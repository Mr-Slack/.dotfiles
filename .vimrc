" ファイル読み込み時の文字エンコーディングの指定
set encoding=utf-8
" Vim Script内の文字エンコーディングの指定
scriptencoding utf-8
" ファイル保存時の文字エンコーディング
set fileencoding=utf-8
" 行番号の表示
set number
" tabの幅（半角スペースn個分）
set tabstop=4
" tab入力を半角スペースへ置換
set expandtab
" 改行時に前行のインデントを継承
set autoindent
" 改行時の前行の構文チェック->インデントの調整を行う
set smartindent
" smartindentで調整時に増減する幅
set shiftwidth=4
" カーソル移動で行末->次行、行頭への移動を可能に
set whichwrap=b,s,[,],<,>
" カーソルラインのハイライト
set cursorline
" バックスペースキーの有効化
set backspace=indent,eol,start
" インクリメンタルサーチ
set incsearch
" 検索時に検索結果をハイライト
set hlsearch
" コマンドモードの補完
set wildmenu

" クリップボードペースト時のインデント調整
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif


" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" dein settings {{{
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.vim') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/.dein.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [$MYVIMRC, s:toml_file])
  call dein#load_toml(s:toml_file)
  call dein#end()
  call dein#save_state()
endif
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
" }}}

" 引数なしでvimを開くとNERDTreeを起動
let file_name = expand('%')
if has('vim_starting') &&  file_name == ''
  autocmd VimEnter * NERDTree ./
endif

set background=dark
colorscheme hybrid

syntax enable
"End dein Scripts-------------------------
