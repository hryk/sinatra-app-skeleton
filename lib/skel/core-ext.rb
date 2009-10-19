# from Ramaze.

dir  = File.join(File.expand_path(File.dirname(__FILE__)), 'core-ext')
glob = File.join(dir, '**', '*.rb')

Dir[glob].each do |snippet|
  require snippet
end

Skel::CoreExt.constants.each do |const|
  ext = Skel::CoreExt.const_get(const)
  into = Module.const_get(const)

  collisions = ext.instance_methods & into.instance_methods

  if collisions.empty?
    into.__send__(:include, ext)
  else
    warn "Won't include %p with %p, %p exists" % [into, ext, collisions]
  end

end 

