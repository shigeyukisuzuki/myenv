#!/usr/bin/awk -f

BEGIN {
    if (!pass) {
        "read -sp \"-password:\" pass; echo ${pass}" | getline pass
		print "\n........................."
    }

    if (mode == "enc") {
        action="openssl aes-256-cbc -e -nosalt -base64 -pass pass:"pass
    } else {
        action="openssl aes-256-cbc -d -nosalt -base64 -pass pass:"pass
    }

}


NR==1 && mode=="enc" { # 1行目は全角文字をできる範囲で取り除く
    # sstiとtr処理は合わせること
    #tr="echo '" $0 "' | tr 'Ａ-Ｚａ-ｚ０-９' 'A-Za-z0-9'"
    tr="echo '" $0 "' | sed 'y;ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ０１２３４５６７８９/;ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.;'"
    # 特殊文字は対応しない
    tr | getline
    close(tr)
}


/~~.*~~/{ # ~~to be converted~~ を見つけたら (最左最短) matchingにto be convertedを入れる
    line=$0
    nm = gmatch(line, "~~.*~~")
    pos=1
    n=0
    while (n<nm) {
        if (pos==ESTART[n]) { # match
            target = substr(EMATCH[n], 3, ELENGTH[n] - 4)
            act="echo " "\""target"\" | " action " 2> /dev/null"
            act | getline converted
            close(act)
            printf "~~%s~~", converted
            pos+=ELENGTH[n]
            n++
        } else {    # matchしていないところの処理
            printf "%s", substr(line,pos,ESTART[n]-pos) # マッチしていない所、マッチするまで
            pos=ESTART[n]  # n < nm ならこれでよい
        }
    }
    if (pos < length) {
        printf "%s", substr(line, pos)
    }
    printf "\n"
}

!/~~.*~~/{ #暗号化不要の行は、そのまま出力
    print
}


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
