" --------------------------------------------------------------
"　初期設定
" --------------------------------------------------------------

" vi互換モードオフ
set nocompatible


" --------------------------------------------------------------
"　基本設定
" --------------------------------------------------------------

" vim デフォルトをcommandモードに設定
set noinsertmode

" エンコーディング設定
set encoding=utf-8 " Vim内部のエンコーディング
set termencoding=utf-8 " 出力エンコーディング
set fileencoding=utf-8 " バッファ保存時のエンコーディング
set fileencodings=utf-8,euc-jp,sjis,iso-2022-jp " ファイルを開く際のエンコーディング

" 行番号の表示
set number

" ベースインデント設定
set expandtab " tab入力を半角スペースへ置換
set tabstop=4 " tabの幅（半角スペースn個分）
set autoindent " 改行時に前行のインデントを継承
set smartindent " 改行時の前行の構文チェック->インデントの調整を行う
set shiftwidth=4 " smartindentで調整時に増減する幅

" バックアップファイル/スワップファイルの非作成設定
set nobackup
set noswapfile

" インクリメンタルサーチの有効化
set incsearch

" 検索時に検索結果をハイライト
set hlsearch

" カーソルラインをハイライト
set cursorline

" カーソル移動で行末->次行、行頭への移動を可能に
set whichwrap=b,s,[,],<,>

" バックスペースキーの有効設定
set backspace=indent,eol,start

" コマンドモードの補完有効化
set wildmenu

" ビープ音の消去
set vb t_vb=

" ステータスライン設定
set statusline=%F " ファイル名表示
set statusline+=%m " 変更チェック表示
set statusline+=%= " 以降は右寄せ表示
set statusline+=[ENC=%{&fileencoding}] " ファイルエンコーディングの表示
set statusline+=[LOW=%l/%L] " 現在行数/全行数の表示
set laststatus=2 " ステータスラインを常に表示

" --------------------------------------------------------------
" キーマップ
" --------------------------------------------------------------
" ESC ESC 検索時ハイライト無効化
nnoremap <ESC><ESC> :nohlsearch<CR>"
" Ctrl + e でNERDTree
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" php辞書ファイルの読み込み
autocmd FileType php,ctp :set dictionary=~/.vim/dict/php.dict

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

"=================================
" Jqコマンドの追加(JSON Viewer用)
"=================================
command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! jq \"" . l:arg . "\""
endfunction

"===========================
" GitGutter
"===========================
let g:gitgutter_max_signs = 500 "差分表示の最大数
let g:gitgutter_highlight_lines = 1 "GitGutter起動時に差分行のハイライト有効化
let g:gitgutter_enabled = 0 "vim起動時は無効化


"===========================
" NERDTree
"===========================

" ブックマークの初期表示設定
let g:NERDTreeShowBookmarks=1

" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1

" 引数なしでvimを開くとNERDTreeを起動
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('md',     'blue',    'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml',    'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('config', 'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('conf',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('json',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('html',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('css',    'cyan',    'none', 'cyan',    '#151515')
call NERDTreeHighlightFile('js',     'Red',     'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php',    'Magenta', 'none', '#ff00ff', '#151515')

"===========================
" tagbar
"===========================
let g:tagbar_left = 0
let g:tagbar_autofocus = 1

"===========================
" neocomplcache
"===========================
let g:neocomplcache_enable_at_startup = 1 " 起動時に有効化

" Markdownシンタックスハイライト設定
let g:markdown_faced_languages = [
\ 'css',
\ 'javascript',
\ 'js=javascript',
\ 'json=javascript',
\ 'xml',
\ ]

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

syntax enable

" カラーテーマ
colorscheme apprentice

" vim-airline用設定
set laststatus=2
" タブバーのカスタマイズを有効にする
let g:airline#extensions#tabline#enabled = 1
" タブバーの右領域を非表示にする
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#show_close_button = 0

"End dein Scripts-------------------------
