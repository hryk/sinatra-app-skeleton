# from Ramaze

module Skel
  module CoreExt
    module Object
      unless defined?(acquire)
        def acquire(*globs)
          opt = globs.extract_options!
          if opt.key? :by 
            load_method = opt[:by]
          else
            load_method = :require
          end 
          globs.flatten.each do |glob|
            Dir[glob].each do |file|
              __send__(load_method, file) if file =~ /\.(rb|so)$/
            end 
          end 
        end 
        module_function :acquire
      end 

    end 
  end 
end

