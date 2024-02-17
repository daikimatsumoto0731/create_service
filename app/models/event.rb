class Event < ApplicationRecord
  belongs_to :vegetable
  # バリデーション
  validates :name, presence: true
  validate :end_date_after_start_date, if: -> { start_date.present? && end_date.present? }
  
  private
  
  # 終了日が開始日より後であることを確認するカスタムバリデーションメソッド
  def end_date_after_start_date
    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
  