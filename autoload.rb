require 'rubyvis'

autoload :Compiler, "./compiler/compiler.rb"

def camelize input
  input.to_s.split('_').collect(&:capitalize).join
end

all_modules = [:abstract_syntax_tree]

all_modules.each do |mod|
  Object.const_set(camelize(mod), Module.new)
end

Dir.glob("compiler/**/*.rb").each do |file|
  klass = file.match("/([a-z][a-z0-9_]+).rb")[1]
  klass = camelize(klass).to_sym

  modules_in_path = []

  all_modules.each do |mod|
    if file.match /#{mod}\//
      modules_in_path << camelize(mod)
    end
  end

  if modules_in_path.any? 
    scope = Object.const_get(modules_in_path.join("::"))
    scope.autoload klass, "./#{file}"
  else
    autoload klass, "./#{file}"
  end
end

BoilerplateManager.generate_simple_token_classes

