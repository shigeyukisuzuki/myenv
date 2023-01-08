#!/usr/bin/awk -f

## 以下、AWK実践入門の関数をHack
function  fmatch(str, reg,   len)  { # 最左最短マッチング
  FSTART = match(str, reg)
  if ( RLENGTH > 0 )  {
    len = 1
    while ( match(substr(str, 1, len), reg) == 0 ) len++    
  }
  FLENGTH=RLENGTH
  return FSTART  
}

function  gmatch(str, reg,  num, len, i)  { # 連続マッチング
  for ( i in ESTART )  {
    delete ESTART[i]
    delete ELENGTH[i]
    delete EMATCH[i]
  } 
  num=0
  len=0
  while ( fmatch(str, reg) > 0 )  {
    len += FSTART           # 相対位置を絶対位置に換算
    ESTART[num] = len
    ELENGTH[num] = FLENGTH
    EMATCH[num] = substr(str, FSTART, FLENGTH)
    num++
    str = substr(str, FSTART+FLENGTH)   # 一致列までの部分を削除
    len += FLENGTH-1            # 削除した部分列の長さを加算
  }
  return  num
}
