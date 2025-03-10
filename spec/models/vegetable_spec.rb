# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vegetable, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:vegetable)).to be_valid
  end

  context 'validations' do
    it 'is not valid without a name' do
      vegetable = build(:vegetable, name: nil)
      vegetable.valid?
      expect(vegetable.errors[:name]).not_to be_empty
    end

    it 'is not valid with a name shorter than 2 characters' do
      vegetable = build(:vegetable, name: 'a')
      vegetable.valid?
      expect(vegetable.errors[:name]).not_to be_empty
    end

    it 'is not valid with a name longer than 50 characters' do
      vegetable = build(:vegetable, name: 'a' * 51)
      vegetable.valid?
      expect(vegetable.errors[:name]).not_to be_empty
    end

    it 'is not valid without a sowing_date' do
      vegetable = build(:vegetable, sowing_date: nil)
      vegetable.valid?
      expect(vegetable.errors[:sowing_date]).not_to be_empty
    end
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:events).dependent(:destroy) }
  end
end
