# loader: shared packages plus an optional per-host file (Brewfile.<hostname -s>).
# edit Brewfile.common / Brewfile.<host>, not this file. `just triage` sorts
# untracked installs into them.
dir = File.dirname(__FILE__)
instance_eval File.read("#{dir}/Brewfile.common"), "#{dir}/Brewfile.common"
host = `hostname -s`.strip
host_file = "#{dir}/Brewfile.#{host}"
instance_eval File.read(host_file), host_file if File.exist?(host_file)
