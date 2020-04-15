" Description: List the open buffers.

let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:padding(origin, target_width) abort
  let width = strdisplaywidth(a:origin)
  if width < a:target_width
    return a:origin.repeat(' ', a:target_width - width)
  else
    return a:origin
  endif
endfunction

function! s:format_buffer(b) abort
  let name = bufname(a:b)
  let name = empty(name) ? '[No Name]' : fnamemodify(name, ':p:~:.')
  let flag = a:b == bufnr('')  ? '%' : (a:b == bufnr('#') ? '#' : ' ')
  let modified = getbufvar(a:b, '&modified') ? ' [+]' : ''
  let readonly = getbufvar(a:b, '&modifiable') ? '' : ' [RO]'

  let extra = join(filter([modified, readonly], '!empty(v:val)'), '')

  return trim(printf('%s %s %s', name, flag, extra))
endfunction

function! s:buffers() abort
  let l:buffers = execute('buffers')
  let s:line_info = {}
  for line in split(l:buffers, "\n")
    let bufnr = str2nr(trim(matchstr(line, '^\s*\d\+')))
    let lnum = matchstr(line, '\s\+\zsline.*$')
    let s:line_info[bufnr] = lnum
  endfor
  let bufs = map(clap#util#buflisted_sorted(), 's:format_buffer(str2nr(v:val))')
  if empty(bufs)
    return []
  else
    return bufs[1:] + [bufs[0]]
  endif
endfunction

function! s:extract_bufnr(line) abort
  return matchstr(a:line, '^\[\zs\d\+\ze\]')
endfunction

function! s:buffers_sink(selected) abort
  call g:clap.start.goto_win()
  let b = s:extract_bufnr(a:selected)
  if has_key(g:clap, 'open_action')
    execute g:clap.open_action
  endif
  execute 'buffer' b
endfunction

function! s:buffers_on_move() abort
  let curline = g:clap.display.getcurline()
  if empty(curline)
    return
  endif
  let bufnr = str2nr(s:extract_bufnr(curline))
  if !has_key(s:line_info, bufnr)
    return
  endif
  let lnum = str2nr(matchstr(s:line_info[bufnr], '\d\+'))
  let [start, end, hi_lnum] = clap#preview#get_line_range(lnum, 5)
  let lines = getbufline(bufnr, start+1, end+1)
  call insert(lines, bufname(bufnr))
  call g:clap.preview.show(lines)
  call g:clap.preview.setbufvar('&syntax', getbufvar(bufnr, '&syntax'))
  call clap#preview#highlight_header()
endfunction

let s:buffers = {}
let s:buffers.sink = function('s:buffers_sink')
let s:buffers.source = function('s:buffers')
let s:buffers.on_move = function('s:buffers_on_move')
let s:buffers.syntax = 'clap_buffers'
let s:buffers.support_open_action = v:true

let g:clap#provider#buffers# = s:buffers

let &cpoptions = s:save_cpo
unlet s:save_cpo
