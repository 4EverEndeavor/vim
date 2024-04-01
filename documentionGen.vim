function! OpenJdkJavaP(classname)
	let l:classlist = readfile("/usr/lib/jvm/java-17-openjdk/jre/lib/classlist")
	let l:lineNum = match(l:classlist, "^.*" . a:classname)
	let l:classWithPath = l:classlist[l:lineNum]
	let l:dotClassRemoved = substitute(l:classWithPath, ".class", "", "g")
	let l:output = system("jar xf /usr/lib/jvm/java-17-openjdk/jre/lib/jrt-fs " . l:classWithPath . "; javap " . l:dotClassRemoved)
	echom l:output
endfunc
