syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell
syn match TimestampNoSpell '\v\d{8}T\d{6}(-.{-}>)?' contains=@NoSpell
syn match LinkNoSpell '\v(\[+)[^]]+(\]+)' contains=@NoSpell
