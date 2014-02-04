let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
      \ 'name': 'projects',
      \ 'description': 'candidates for your projects'
      \ }

function! s:list_folders(workspaces)
  let output = globpath(join(a:workspaces, ','), '*')
  return split(output, '\n')
endfunction

function! s:open_project(path)
  return printf("tabnew | lcd %s | Unite -auto-resize file_rec", a:path)
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
    return []
  endif
endfunction

function! unite#sources#projects#define()
  return s:unite_source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

