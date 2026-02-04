str1 db "/v1beta/models/gemma-3-4b-it:generateContent?key=Api_Key_Here",0
str2 db '{ "contents": [{ "parts":[{ "text": "Tell me the history of masm in short" }] }] }', 0
align 8
    
    TrenchScriptStr:
        db "CallGenP"
        dq str1
        dq str2
        db "82      " ; len of str 2
        dq -1
