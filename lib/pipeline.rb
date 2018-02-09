class Pipeline
  def self.configure(&block)
    $pipeline = new(&block)
  end

  def initialize(&command_block)
    @command_block = command_block
  end

  def run(command_str)
    system(command_str)
  end

  def start
   instance_exec(&@command_block)
  end
end
