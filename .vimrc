set nocompatible                " Make Vim behave in a more useful way

filetype plugin on              " Enable plugins
filetype indent on              " Load indent files

"let mapleader=";"               " Set <Leader> key

"===== TERMINAL ================================================================
set ttyfast                     " Fast terminal connection (smooth redrawing)
set lazyredraw                  " Redraw only when we need to.

"===== MOUSE ===================================================================
" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
    set mouse=a
endif

"===== CLIPBOARD ===============================================================

" Use the desktop clipboard as default register
"set clipboard=unnamed

" Emulate Ctrl+C, Ctrl+X and Ctrl+V
":vnoremap <C-c> "+y
":vnoremap <C-x> "+d
":inoremap <C-v> <ESC>"+pa

" Yank to the end of the line (consistent with C and D)
nnoremap Y y$

"===== COLORS ==================================================================
set t_Co=256                    " Use 256 colors
colorscheme default             " Color scheme
set background=dark             " Background color brightness
syntax on                       " Syntax highlighting

"===== MESSAGES AND INFO =======================================================
set novisualbell                " Disable visual bell
set number                      " Show the line number in front of each line
set ruler                       " Show the line and column number of the cursor

"===== DISPLAYING TEXT =========================================================
set list                        " Show invisible characters
set lcs=tab:>.,trail:.          " ...but only tabs and trailing whitespace
"set scrolloff=5                 " Show a few lines of context around cursor

"===== EDITING TEXT ============================================================
set backspace=indent,eol,start  " Make backspace key work the way it should
set complete=.,w,b,u,t          " Disable deep scanning of included files (-i)
set infercase                   " Adjust completions to match case
set pastetoggle=<Leader>p       " Toggle paste mode
set showmatch                   " Highlight matching brackets
set matchtime=3
hi MatchParen ctermfg=NONE ctermbg=black cterm=bold

if has('persistent_undo')
    set undodir=$HOME/.vim-undo,$HOME/tmp,/tmp,.    " Location for undo files
    set undofile                                    " Enable undofile
endif

" Don't use Ex mode
map Q <Nop>

"===== TABS AND INDENTING ======================================================
set tabstop=4                   " Tab indentation levels every four columns
set shiftwidth=4                " Indent/outdent by four columns
set smarttab                    " Use shiftwidths at left margin
set shiftround                  " Always indent/outdent to nearest tabstop
set expandtab                   " Convert all tabs that are typed into spaces

set autoindent                  " Retain indentation on next line
set smartindent                 " Increase/decrease indentation automatically

" Make tab in v mode ident code
vmap <tab> >gv
vmap <s-tab> <gv

" Make tab in normal mode ident code
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>

" Format plain text with <Leader>f
vmap <silent> <Leader>f :!fmt -w 78<CR>
nmap <silent> <Leader>f :.!fmt -w 78<CR><Down>

"===== READING AND WRITING FILES ===============================================
set autoread                    " Reload buffer when external changes detected
set autowrite                   " Save buffer when changing files
set noswapfile                  " Don't create swap files

set fileformats=unix,mac,dos    " Handle Mac and DOS line-endings
                                " (but prefer Unix)

set nomodeline                  " Disable modelines

augroup VimReload
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

augroup FiletypeInference
    autocmd!
    autocmd BufNewFile,BufRead  *.t      setfiletype perl
    autocmd BufNewFile,BufRead  *.pod    setfiletype pod
augroup END

" Improve file browser (netrw)
let g:netrw_sort_by        = 'time'
let g:netrw_sort_direction = 'reverse'
let g:netrw_banner         = 0
let g:netrw_liststyle      = 3
let g:netrw_browse_split   = 3
let g:netrw_fastbrowse     = 1
let g:netrw_sort_by        = 'name'
let g:netrw_sort_direction = 'normal'

"===== COMMAND LINE EDITING ====================================================
set history=200                 " keep 200 lines of command line history
set showcmd                     " display incomplete commands
set wildmenu                    " Improved command-line completion
set wildmode=full               " Complete the next full match

"===== SEARCHING ===============================================================
set incsearch                   " Search as characters are entered
set hlsearch                    " Highlight all matches

"set ignorecase                  " Ignore case in all searches...
"set smartcase                   " ...unless uppercase letters used

" Clear current search highlighting with <C-L>
nnoremap <silent> <C-L> :noh<CR>

highlight clear Search
highlight       Search    ctermfg=White  ctermbg=Black   cterm=bold
highlight    IncSearch    ctermfg=Yellow ctermbg=DarkRed cterm=bold

" Search using Perl-compatible regexps
"nnoremap / /\v
"vnoremap / /\v

" Extend a previous match
nnoremap <Leader>m /<C-R>/

" I'm tired of typing :%s/.../.../gc
nnoremap <Leader>s :%s//gc<LEFT><LEFT><LEFT>
xnoremap <Leader>s :s//gc<LEFT><LEFT><LEFT>

set laststatus=2        " Always display the status line
set equalalways         " Make all windows the same size when adding/removing
set splitbelow          " Put the new window below
set splitright          " Put the new window right

"===== MULTIPLE TAB PAGES ======================================================

"" t commands
"nnoremap t<Right> :tabnext<CR>
"nnoremap t<Left>  :tabprev<CR>
"nnoremap t<Up>    :tabfirst<CR>
"nnoremap t<Down>  :tablast<CR>
"nnoremap t<BS>    :tabclose<CR>

"" Alternate between this and the last accessed tab
"let g:lasttab = 1
"nnoremap <silent> tt :exe "tabn ".g:lasttab<CR>
"au TabLeave * let g:lasttab = tabpagenr()

"" Ctrl-Shift commands
"nnoremap <C-S-Right> :tabnext<CR>
"nnoremap <C-S-Left>  :tabprev<CR>
"nnoremap <C-S-Up>    :tabfirst<CR>
"nnoremap <C-S-Down>  :tablast<CR>
"nnoremap <C-S-t>     :tabnew<CR>
"nnoremap <C-S-w>     :tabclose<CR>

"===== PERL SUPPORT ============================================================

function! PerlSetup()
    function! SilentMakeAndOpenQuickFixWindow()
        silent make
        if len(getqflist()) > 0
            copen
        endif
        redraw!
    endfunction

    function! RunPerlCheck()
        compiler perl
        call SilentMakeAndOpenQuickFixWindow()
    endfunction

    function! RunPerlCritic()
        setlocal makeprg=perlcritic\ -verbose\ 1\ --quiet\ %
        setlocal errorformat=%f:%l:%c:%m
        call SilentMakeAndOpenQuickFixWindow()
    endfunction

    " Check syntax with   <Leader>c (lowercase c)
    nnoremap <Leader>c :call RunPerlCheck()<CR>

    " Run perlcritic with <Leader>C (uppercase C)
    nnoremap <Leader>C :call RunPerlCritic()<CR>

    " Execute perl file
    nmap <Leader>e :!clear && perl %<CR>

    " Execute perl file (in debugger)
    nmap <Leader>d :!clear && perl -d %<CR>

    " Tidy selected lines (or entire file) with <Leader>t
    nnoremap <silent> <Leader>t :%!perltidy -q<CR>
    vnoremap <silent> <Leader>t :!perltidy -q<CR>

    " Tidy --converge (2 times slower!) with <Leader>T (uppercase T)
    nnoremap <silent> <Leader>T :%!perltidy --converge -q<CR>
    vnoremap <silent> <Leader>T :!perltidy --converge -q<CR>

    " Adjust keyword characters to match Perlish identifiers...
    "set iskeyword+=$
    "set iskeyword+=%
    "set iskeyword+=@-@
    set iskeyword+=:
    set iskeyword-=,

    " Program to use for the K command
    set keywordprg=perldoc

    " my perl includes pod
    let perl_include_pod = 1

    " syntax color complex things like @{${"foo"}}
    let perl_extended_vars = 1

    " Syntax highlighting for some common Perl tools and frameworks
    " that extend the Perl syntax

    let s:src = getline(1,100)

    " Carp
    if match( s:src, '^\s*use Carp' ) >= 0
        syntax match perlStatementProc "\<\%(croak\|confess\|carp\|cluck\)\>"
    endif

    " Dancer
    if match( s:src, '^\s*use \(Bookings::\)\?Dancer2' ) >= 0
        syntax match perlStatementProc '\<\%(after\|any\|before\|before_template\|cookies\|cookie\|config\|content_type\|dance\|dancer_version\|debug\|dirname\|engine\|error\|false\|forward\|from_dumper\|from_json\|from_yaml\|from_xml\|get\|halt\|headers\|header\|push_header\|hook\|info\|layout\|logger\|load\|load_app\|mime\|params\|param\|pass\|patch\|path\|post\|prefix\|del\|options\|put\|redirect\|render_with_layout\|request\|send_error\|send_file\|set\|setting\|set_cookie\|session\|splat\|start\|status\|template\|to_dumper\|to_json\|to_yaml\|to_xml\|true\|upload\|uri_for\|captures\|var\|vars\|warning\)\>'
    endif

    " Moose
    if match( s:src, '^\s*use Moose' ) >= 0
        syntax match perlStatementProc '\<\%(has\|traits\|inner\|is\|super\|requires\|with\|subtype\|coerce\|as\|from\|via\|message\|enum\|class_type\|role_type\|maybe_type\|duck_type\|optimize_as\|type\|where\|extends\|isa\|required\|default\|does\|trigger\|lazy\|weak_ref\|auto_deref\|lazy_build\|builder\|documentation\|clearer\|predicate\|reader\|writer\|accessor\|init_arg\|initializer\|handles\)\>'
        syntax match perlFunction      '\<\%(before\|after\|around\|override\|augment\)\>'
    endif

    " Bookings :: Behavior
    if match( s:src, '^\s*use Bookings::Behavior' ) >= 0
        syntax match perlStatementProc "\<\%(platforms\|condition\|on_variant\|on_all_variants\|on_all\|stash\|code\|setup\|teardown\|et_name\)\>"
    endif

    " Calango
    if match( s:src, '^\s*use Calango::Page' ) >= 0
        syntax match perlStatementProc "\<\%(prop\|record\|action\|route\)\>"
    endif

    if match( s:src, '\v^\s*use (experimental|feature) [''"]signatures[''"]' ) >= 0
        syn match perlSignature +(\_[^)]*)\_s*+ nextgroup=perlSubAttributes,perlComment contained
    endif

    " Highlight extra characters in long lines
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    match OverLength /\%121v.\+/

endfunction

autocmd FileType perl call PerlSetup()
