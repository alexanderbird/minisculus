autoload :Compiler, "./compiler.rb"

Dir.glob("compiler/**/*.rb").each do |file|
  klass = file.match("/([a-z][a-z0-9_]+).rb")[1]
  klass = klass.split('_').collect(&:capitalize).join

  autoload klass.to_sym, "./#{file}"
end
