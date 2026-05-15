" vim: sw=1 sts=2 tw=0

let s:mac = has('mac')
let s:win = has('win32')

function! myspacevim#after() abort
  unmap ,
  let g:mapleader = ','

" map , [SPC]

 " Options {
 set ignorecase
 set smartcase
 set cpoptions-=<
 set wildcharm=<C-Z>
 set nobackup
 set incsearch
 set expandtab
 set tabstop=2
 set shiftwidth=2
 set softtabstop=2
 set ruler
 set laststatus=2
 set hidden
 set visualbell
 set noerrorbells
 set number
 set wildmenu
 set colorcolumn=80
 set conceallevel=1
 set linebreak
 set confirm
 set title
 set hlsearch
 set autochdir
 "set background=dark
 set cursorline
 set cursorcolumn
 set autoindent
 set splitright
 set wrap
 set modeline
 "set wmnu=list:longest
 set rulerformat=%l,%c%V%=%P
 set encoding=UTF-8
 set foldmethod=syntax
 set history=1000
 set scrolloff=2
 set backspace=indent,eol,start
 set list
 "set listchars=tab:>-,trail:.,eol:$
 set listchars=tab:.\ ,trail:.,extends:#,nbsp:.
 set viminfo='20,<50,s10,h,%
 set guioptions+=2
 set shortmess=atI
 set clipboard=unnamed
 syntax on
 " Save Backups and Swap Files in ~/.vim-tmp
 set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
 set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
 setlocal spell spelllang=en_us
 set nospell
 set nowrap
 setlocal omnifunc=syntaxcomplete#Complete

 " wildignores
 set wildignore+=.DS_Store,.git,.hg,.svn
 set wildignore+=*~,#*#,*.swp,*.tmp
 set wildignore+=*.a,*.o
 set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.tiff
 set wildignore+=*.avi,*.wmv,*.mp4,*.mkv,*.mov,*.asf,*.ogv,*.ogg
 set wildignore+=*.wav,*.mp3,*.oga,*.ogg,*.flac,*.m4a,*.acc
 " VCS systems
 if s:win
  set wildignore+=*\\.git\\*,*\\.hg\\*,*\\.svn\\*  " Windows ('noshellslash')
 else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
 endif

 " Highlight terminal cursor in Terminal buffer
 if has('nvim')
  highlight! link TermCursor Cursor
  highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
 endif

 let g:limelight_conceal_ctermfg=1
 let g:rainbow_active = 1
 let g:indent_guides_enable_on_vim_startup = 1
 let g:yankring_history_file = '.yankring_history'
 let g:yankring_history_dir = '$HOME/.vim'
 " Options }

 " Filetypes Options {

 " Goto last remembered position
 if has('autocmd')
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$')
     \| exe "normal! g'\"" | endif
 endif

 " Follow symlinks when opening a file
 function! MyFollowSymlink(...)
  let fname = a:0 ? a:1 : expand('%')
  if getftype(fname) != 'link'
   return
  endif
  let resolvedfile = fnameescape(resolve(fname))
  exec 'file ' . resolvedfile
 endfunction
 command! FollowSymlink call MyFollowSymlink()
 autocmd BufReadPost * call MyFollowSymlink(expand('<afile>'))

 " Load templates of filetype from .vim/templates
 autocmd BufNewFile * silent! Or $HOME/.vim/templates/%e.template

 " Goto the first position of git committing buffer
 autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

 " Change indentation and tabs=4 for xml like markup languages.
 augroup filetype_html
  autocmd FileType html :set nowrap tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType xhtml :set nowrap tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType xml :set nowrap tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType xslt :set nowrap tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType docbk :set nowrap tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType python :set nowrap tabstop=4 shiftwidth=4 softtabstop=4
 augroup END

 augroup source_python
  au BufNewFile,BufRead *.py :set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix foldmethod=indent
  au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
 augroup END

 " Open qss (Qt StyleSheet) files as CSS
 au BufRead,BufNewFile *.qss set filetype=css

 " Open docx files
 function! s:open_docx()
  let g:docx = system("unzip -p ~/h.docx word/document.xml | sed -e 's/<[^>]\{2,\}>//g; s/[^[:print:]]\{1,\}//g'")
 endfunction
 autocmd BufReadPre *.docx call s:open_docx()
 call s:open_docx()

 " Spell Checking files
 augroup filetype_spell
  autocmd FileType tex, markdown, html, xhtml, xml, xslt, docbk, docbkxml, docbksgml, pod, gitcommit :set spell
 augroup END

 augroup filetype_omnifunc
  autocmd FileType ada setlocal omnifunc=adacomplete#Complete
  autocmd FileType c setlocal omnifunc=ccomplete#Complete
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
 augroup END

 let g:javascript_plugin_jsdoc = 1
 let g:javascript_plugin_ngdoc = 1
 let g:javascript_plugin_flow = 1
 let g:javascript_conceal_function             = 'ƒ'
 let g:javascript_conceal_null                 = 'ø'
 let g:javascript_conceal_this                 = '@'
 let g:javascript_conceal_return               = '⇚'
 let g:javascript_conceal_undefined            = '¿'
 let g:javascript_conceal_NaN                  = 'ℕ'
 let g:javascript_conceal_prototype            = '¶'
 let g:javascript_conceal_static               = '•'
 let g:javascript_conceal_super                = 'Ω'
 let g:javascript_conceal_arrow_function       = '⇒'
 let g:javascript_conceal_noarg_arrow_function = '🞅'
 let g:javascript_conceal_underscore_arrow_function = '🞅'
 augroup javascript_folding
  au!
  au FileType javascript setlocal foldmethod=syntax
 augroup END

 autocmd FileType c,cpp,python,perl,vim,javascript,html,xml,xhtml,markdown,tex Limelight
 autocmd! User GoyoEnter Limelight
 autocmd! User GoyoLeave Limelight!
 " augroup pencil
  " autocmd!
  " autocmd FileType markdown,mkd call pencil#init()
  " autocmd FileType text         call pencil#init()
 " augroup END

 autocmd FileType javascript,css,perl,c,cpp,objcpp nnoremap <silent> ; :call cosco#commaOrSemiColon()<CR>
 autocmd FileType javascript,css,perl,c,cpp,objcpp inoremap <silent> <leader>; <c-o>:call cosco#commaOrSemiColon()<CR>
 " Filetypes Options }

 " Mappings {
 " Camel Case Motion
 " FIXME it causes greedy behavior on editing objects commands
 " let g:camelcasemotion_key = '<leader>'
 " map <silent> w <Plug>CamelCaseMotion_w
 " map <silent> b <Plug>CamelCaseMotion_b
 " map <silent> e <Plug>CamelCaseMotion_e
 " map <silent> ge <Plug>CamelCaseMotion_ge
 " sunmap w
 " sunmap b
 " sunmap e
 " sunmap ge
 " omap <silent> iw <Plug>CamelCaseMotion_iw
 " xmap <silent> iw <Plug>CamelCaseMotion_iw
 " omap <silent> ib <Plug>CamelCaseMotion_ib
 " xmap <silent> ib <Plug>CamelCaseMotion_ib
 " omap <silent> ie <Plug>CamelCaseMotion_ie
 " xmap <silent> ie <Plug>CamelCaseMotion_ie
 " imap <silent> <S-Left> <C-o><Plug>CamelCaseMotion_b
 " imap <silent> <S-Right> <C-o><Plug>CamelCaseMotion_w

 nnoremap <silent> <leader>a :set arabic!<cr>

 " Press F5 in in insert mode to insert the current datestamp
 "nnoremap <F5> "=strftime("%Y-%m-%d %H:%M:%S")<CR>P
 inoremap <F5> <C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>
 inoremap <S-F5> <time><C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR></time>

 " Wrapping lines is disabled by default, can be toggled with F8
 nnoremap <F8> :set wrap!<CR>
 inoremap <F8> <ESC>:set wrap!<CR>a
 nnoremap <leader>w :set wrap!<CR>
 "
 " Console Menus
 " noremap <F10> :emenu <C-Z>

 " Directions Mapping (from auto.vim plugin)
 noremap<Up>   gk
 noremap<Down> gj
 no!<M-k> <Up>
 no!<M-j> <Down>
 no!<M-h> <Left>
 no!<M-l> <Right>
 nnoremap <C-e> 5<C-e>
 nnoremap <C-y> 5<C-y>

 " Remapping up, down, first and last keys to move in the displayed wrapped
 " lines not the physicals lines
 noremap  <buffer> <silent> k gk
 noremap  <buffer> <silent> <UP> gk
 noremap  <buffer> <silent> j gj
 noremap  <buffer> <silent> <DOWN> gj
 noremap  <buffer> <silent> 0 g0
 noremap  <buffer> <silent> ^ g^
 noremap  <buffer> <silent> $ g$

 " Windows moving made easy
 nnoremap <M-h> <c-w>h
 nnoremap <M-j> <c-w>j
 nnoremap <M-k> <c-w>k
 nnoremap <M-l> <c-w>l
 if has('nvim')
  tnoremap <M-h> <c-\><c-n><c-w>h
  tnoremap <M-j> <c-\><c-n><c-w>j
  tnoremap <M-k> <c-\><c-n><c-w>k
  tnoremap <M-l> <c-\><c-n><c-w>l
 endif

 " Map s to work as S with Surrounding
 xnoremap s <Plug>VSurround

 " TODO Map <C-u> to undo in insert mode
 "nnoremap <C-0> :set wrap!<CR>

 " Paste in insert-mode
 " If r=1 then use the * register (system wide clipboard)
 function! PasteInNormal(r)
  let l:paste_current_status = &paste
  set paste
  if a:0 > 0 && r == 1
   normal "*p
  else
   normal ""p
  endif
  let &paste = l:paste_current_status
 endfunction
 inoremap <C-v> <C-o>:call PasteInNormal()<CR>
 " FIXME change this to <S-Insert> TODO: <S-Insert> paste the + register
 inoremap <C-S-v> <C-o>:call PasteInNormal(1)<CR>

 " Permanent "very magic" mode
 nnoremap / /\v
 vnoremap / /\v
 cnoremap %s/ %smagic/
 cnoremap \>s/ \>smagic/
 nnoremap :g/ :g/\v
 nnoremap :g// :g//

 " Spell Checking & Mapping F7 to Toggle Slepp Checking & ,z for suggestions
 noremap <F7> :set spell!<CR>
 inoremap <F7> <ESC>:set spell!<CR>a

 " Map <leader>/ to hide the search highlights.
 nnoremap <leader>/ :nohlsearch<CR>

 " Go to last visited buffer
 nnoremap <leader><tab> :b#<CR>
 nnoremap <leader># :b#<CR>

 " Paste in a new line after or befor the current line
 nnoremap <leader>p :[line]pu[t]<CR>
 nnoremap <leader>P :[line]pu[t]!<CR>

 " Open cheatsheet
 nnoremap <leader>cs :e ~/.cheat/vim.org<CR>

 if has('nvim')
  tnoremap <ESC> <C-\><C-n>
  tnoremap <C-v><ESC> <ESC>
 endif

 " nnoremap <leader>G :GundoToggle<CR>
 noremap <F9> :VimFiler<CR>
 noremap <leader>N :VimFiler<CR>
 noremap <F10> :TagbarToggle<CR>
 noremap <leader>T :TagbarToggle<CR>
 "noremap <S-C-F10> :TlistToggle<CR>:TlistAddFilesRecursive . *.{cpp, c, C, h, hpp, cc, cxx}<CR>
 nnoremap <Leader>l :Limelight!!<CR>
 nnoremap <Leader>G :Goyo<CR>
 " TODO: Map <C-S-F7> To toggle between :LangToolCheck and :LangToolClear.
 "nnoremap <C-S-F7> :LanguageToolCheck<CR>

 " Format code
 nnoremap <silent> <leader>= :Neoformat<CR>

 map <leader>c :exec &conceallevel ? "set conceallevel=0" : "set conceallevel=1"<CR>
 " Mapping }

 " Abbreviates {
 iabbrev (C) ©
 iabbrev (R) ®
 iabbrev TM ™
 iabbrev SM ℠
 iabbrev <3 ❤
 " Abbreviates }

endfunction
