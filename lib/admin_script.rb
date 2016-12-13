require 'admin_script/version'

module AdminScript
  autoload :Base, 'admin_script/base'
  autoload :TypeAttributes, 'admin_script/type_attributes'
  autoload :Controller, 'admin_script/controller'
  autoload :Helper, 'admin_script/helper'

  ActiveSupport.on_load(:action_view) do
    include Helper
  end
end
