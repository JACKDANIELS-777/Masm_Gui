LayoutStr      db "Y,0,10,200,100,100,{b:10,f:17,}Aqaabbbbbb,\c"
                    db "Y!,0,10,100,100,100,{f:10,b:11,s:10,}Aqaabbbbbb,\c"
                   db "(ZA,1000,50,50,100,100,{f:10,b:17,}Aqaabbbbbb,\c)",0 works
                    yes

                   LayoutStr      db "Y,0,10,200,100,100,{b:10,f:17,}Aqaabbbbbb,\c"
                    db "Y!,0,10,100,100,100,{f:10,b:11,s:10,}Aqaabbbbbb,\c",  works
                    
 LayoutStr     db "Y!,0,10,100,100,100,{f:10,b:11,s:10,}Aqaabbbbbb,\c"
                   db "(ZA,1000,50,50,100,100,{f:10,b:17,}Aqaabbbbbb,\c)"
            db "Y,0,10,200,100,100,{b:10,f:17,}Aqaabbbbbb,\c"
            db "Z,100,50,50,100,100,{f:10,b:17,}10,\c",0


                    LayoutStr      db "Y,0,10,200,100,100,{b:10,f:17,}Aqaabbbbbb,\c"
                    db "Y!,0,10,100,100,100,{f:10,b:11,s:10,}Aqaabbbbbb,\c"
                   db "(ZA,1000,50,50,100,100,{f:10,b:17,}Aqaabbbbbb,\c)",0 works

                   LayoutStr      db "Y,0,10,200,100,100,{b:10,f:17,}Aqaabbbbbb,\c"
                    db "Y!,0,10,100,100,100,{f:10,b:11,s:10,}Aqaabbbbbb,\c"
                   db "(ZA,1000,50,50,100,100,{f:10,b:17,}Aqaabbbbbb,\c)"
                   db "Z,100,50,50,100,100,{f:10,b:17,}0,\c",0 works


                  
