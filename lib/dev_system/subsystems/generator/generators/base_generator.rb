class DevSystem::BaseGenerator < DevSystem::Generator

  section :panel

  def self.call(env)
    super
    
    generator = env[:generator] = new
    generator.call env
  end

  #

  attr_reader :env

  def call(env)
    @env = env
    
    method_name = "call_#{env[:generator_action]}"
    return public_send method_name if respond_to? method_name

    log "method not found: #{method_name.inspect}"

    raise NoMethodError, "method not found: #{method_name.inspect}", caller 
  end

  def inform
    log "not implemented"
  end

  def save
    log "not implemented"
  end

  section :command

  def args
    env[:args]
  end

  def command
    env[:command]
  end

  #

  def self.get_generator_signatures
    signatures = []
    ancestors_until(BaseGenerator).each do |c|
      signatures +=
        c.instance_methods_defined.select do |name|
          name.start_with? "call_"
        end.map do |name|
          OpenStruct.new({
            name: ( name.to_s.sub("call_", "").sub("default", "") ),
            description: "# no description",
          })
        end
    end
    signatures
  end

end
