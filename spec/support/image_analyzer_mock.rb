# frozen_string_literal: true

class ImageAnalyzerMock
  def self.analyze(image_path, vegetable_name)
    log_analysis(image_path, vegetable_name)
    analysis_result(vegetable_name)
  end

  def self.log_analysis(image_path, vegetable_name)
    Rails.logger.info("Mocked ImageAnalyzer#analyze called with image_path: #{image_path}, vegetable_name: #{vegetable_name}")
  end

  def self.analysis_result(vegetable_name)
    Rails.logger.info("Returning mock analysis result for vegetable: #{vegetable_name}")
    {
      labels: ["Plant", "Tree", "Twig", "Wood", "Terrestrial plant", "Natural landscape", "Flowering plant", "Deciduous", "Macro photography", "Grass"],
      translated_vegetable_name: "carrot"
    }
  end
end