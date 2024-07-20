# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StaticPages Navigation links', type: :system do
  before do
    driven_by(:rack_test)
    visit root_path
  end

  it '会員登録リンクが正しいパスに遷移すること' do
    click_link '会員登録'
    expect(page).to have_current_path(new_user_registration_path)
  end

  it 'ログインリンクが正しいパスに遷移すること' do
    click_link 'ログイン'
    expect(page).to have_current_path(new_user_session_path)
  end

  it '利用規約リンクが正しいパスに遷移すること' do
    click_link '利用規約'
    expect(page).to have_current_path(terms_path)
  end

  it 'プライバシーポリシーリンクが正しいパスに遷移すること' do
    click_link 'プライバシーポリシー'
    expect(page).to have_current_path(privacy_policy_path)
  end

  it '使い方を見るリンクが正しいパスに遷移すること' do
    click_link '使い方を見る'
    expect(page).to have_current_path(guide_path)
  end
end
