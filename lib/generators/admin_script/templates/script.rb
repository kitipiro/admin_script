class AdminScript::<%= model_name.camelize %> < AdminScript::Base
  ##
  # todo usage & example
  self.description = <<-EOS.strip_heredoc
  EOS
  
  ##
  # todo usage & example
  self.type_attributes = {
  }
  
  ##
  # todo usage & example
  def initialize(*args)
    super *args
    end
  end

  ##
  # todo usage & example
  # @return[Hash] 
  # @option options [String] :notice
  # @option options [Integer] :alert
  def perform!
  end
end
