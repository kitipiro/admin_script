module AdminScript
  module Controller
    extend ActiveSupport::Concern

    included do
      before_action :set_admin_script_class, only: [:show, :update, :perform]
      append_view_path(File.expand_path('../../../app/views', __FILE__))

      helper_method :admin_script_path, :admin_scripts_path
    end

    def index
      @admin_scripts = AdminScript::Base.subclasses.sort_by(&:to_s).map(&:new)
      render 'admin_scripts/index'
    end

    def show
      @admin_script = @admin_script_class.new(admin_script_params)
      render 'admin_scripts/show'
    end

    # modelで{notice: xxx}を返すと成功メッセージ、{alert: xxx}を返すとエラーメッセージを表示するように改造
    def perform
      @admin_script = @admin_script_class.new(admin_script_params)

      result = @admin_script.perform!
      notice = result.try(:fetch, :notice, nil)
      alert = result.try(:fetch, :alert, nil)
      location = @admin_script.location_url || { action: :index }

      if notice
        redirect_to location, notice: notice || t('messages.success')
      else
        flash.now[:alert] = alert || t('messages.fail')
        render 'admin_scripts/show', status: :unprocessable_entity
      end
    end
    alias_method :update, :perform

    private

    def admin_script_params
      params.require(:admin_script).permit(*@admin_script_class.type_attributes.keys)
    rescue ActionController::ParameterMissing
      nil
    end

    def set_admin_script_class
      @admin_script_class = AdminScript::Base.find_class(params[:id])
    end

    # TODO: 適当すぎるのでrouterに載せる
    def admin_script_path(id)
      param = id.try(:to_param) || id
      "/admin_scripts/#{param}"
    end

    def admin_scripts_path
      '/admin_scripts'
    end
  end
end
