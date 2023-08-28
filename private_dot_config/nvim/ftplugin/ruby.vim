nmap <Leader>ra :call RunAllSpecs()<CR>
nmap <Leader>rl :call RunLastSpec()<CR>
nmap <Leader>rs :call RunNearestSpec()<CR>
nmap <Leader>rt :call RunCurrentSpecFile()<CR>
"
" RSpec.vim mappings
let g:rspec_command = "VtrSendCommandToRunner! zeus rspec {spec}"
