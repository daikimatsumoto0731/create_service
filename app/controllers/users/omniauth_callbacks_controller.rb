# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def line
      basic_action
    end

    private

    def basic_action
      @omniauth = request.env['omniauth.auth']
      if @omniauth.present?
        @profile = User.find_or_initialize_by(provider: @omniauth['provider'], uid: @omniauth['uid'])
        if @profile.new_record?
          email = @omniauth['info']['email'].presence || fake_email(@omniauth['uid'], @omniauth['provider'])
          username = @omniauth['info']['name'].presence || 'LINE User' # LINEからの名前をusernameに設定

          @profile.assign_attributes(
            email: email,
            username: username, # username を更新
            password: Devise.friendly_token[0, 20],
            line_user_id: @omniauth['uid'] # line_user_id を保存
          )
          
          # @profile.save! の代わりに以下の処理を行います
          if @profile.save
            @profile.refresh_access_token(@omniauth) if @profile.respond_to?(:refresh_access_token)
            sign_in(:user, @profile)

            # LINEメッセージを送信
            send_line_message(@profile)

            redirect_to user_path(current_user), notice: 'ログインしました'
          else
            # 保存に失敗した場合のエラーメッセージをログに出力
            Rails.logger.error("User save failed: " + @profile.errors.full_messages.join(", "))
            redirect_to new_user_session_path, alert: 'LINE認証に失敗しました'
          end
        else
          # 以前に作成したプロファイルがある場合の処理はそのまま
          @profile.refresh_access_token(@omniauth) if @profile.respond_to?(:refresh_access_token)
          sign_in(:user, @profile)
          redirect_to user_path(current_user), notice: 'ログインしました'
        end
      else
        redirect_to new_user_session_path, alert: 'LINE認証に失敗しました'
      end
    end

    def fake_email(uid, provider)
      "#{uid}-#{provider}-#{SecureRandom.hex(5)}@example.com"
    end

    def send_line_message(user)
      return unless user.line_user_id.present?

      message = {
        type: 'text',
        text: 'アプリへのログインありがとうございます！こちらからも最新情報などお知らせします。'
      }

      client = Rails.application.config.line_bot_client
      client.push_message(user.line_user_id, message)
    end
  end
end
