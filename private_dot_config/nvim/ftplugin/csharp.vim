autocmd FileType *.cs :call OmniSharp#HighlightTypes()

" Show type information automatically when the cursor stops moving
autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

" The following commands are contextual, based on the cursor position.
nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
nnoremap <buffer> <C-]> :OmniSharpGotoDefinition<CR>
nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

" Finds members in the current buffer
nnoremap <buffer> <Leader>r :OmniSharpFindMembers<CR>

nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
nnoremap <buffer> <Leader>tp :OmniSharpTypeLookup<CR>
nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>

nnoremap <buffer> <Leader>cc :ccl<CR>

" Navigate up and down by method/property/field
nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>zz
nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>zz
nnoremap <buffer> c* :OmniSharpRename<CR>
nnoremap <Leader>l :OmniSharpCodeFormat<CR>:OmniSharpFixUsings<CR>
