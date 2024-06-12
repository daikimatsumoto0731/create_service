# frozen_string_literal: true

class TranslateController < ApplicationController
  def translate
    text = params[:text]
    service = params[:service] || 'deepl'
    translated_text = translate_text(text, service)
    render json: { translatedText: translated_text }
  end

  private

  def translate_text(text, service)
    Rails.logger.info "Starting translation for: #{text} using #{service}"
    translated_text =
      case service
      when 'azure'
        AzureTranslationService.translate(text)
      else
        TranslationService.translate(text)
      end
    Rails.logger.info "Translation result: #{translated_text}"
    translated_text
  rescue StandardError => e
    Rails.logger.error "Failed to translate vegetable name: #{e.message}"
    text # 翻訳に失敗した場合は元の名前を使用
  end
end
