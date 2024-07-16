# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StaticPages', type: :system do
  before do
    driven_by(:rack_test)
    visit root_path
  end

  describe 'Home page' do
    it 'トップページが正常に表示されること' do
      expect(page).to have_content('〜無NO薬〜野菜栽培〜のご紹介')
      expect(page).to have_content('自宅で簡単に無農薬野菜を育てるためのサービスです。スケジュール管理とアドバイスで初心者でも安心して栽培を楽しめます')
    end
  end
end
