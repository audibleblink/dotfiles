autocmd FileType *.cs :call OmniSharp#HighlightTypes()

" Show type information automatically when the cursor stops moving
autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

" The following commands are contextual, based on the cursor position.
autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
autocmd FileType cs nnoremap <buffer> <C-]> :OmniSharpGotoDefinition<CR>
autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

" Finds members in the current buffer
autocmd FileType cs nnoremap <buffer> <Leader>r :OmniSharpFindMembers<CR>

autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
autocmd FileType cs nnoremap <buffer> <Leader>tp :OmniSharpTypeLookup<CR>
autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>

autocmd FileType cs nnoremap <buffer> <Leader>cc :ccl<CR>

" Navigate up and down by method/property/field
autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>zz
autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>zz
autocmd FileType cs nnoremap <buffer> c* :OmniSharpRename<CR>
autocmd FileType cs nnoremap <Leader>l :OmniSharpCodeFormat<CR>:OmniSharpFixUsings<CR>
