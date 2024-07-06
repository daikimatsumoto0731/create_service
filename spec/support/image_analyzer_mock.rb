# frozen_string_literal: true

class ImageAnalyzerMock
  def self.analyze(image_path, vegetable_name)
    log_analysis(image_path, vegetable_name)
    analysis_result(vegetable_name)
  end

  def self.log_analysis(image_path, vegetable_name)
    Rails.logger.info(
      "Mocked ImageAnalyzer#analyze called with image_path: #{image_path}, vegetable_name: #{vegetable_name}"
    )
  end

  def self.analysis_result(vegetable_name)
    {
      status: 'success',
      result: {
        vegetable: vegetable_name,
        status: '良好',
        tips: '水やりを適度に行ってください。'
      }
    }
  end
end
