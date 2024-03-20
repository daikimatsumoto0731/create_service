class UpdateVegetableNames < ActiveRecord::Migration[7.0]
  def up
    # 野菜の名前を英語に更新
    Vegetable.find_by(name: 'トマト')&.update(name: 'Tomato')
    Vegetable.find_by(name: 'バジル')&.update(name: 'Basil')
    Vegetable.find_by(name: 'にんじん')&.update(name: 'Carrot')
  end

  def down
    # 英語の名前から日本語の名前に戻す（ロールバックの場合）
    Vegetable.find_by(name: 'Tomato')&.update(name: 'トマト')
    Vegetable.find_by(name: 'Basil')&.update(name: 'バジル')
    Vegetable.find_by(name: 'Carrot')&.update(name: 'にんじん')
  end
end
