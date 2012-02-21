" NOTE: You must have jsstyle in your path or set g:jsstyleprg.
"
" Location of jsstyle utility, change in vimrc if different
if !exists("g:jsstyleprg")
	let g:jsstyleprg="jsstyle"
endif

function! s:JSStyle(cmd, args)
    redraw
    echo "JSStyle ..."

    " If no file is provided, use current file 
    if empty(a:args)
        let l:fileargs = expand("%")
    else
        let l:fileargs = a:args
    end

    let grepprg_bak=&grepprg
    let grepformat_bak=&grepformat
    try
        let &grepprg=g:jsstyleprg
        let &grepformat="%f: %l: %m"
        silent execute a:cmd . " " . l:fileargs
    finally
        let &grepprg=grepprg_bak
        let &grepformat=grepformat_bak
    endtry

    if len(getqflist()) > 1

      " has errors display quickfix win
      botright copen

      " close quickfix
      exec "nnoremap <silent> <buffer> q :ccl<CR>"

      " open in a new window 
      exec "nnoremap <silent> <buffer> o <C-W><CR>"

      " preview
      exec "nnoremap <silent> <buffer> go <CR><C-W><C-W>"

      redraw!

    else

      " no error, sweet!
      cclose
      redraw
      echo "JSStyle: Stylin!"

    end
    

endfunction

command! -bang -nargs=* -complete=file JSStyle call s:JSStyle('grep<bang>',<q-args>)
