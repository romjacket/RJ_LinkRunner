tst= what\ever\this.is
Loop,parse,tst,\
msgbox,,,%A_LoopField%
splitpath,tst,tstn
stringreplace,tst,tst,%tstn%,boogie
msgbox,,,%tst%