autocmd FileType ruby nmap <Leader>ra :call RunAllSpecs()<CR>
autocmd FileType ruby nmap <Leader>rl :call RunLastSpec()<CR>
autocmd FileType ruby nmap <Leader>rs :call RunNearestSpec()<CR>
autocmd FileType ruby nmap <Leader>rt :call RunCurrentSpecFile()<CR>
"
" RSpec.vim mappings
let g:rspec_command = "VtrSendCommandToRunner! zeus rspec {spec}"
