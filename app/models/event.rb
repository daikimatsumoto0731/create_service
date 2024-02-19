class Event < ApplicationRecord
  belongs_to :vegetable
  # バリデーション
  validates :name, presence: true
  validate :end_date_after_start_date, if: -> { start_date.present? && end_date.present? }

  # イベントの期間（日数）を計算するメソッド
  def duration_in_days
    # start_date と end_date の両方が存在する場合のみ計算を行う
    if start_date && end_date
      (end_date - start_date).to_i
    end
  end
  
  private
  
  # 終了日が開始日より後であることを確認するカスタムバリデーションメソッド
  def end_date_after_start_date
    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
  