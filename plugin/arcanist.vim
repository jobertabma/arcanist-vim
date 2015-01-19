if exists('g:loaded_arcanist') || &cp
  finish
endif

let g:loaded_arcanist = 1

function! s:Lint() abort
  cex system('arc lint --output compiler')

  botright copen
endfunction

command! Lint call s:Lint()
