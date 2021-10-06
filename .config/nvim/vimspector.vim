fun! GotoWindow(id)
    call win_gotoid(a:id)
endfun

" When debugging, continue. Otherwise start debugging.
" <F5>
nmap <C-Y> :call vimspector#Launch()<CR>

" Close the debugger
nmap <leader>dR :VimspectorReset<CR>

" Stop debugging.
" <F3>
nmap <leader>ds <Plug>VimspectorStop

" Pause debuggee.
" <F6>
nmap <leader>dp <Plug>VimspectorPause

" Restart debugging with the same configuration.
" <F4>
nmap <leader>dr <Plug>VimspectorRestart

nmap <leader>de :VimspectorEval
nmap <leader>dw :VimspectorWatch

" nmap <C-U> :VimspectorShowOutput

" Toggle line breakpoint on the current line.
" <F9>
nmap <leader>db <Plug>VimspectorToggleBreakpoint

" Toggle conditional line breakpoint on the current line.
" <leader>F9
nmap <leader>dc <Plug>VimspectorToggleConditionalBreakpoint

" Step Into
nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dh <Plug>VimspectorStepOut
nmap <leader>dk <Plug>VimspectorStepOver
nmap <leader>dj <Plug>VimspectorStepOver

nmap <leader>di <Plug>VimspectorBalloonEval
xmap <leader>di <Plug>VimspectorBalloonEval

" up/down the stack
nmap ,dk <Plug>VimspectorUpFrame
nmap ,dj <Plug>VimspectorDownFrame

nnoremap ,dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap ,dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap ,dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap ,dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap ,ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap ,do :call GotoWindow(g:vimspector_session_windows.output)<CR>

" `:VimspectorInstall` to install
" `:VimspectorToggleLog` to see location of VIMSPECTOR_HOME and gadgetDir.
let g:vimspector_install_gadgets = [
  \'debugpy',
  \'vscode-go',
  \'CodeLLDB',
  \'vscode-node-debug2',
  \'vscode-php-debug',
  \'debugger-for-chrome',
\]
