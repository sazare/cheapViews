# new Core

# clause format
# parse("[x,y].[+P(x,f(x),-Q(x,y)]")
# as readclausesfromfile()

struct CForm2
 cid
 vars
 body
end

struct VForm2
 cid
 vars
end

struct LForm2
 lid
 body
end


struct CORE
 ldb
 cdb
 clmap
 lcmap
 allpsym
 graph
end

function stringtoclause(cid, cls)
 vars = cls.args[1].args
 body = cls.args[2].args[1].args
 return CForm2(cid, vars, body)
end

function cform2ofclause(clss, initn=1)
 nclss=[]
 for cno in 1:length(clss)
  cid = cidof(cno+initn-1)
  push!(nclss, stringtoclause(cid, clss[cno]))
 end
 nclss
end

function numberingliterals(ncls, lno0, ldb, lcmap, clmap, allpsym)
 cid = ncls.cid
 lids = []
 nlno0=0
 for lno in 1:length(ncls.body)
  cls=ncls.body[lno]
  lit = ncls.body[lno]
  lno = lno+lno0-1 
  nlno0 = lno+1
  lid = lidof(lno)
  lcmap[lid] = cid
  push!(allpsym, lit.args[2].args[1])
  push!(lids, lid) 
  push!(ldb, LForm2(lid, lit))
 end
 clmap[cid] = lids

 return nlno0, ldb, lcmap, clmap, allpsym
end

function createLDB(clss)
 ldb = []
 lno = 1
 ltoc = Dict()
 ctol = Dict()
 allpsym = Set()
 for ncls in clss
  lno, ldb, ltoc, ctol, allpsym = numberingliterals(ncls, lno, ldb, ltoc, ctol, allpsym)
 end 
 return ldb, ltoc, ctol, allpsym
end

function vform2ofclause(cdb)
 map(ncl->VForm2(ncl.cid, ncl.vars) ,cdb)
end

function createcore(clss)
 cdb = cform2ofclause(clss)
 ldb, lcmap, clmap, allpsym =createLDB(cdb)
 cvdb = vform2ofclause(cdb)
 graph= []
 CORE(ldb, cvdb, clmap, lcmap, sort(collect(allpsym)), graph)
end

#core operation

getno(id) = parse(string(id)[2:end])
cidof(num::Int) = Symbol(:C, num)
lidof(num::Int) = Symbol(:L, num)
ridof(num::Int) = Symbol(:R, num)

function varsof(cid, core)
 cno = getno(cid)
 core.cdb[cno].vars
end

function bodyof(cid, core)
 clmap=core.clmap[cid]
 body = []
 for lid in core.clmap[cid]
  push!(body, core.ldb[getno(lid)].body)
 end
 body
end


function clause2of(cid, core)
 CForm2(cid, varsof(cid, core), bodyof(cid, core))
end

function lidsof(cid, core)
 core.clmap[cid]
end

function cidof(lid, core)
 core.lcmap[lid]
end

function literalof(lid, core)
 ix = find(x->x.lid==lid,core.ldb)
 !isempty(ix) && core.ldb[ix][1].body
end

function literalsof(lids, core)
 map(lid->literalof(lid), lids)
end

#### resolvent
## proof information in resolvent 

struct RForm2
 rid
 vars
 left
 right
 sigma
 body
end


### new resolution
# insufficient
function resolution(lid1, lid2, core)
# clause c1,c2 is an array.

# lid make input clause not resolvent
# is it ok? no
 vars = vcat(varsof(cidof(lid1, core), core), varsof(cidof(lid2, core), core))
 lit1 = literalof(lid1,core)
 lit2 = literalof(lid2,core)

 if lit1.args[1] == lit2.args[1]; return :NAP end 
 lit1.args[1] = lit2.args[1]  # temporarily let signs same

 try 
  sigma = unify(vars, lit1.args[2], lit2.args[2])
  r1 = vcat(setdiff(lidsof(cidof(lid1, core),core), [lid1]),
            setdiff(lidsof(cidof(lid2, core),core),[lid2]))
## ? apply vars sigma??
  return r1,vars,sigma
 catch e
  if isa(e, Loop)
   return :FAIL
  end 
 end 
 return :NAP
end
