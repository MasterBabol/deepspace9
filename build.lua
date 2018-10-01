local json = require('utils.json')
local f = assert(io.open("info.json", "rb"))
local c = f:read("*all")
f:close()
local parsed = json.parse(c)
local mname = parsed["name"]
local mver = parsed["version"]
local verb = arg[1]

if verb then
    if verb == "build" then
        if mname and mver then
            local dir = mname.."_"..mver
            print("[!] Building..")
            os.execute("mkdir "..dir)
            os.execute("cp {control,data,define,event}.lua ./"..dir.."/")
            os.execute("cp -R {info.json,controllers,graphics,locale,prototypes,utils} ./"..dir.."/")
            os.execute("zip -rq "..dir..".zip "..dir)
            print("[!] Done.")
        end
    elseif verb == "clean" then
        print("[!] Cleaning..")
        os.execute("rm -rf "..mname.."*")
        os.execute("rm -rf "..mname.."*.zip")
    end
end

