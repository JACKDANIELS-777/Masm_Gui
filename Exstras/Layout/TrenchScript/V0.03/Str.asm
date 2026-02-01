SecondScript:
        db "Cls     "
        db "WarpS   "
        dq -1
align 8
    
    TrenchScriptStr:
        db "QueueP  "
        dq SecondScript
        db "2       "
        dq -1 
