# frozen_string_literal: true

module ApplicationHelper
  def event_description(event_name)
    descriptions = {
      '種まき' => '種まきは、植物の生命が始まる最初のステップです。',
      '発芽期間' => 'この期間は、種から新しい生命が芽吹くまでの時間です。',
      '間引き・雑草抜き・害虫駆除' => '苗が密集している場合は間引きを行い、十分な光と栄養が各植物に行き渡るようにします。',
      '収穫期間' => '植物が成熟し、収穫の準備が整いました。'
    }

    descriptions[event_name] || '特定のイベントに関する情報はありません。'
  end
end
