nmap <buffer> <leader>mI <Plug>(JavaComplete-Imports-AddMissing)
nmap <buffer> <leader>mi <Plug>(JavaComplete-Imports-AddSmart)
nmap <buffer> <leader>mii <Plug>(JavaComplete-Imports-Add)


nmap <buffer> <leader>mM <Plug>(JavaComplete-Generate-AbstractMethods)


nmap <buffer> <leader>mA <Plug>(JavaComplete-Generate-Accessors)
nmap <buffer> <leader>ms <Plug>(JavaComplete-Generate-AccessorSetter)
nmap <buffer> <leader>mg <Plug>(JavaComplete-Generate-AccessorGetter)
nmap <buffer> <leader>ma <Plug>(JavaComplete-Generate-AccessorSetterGetter)
nmap <buffer> <leader>mts <Plug>(JavaComplete-Generate-ToString)
nmap <buffer> <leader>meq <Plug>(JavaComplete-Generate-EqualsAndHashCode)
nmap <buffer> <leader>mc <Plug>(JavaComplete-Generate-Constructor)
nmap <buffer> <leader>mcc <Plug>(JavaComplete-Generate-DefaultConstructor)

vmap <buffer> <leader>ms <Plug>(JavaComplete-Generate-AccessorSetter)
vmap <buffer> <leader>mg <Plug>(JavaComplete-Generate-AccessorGetter)
vmap <buffer> <leader>ma <Plug>(JavaComplete-Generate-AccessorSetterGetter)

nmap <buffer> <silent> <leader>mn <Plug>(JavaComplete-Generate-NewClass)
nmap <buffer> <silent> <leader>mN <Plug>(JavaComplete-Generate-ClassInFile)
