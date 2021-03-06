let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
      \ 'name': 'projects',
      \ 'description': 'candidates for your projects'
      \ }

function! projects#go_to_path(path)
  if exists(':VimFilerTab')
    execute 'VimFilerTab ' . a:path 
    execute 'lcd' . a:path
  else
    execute 'tabnew'
    execute 'lcd' . a:path
  endif
endfunction

function! s:list_folders(workspaces)
  let output = globpath(join(a:workspaces, ','), '*')
  return split(output, '\n')
endfunction

function! s:open_project(path)
  return printf("call projects#go_to_path('%s')", a:path)
endfunction

function! s:unite_source.gather_candidates(args, context)
  if exists('g:unite_projects_workspaces')
    let list = s:list_folders(g:unite_projects_workspaces)
    return map(list, '{
          \ "word": v:val,
          \ "kind": "command",
          \ "action__command": s:open_project(v:val)
          \}')
  else
    echo 'The variable g:unite_projects_workspaces is not defined'
    return []
  endif
endfunction

function! unite#sources#projects#define()
  return s:unite_source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

