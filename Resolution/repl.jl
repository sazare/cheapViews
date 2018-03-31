# sample code for the future

function help()
 println("--- help")
 println("?   :shows help")
 println("end :finish this loop")
 println("core xx=cnf : read core")
 println("show xx     : show core")
 println("ls   xx     : ls xx")
 println("--- end of help")
end


function lsfn(args, cores)
 if args == ""
  run(`ls`)
 else 
  run(`ls $args`)
 end
end

function corefn(args, cores)
  eqix=search(args,'=')
  name=strip(args[1:(eqix-1)])
  cnf=strip(args[(eqix+1):end])
  print("cnf=$cnf => $name")
  core = readcore(cnf)
  cores[name] = core
end

function showfn(args, cores)
  printcore(cores[args])
end

commandmap = Dict(
 "help"=> :help,
 "ls"  => :lsfn,
 "core"=> :corefn,
 "show"=> :showfn
)

function repl()
 print("> ")
 cores = Dict()
 for line in eachline()
 try
  if line == "end"; return
  elseif line == ""; 
  elseif line == "?"; help()
  elseif line == "help"; help()
  else
   cix = search(line, ' ')
   if cix == 0
     cmd = strip(line)
     args = ""
   else
     cmd = strip(line[1:cix])
     if cix == length(line)
       args = ""
     else
       args = strip(line[(cix+1):end])
     end
   end

   if cmd != ""
     eval(Expr(:call, commandmap[cmd], args, cores))
   end

  end
  catch e
   println(e)
  end
  print("> ")
 end
end

#==
function repl0()
 print("> ")
 vars = Dict()
 for line in eachline()
 try
  if line == "end"; return
  elseif line == "?"; help()
  elseif line == "help"; help()
  elseif line[1:2] == "ls"
   if strip(line) == "ls"
    run(`ls`)
   else 
    dir=strip(line[3:end])
    run(`ls $dir`)
   end
  elseif line[1:4] == "core"
   eqix=search(line,'=')
   cnf=strip(line[(eqix+1):end])
   name=strip(line[5:(eqix-1)])
   print("cnf=$cnf => $name")
   core = readcore(cnf)
   vars[name] = core
  elseif line[1:4] == "show"
   name=strip(line[5:end])
   printcore(vars[name])
  else
   println(line)
  end
  catch e
   println(e)
  end
  print("> ")
 end
end
==#
