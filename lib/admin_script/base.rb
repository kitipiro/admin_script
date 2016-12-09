require 'active_support/core_ext/class/subclasses'
require 'active_model'
# TODO: Rails5は標準。Rails4は別gem
require 'method_source'

module AdminScript
  class Base
    include AdminScript::TypeAttributes
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    extend ActiveModel::Callbacks

    define_model_callbacks :initialize, only: :after

    attr_accessor :location_url

    class << self
      def inherited(subclass)
        super

        subclass.class_exec do
          cattr_accessor :description
        end
      end

      def type_attributes
        @type_attributes ||= {}
      end

      def type_attributes=(attrs_with_types)
        attr_accessor(*attrs_with_types.keys)

        attrs_with_types.each do |name, type|
          type_attribute(name, type)
        end

        type_attributes.merge!(attrs_with_types)
      end

      def id
        model_name.element
      end

      def find_class(id)
        subclasses.find { |klass| klass.id == id }
      end

      def script
        # TODO: klass.instance_method(:hoge).source はファイルを変更しても毎回同じのため、
        #       再起動しないと画面上のメソッドソースは変更されない(実際には変更されているため処理上は問題ない)
        instance_method(:perform!).source
      end
    end

    def initialize(*)
      run_callbacks :initialize do
        super
      end
    end

    def id
      self.class.id
    end
    alias to_param id

    def perform!
      raise NotImplementedError, 'not implemented'
    end

    # TODO: これを入れておかないとform_forで渡した時にpatchにならない
    def persisted?
      true
    end

    private

    def url_helpers
      Rails.application.routes.url_helpers
    end
  end
end
