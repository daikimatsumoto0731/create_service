# frozen_string_literal: true

class Vegetable < ApplicationRecord
  has_many :events, dependent: :destroy

  validates :name, presence: true
  validates :sowing_date, presence: true

  # 関連するイベントの日付を更新するメソッド
  def update_related_event_dates
    events.each do |event|
      new_dates = calculate_generic_event_dates(event.name)

      event.update(start_date: new_dates[:start_date], end_date: new_dates[:end_date]) if new_dates
    end
  end

  private

  # 汎用的なイベント日付を計算
  def calculate_generic_event_dates(event_name)
    case event_name
    when '種まき'
      { start_date: sowing_date, end_date: sowing_date }
    when '発芽期間'
      { start_date: sowing_date, end_date: sowing_date + 20.days }
    when '間引き・雑草抜き・害虫駆除'
      { start_date: sowing_date + 20.days, end_date: sowing_date + 60.days }
    when '収穫期間'
      { start_date: sowing_date + 60.days, end_date: sowing_date + 100.days }
    end
  end
end
