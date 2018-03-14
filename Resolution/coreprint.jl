#print

function printliteral(lit)
 print(lit)
end

function printlid(lid, core)
  print(" $lid.")
  printliteral(literalof(lid, core).body)
end

function printlids(lids, core)
 if isempty(lids)
  print("□")
 else
  for i in 1:length(lids)
    i!=1 && print(",")
#   println()
   printlid(lids[i], core)
  end
 end
end

function printbody(cls)
 if isempty(cls)
  print("□")
 else
  for i in 1:length(cls)
   println()
   print(" ")
   printliteral(cls[i])
  end
 end
end

function printvars(vars)
 print("[")
 for i in 1:length(vars)
  i != 1 && print(",")
  print(vars[i])
 end
 print("]")
end

function printclause(cid, core)
 print("$cid:")
 printvars(varsof(cid, core))

# if isempty(lidsof(cid,core)); print(".");
# else println(".") end
print(".")

 printlids(lidsof(cid,core), core)
 #printbody(cls.body)
end

function printclauses(core)
  for cid in sort(collect(keys(core.cdb)))
    printclause(cid, core)
  end
end

function printcdb(cdb) 
 if isempty(cdb)
  println("empty")
 else
  map(cid->println("$(cid): $(cdb[cid])"), keys(cdb))
 end
end

function printldb(ldb)
 if isempty(ldb)
  println("empty")
 else
  map(lid->println("$(lid): $(ldb[lid].body)"),keys(ldb))
 end
end

function printamap(amap)
 if isempty(keys(amap))
  println("empty")
 else
  map(key->println("$key=>$(amap[key])"), keys(amap))
 end
end

function printstep(step)
  print("$(step.rid):<$(step.leftp):$(step.rightp)>=")
  printvars(step.sigma)
end

function printproof(proof)
 for rid in keys(proof)
   step = proof[rid]
   printstep(step)
   println()
 end
end

function printaproof0(rid, core)
 !(rid in keys(core.proof)) && return
 step=core.proof[rid]
 printaproof0(cidof(step.leftp,core), core)
 printaproof0(cidof(step.rightp,core), core)
 println("$rid=<$(cidof(step.leftp, core)):$(cidof(step.rightp, core))>")
end

function printns(shift)
  map(x->print(" "), 1:2shift)
end

function printaproof1(rid, core, shift=0)
  if rid in keys(core.proof)
    step = core.proof[rid]
    printaproof1(cidof(step.leftp,core), core, shift+1)
    printaproof1(cidof(step.rightp,core), core, shift+1)

    println()
    printns(shift)
    print("<$(step.leftp):")
    print("$(step.rightp)>=")
    printns(shift)
    printclause(rid, core)
  else
    println()
    printns(shift)
    printclause(rid, core)
  end
end

function printcore(core)
println("max cid = $(core.maxcid)")
println("max rid = $(core.maxrid)")
println("Psyms = $(core.allpsym)")
println()
println("CDB")
 printcdb(core.cdb)
println()
println("LDB")
 printldb(core.ldb)
println()
println("LCMAP")
 printamap(core.lcmap)
println()
println("CLMAP")
 printamap(core.clmap)
println()
println("TEMPLATE(level0)")
 printtemplates0(core.level0,core)
println()
println("PROOFS")
 printproof(core.proof)
 println("\n-- end of core --")
end

#### resolvent
function printliteral(lid, core)
 println("  $lid:$(literalof(lid,core).body)")
end

#### template

function printlid0(lid, core)
  print("$(lsymof(lid, core))")
end

function printlids0(lids, core)
  for lid in lids
   printlid0(lid, core)
  end
end

function printtemplate0(key, eq, core)
  print("$key= ")
  body=eq
  for i in 1:length(body)
    i!=1 && print("*")
    printlid0(body[i][3], core)
    print("[")
    printlids0(body[i][4],core)
    print("]($(body[i][1]))")
  end
end

function printtemplates0(eqs, core)
  for key in keys(eqs)
    eq = eqs[key]
    printtemplate0(key, eq, core)
    println()
  end
end

function printtemplate1(key, eq, core)
  print("$key= ")
  body=eq
  for i in 1:length(body)
    i!=1 && println("*")
    ll=body[i]
    printlid(ll[3], core)
    print("[")
    printlids(ll[4],core)
    print("]")
    print(" ($(ll[1]))")
  end
end

function printtemplates1(eqs,core)
  for key in keys(eqs)
    eq = eqs[key]
    printtemplate1(key, eq, core)
    println()
  end
end

function printgoal(goal, core)
  for lid in goal
    printliteral(lid, core)
  end   
end

function printgoals(goals, core)
  for g in goals
    printgoal(g, core)
    println()
  end   
end

