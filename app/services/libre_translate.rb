require 'net/http'
require 'uri'
require 'json'

class LibreTranslate
  BASE_URL = ENV['LIBRETRANSLATE_URL'] || 'https://vegetable-services.herokuapp.com'

  def self.translate(text, source_lang = 'en', target_lang = 'ja')
    uri = URI("#{BASE_URL}/translate")
    response = Net::HTTP.post_form(uri, {
      'q' => text,
      'source' => source_lang,
      'target' => target_lang,
      'format' => 'text'
    })

    response.body.force_encoding('UTF-8') # レスポンスのエンコーディングをUTF-8に設定
    result = JSON.parse(response.body)
    translated_text = result['translatedText']
    translated_text.force_encoding('UTF-8') # エンコーディングを明示的に設定
    translated_text
  rescue StandardError => e
    puts "Translation error: #{e.message}"
    nil
  end
end
