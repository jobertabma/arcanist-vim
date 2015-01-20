if exists('g:loaded_arcanist') || &cp
  finish
endif

let g:loaded_arcanist = 1

function! s:Lint() abort
  cex system('arc lint --output compiler')

  botright copen
endfunction

function! s:Task(task_id) abort
  " Remove T from given task_id (maniphest.info requires a numeric ID)
  let id = substitute(a:task_id, "T", "", "g")

  let get_task = "echo '{\"task_id\":\"".id."\"}' | arc call-conduit maniphest.info"

  echo "Loading task..."

  " Get JSON response from Arcanist using conduit call
  let output = system(get_task)

  " Use matchstr instead of an amazing JSON parsing lib
  let status = matchstr(output, '"status":"\zs.\{-}\ze","')
  let description = matchstr(output, '"description":"\zs.\{-}\ze","')
  let title = matchstr(output, '"title":"\zs.\{-}\ze","')
  let priority = matchstr(output, '"priority":"\zs.\{-}\ze","')

  " Create a vertical split and put in a named buffer
  vsplit __Arcanist_Maniphest_Item__
  " Reset the buffer (for reuse)
  normal! ggdG
  setlocal filetype=arcanistmaniphestitem
  setlocal buftype=nofile

  " Append local variables to the buffer
  call append(0, "[".priority."/".status."] ".title."\n".description)

  " Place cursor in previously active window
  wincmd p
endfunction

command! Lint call s:Lint()
command! -nargs=1 Task call s:Task(<f-args>)
