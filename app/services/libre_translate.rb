require 'net/http'
require 'uri'
require 'json'

class LibreTranslate
  BASE_URL = ENV['LIBRETRANSLATE_URL'] || 'https://www.homegarden-harvest.com'

  def self.translate(text, source_lang = 'en', target_lang = 'ja')
    uri = URI("#{BASE_URL}/translate")
    response = Net::HTTP.post_form(uri, {
      'text' => text,
      'source' => source_lang,
      'target' => target_lang
    })

    response_body = response.body.force_encoding('UTF-8')

    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response_body)
      translated_text = result['translatedText']
      translated_text.force_encoding('UTF-8')
      translated_text
    else
      Rails.logger.error "Translation API error: #{response.code} - #{response_body}"
      nil
    end
  rescue JSON::ParserError => e
    Rails.logger.error "JSON parse error: #{e.message} - Response body: #{response_body}"
    nil
  rescue StandardError => e
    Rails.logger.error "Translation error: #{e.message}"
    nil
  end
end
