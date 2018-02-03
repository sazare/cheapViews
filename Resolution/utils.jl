# sort clause

# for equalclause, they should be sorted.

function renamevarinlit(vars, lit)
 for v in vars
  lit = replace(lit, string(v), "*")
 end
 return lit
end

function gelit(var1,L1,var2,L2)
 sl1 = renamevarinlit(var1,string(L1))
 sl2 = renamevarinlit(var2,string(L2))
 return(sl1<=sl2)
end

#### sort make a list but need Expr ...
function sortcls(cls::CForm)
vars=cls[1]
 nargs=sort(cls[2].args, lt=(x,y)->gelit(vars,x,vars,y))
 cls[2].args=nargs
 cls
end
