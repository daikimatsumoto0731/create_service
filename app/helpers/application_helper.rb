# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    {
      site: '無NO薬〜野菜栽培〜',
      title: '自宅で簡単に始める無農薬野菜作り',
      reverse: true,
      charset: 'utf-8',
      description: 'スケジュール管理とアドバイスで、初心者でも安心。',
      keywords: '無農薬,野菜栽培',
      canonical: 'https://www.homegarden-harvest.com/',
      separator: '|',
      og: {
        site_name: '無NO薬〜野菜栽培〜',
        title: '自宅で簡単に始める無農薬野菜作り',
        description: 'スケジュール管理とアドバイスで、初心者でも安心。',
        type: 'website',
        url: 'https://www.homegarden-harvest.com/',
        image: image_url('ogp.png'), 
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@', 
        image: image_url('ogp.png')
      }
    }
  end
end
