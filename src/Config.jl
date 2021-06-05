module Config

using JSON

const configfile_name = "config.json"

function loadconfig()
    configfile_contents = ""
    open(configfile_name, "r") do io
        configfile_contents = read(io, String)
    end;
    configfile_json = JSON.parse(configfile_contents)

    return configfile_json
end

end # module
