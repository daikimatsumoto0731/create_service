class Event < ApplicationRecord
  belongs_to :vegetable
  # バリデーション
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  # カスタムバリデーションメソッド :end_date_after_start_date を使用して終了日が開始日より後であることを確認
  validate :end_date_after_start_date

  private

  # 終了日が開始日より後であることを確認するカスタムバリデーションメソッド
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
