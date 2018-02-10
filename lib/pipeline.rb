class Pipeline
  def self.configure(&block)
    $pipeline = new(&block)
  end

  def initialize(&command_block)
    @command_block = command_block
    @success = true
  end

  def run(command_str)
    @success = system(command_str) if @success
  end

  def start
    instance_exec(&@command_block)

    if @success
      puts "success"
    else
      puts "failed"
    end

    @success
  end
end
