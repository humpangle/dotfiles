" RENAME CURRENT FILE
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

" MANAGE BUFFERS
" https://tech.serhatteker.com/post/2020-06/how-to-delete-multiple-buffers-in-vim/
function! DeleteAllBuffers(f) abort
  let index = 1
  let last_b_num = bufnr("$")
  let normal_buffers = []
  let terminal_buffers = []
  let no_name_buffers = []

  while index <= last_b_num
    let b_name = bufname(index)
    if bufexists(index)
      if  (b_name == '' )
        call add(no_name_buffers, index)
      endif

      if a:f == 'a'
        if  (b_name =~ 'term://')
          call add(terminal_buffers, index)
        else
          call add(normal_buffers, index)
        endif
     endif
    endif
    let index += 1
  endwhile

  if len(no_name_buffers) > 0
    silent execute 'bwipeout! '.join(no_name_buffers)
  endif

  if len(terminal_buffers) > 0
    silent execute 'bwipeout! '.join(terminal_buffers)
  endif

  if len(normal_buffers) > 0
    silent execute 'bd ' .join(normal_buffers)
  endif
endfunction

" https://github.com/clarke/vim-renumber
function! Renumber() range
  let n=1

  " E486 Pattern not found
  for linenum in range(a:firstline, a:lastline)
    try
      " execute linenum . 's/\([\s\t])\d\+/' . n . '/'
      execute linenum . 's/^\([ 	]\+\)\?\([0-9]\+\)/\1' . n . '/'
      let n=n+1
    catch "Pattern not found"
      " Skipping lines that don't match our pattern
    endtry
  endfor
endfunction

" https://stackoverflow.com/a/2573758
function! RedirMessages(msgcmd, destcmd)
    " redir_messages.vim
    "
    " Inspired by the TabMessage function/command combo found
    " at <http://www.jukie.net/~bart/conf/vimrc>.
    "

    "
    " Captures the output generated by executing a:msgcmd, then places this
    " output in the current buffer.
    "
    " If the a:destcmd parameter is not empty, a:destcmd is executed
    " before the output is put into the buffer. This can be used to open a
    " new window, new tab, etc., before :put'ing the output into the
    " destination buffer.
    "
    " Examples:
    "
    "   " Insert the output of :registers into the current buffer.
    "   call RedirMessages('registers', '')
    "
    "   " Output :registers into the buffer of a new window.
    "   call RedirMessages('registers', 'new')
    "
    "   " Output :registers into a new vertically-split window.
    "   call RedirMessages('registers', 'vnew')
    "
    "   " Output :registers to a new tab.
    "   call RedirMessages('registers', 'tabnew')
    "
    " Commands for common cases are defined immediately after the
    " function; see below.
    "
    " Redirect messages to a variable.
    "
    redir => message

    " Execute the specified Ex command, capturing any messages
    " that it generates into the message variable.
    "
    silent execute a:msgcmd

    " Turn off redirection.
    "
    redir END

    " If a destination-generating command was specified, execute it to
    " open the destination. (This is usually something like :tabnew or
    " :new, but can be any Ex command.)
    "
    " If no command is provided, output will be placed in the current
    " buffer.
    "
    if strlen(a:destcmd) " destcmd is not an empty string
        silent execute a:destcmd
    endif

    " Place the messages in the destination buffer.
    "
    silent put=message
endfunction
" Create commands to make RedirMessages() easier to use interactively.
" Here are some examples of their use:
"
"   :BufMessage registers
"   :WinMessage ls
"   :TabMessage echo "Key mappings for Control+A:" | map <C-A>
"
command! -nargs=+ -complete=command BufMessage call RedirMessages(<q-args>, ''       )
command! -nargs=+ -complete=command WinMessage call RedirMessages(<q-args>, 'new'    )
command! -nargs=+ -complete=command TabMessage call RedirMessages(<q-args>, 'tabnew' )
command! -nargs=+ -complete=command VMessage call RedirMessages(<q-args>, 'vnew' )

" end redir_messages.vim

" https://kba49.wordpress.com/2013/03/21/clear-all-registers-and-macros-in-vim/
function! ClearRegisters()
    let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-="*+'
    let i=0
    while (i<strlen(regs))
        exec 'let @'.regs[i].'=""'
        let i=i+1
    endwhile
endfunction

command! ClearRegisters call ClearRegisters()
