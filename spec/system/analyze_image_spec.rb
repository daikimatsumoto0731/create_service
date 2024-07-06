# frozen_string_literal: true

require 'rails_helper'
require 'support/image_analyzer_mock'

RSpec.describe 'AnalyzeImage', type: :system do
  let(:user) { create(:user) }
  let(:vegetable) { create(:vegetable, name: 'トマト', user:) }
  let(:expected_translated_name) { 'tomato' }

  before do
    driven_by(:rack_test)
    sign_in user
    visit event_path(vegetable.id)

    # ImageAnalyzerをモックに置き換える
    stub_const("ImageAnalyzer", ImageAnalyzerMock)

    # ImageAnalyzerMock.analyze メソッドをスパイとして設定
    allow(ImageAnalyzer).to receive(:analyze).and_call_original

    # 環境に応じて期待値を変更
    allow_any_instance_of(AnalyzeImageModule).to receive(:translate_vegetable_name) do |instance, name|
      expected_translated_name = ENV['GITHUB_ACTIONS'] ? 'トマト' : 'tomato'
      expected_translated_name
    end
  end

  context 'when uploading and analyzing an image' do
    it 'uploads an image and analyzes it' do
      click_link '画像を分析する'

      fill_in '野菜名を入力', with: vegetable.name
      attach_file '画像をアップロード', Rails.root.join('spec/fixtures/files/sample_vegetable.jpg')

      expect(page).to have_button('画像を分析する', disabled: false)

      click_button '画像を分析する'

      # モックが呼び出されたことを確認
      expect(ImageAnalyzer).to have_received(:analyze).with(anything, expected_translated_name)

      # モックの戻り値が正しく使用されていることを確認
      expect(page).to have_content('画像分析結果 - トマト')
      expect(page).to have_content('野菜の状態')
      expect(page).to have_content('育て方のポイント')
    end
  end
end
