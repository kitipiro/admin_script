##
# 
module AdminScript
  module Generators
    class NewGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      argument :model_name

      ##
      # 
      def create_directory
        Pathname.new("app/models/admin_script").tap { |obj| obj.mkdir unless obj.exist? }
      end

      ##
      # 
      def copy_script
        template("../templates/script.rb","app/models/admin_script/#{model_name}.rb")
      end

      ##
      # 
      def complete_message
        say 'new templates created.', :green
      end
    end
  end
end
