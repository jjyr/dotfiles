set nocompatible              " be iMproved, required
filetype off                  " required
set autoread
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" YouCompeleteMe
Plugin 'Valloric/YouCompleteMe'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" FZF
set rtp+=/usr/local/opt/fzf
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" Rust
Plugin 'rust-lang/rust.vim'
Plugin 'vim-syntastic/syntastic'

" vim wiki
Plugin 'vimwiki/vimwiki'

" Define FZF Commands
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)


" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
Bundle 'vim-ruby/vim-ruby'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

filetype on
syntax on
filetype plugin indent on

" enable rust ctags support
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
" autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi

" Ctrl-P
" set runtimepath^=~/.vim/bundle/ctrlp.vim
" let g:ctrlp_working_path_mode = 0


" key bindings
map <C-P> :Files<CR>
map <C-S> :Find<CR>

" colorscheme

hi SpellCap     cterm=underline ctermbg=white ctermfg=red
hi SpellBad     cterm=underline ctermbg=red ctermfg=white

" Setup syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers=['flake8', 'mypy']
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
nnoremap <C-x>x :SyntasticCheck<CR>

" Complete closing
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()

inoremap '      ''<Left>
inoremap '<CR>  '<CR>'<Esc>O
inoremap ''     ''

inoremap "      ""<Left>
inoremap "<CR>  "<CR>"<Esc>O
inoremap ""     ""

" Past
function Paste()
  let content = system("powershell.exe -NoLogo -NoProfile -NonInteractive -Command Get-Clipboard | sed 's/\r$//'")
  set paste
  execute 'normal! i' . content . "\<ESC>"
  set nopaste
endfunction

nnoremap <C-x>p :call Paste()<CR>

" Copy to windows
function Get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return lines
endfunction

function CopyToWindows()
  let content = Get_visual_selection()
  if join(content) != ""
    call writefile(content, '/tmp/clipboard')
    silent execute "!" . 'clip.exe < /tmp/clipboard'
  endif
endfunction

noremap <silent> <F2> :<C-U>:call CopyToWindows()<CR>

set et
set sw=2
set nu
set bs=2
set conceallevel=0
set guifont=Monaco:h13
set visualbell t_vb=

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

colorscheme desert

let &t_SI = "\<esc>[5 q"  " blinking I-beam in insert mode
let &t_SR = "\<esc>[3 q"  " blinking underline in replace mode
let &t_EI = "\<esc>[ q"  " default cursor (usually blinking block) otherwise

