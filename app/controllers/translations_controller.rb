class TranslationsController < ApplicationController
  protect_from_forgery with: :null_session
  
  def create
    text = params[:text]
    source_lang = params[:source] || 'en'
    target_lang = params[:target] || 'ja'
  
    translated_text = LibreTranslate.translate(text, source_lang, target_lang)
      
    if translated_text
      render json: { translatedText: translated_text }, status: :ok
    else
      render json: { error: 'Translation failed' }, status: :unprocessable_entity
    end
  end
end
  