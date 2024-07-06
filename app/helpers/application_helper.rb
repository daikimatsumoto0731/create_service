# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    base_meta_tags.merge(og_meta_tags).merge(twitter_meta_tags)
  end

  private

  def base_meta_tags
    {
      site: '無NO薬〜野菜栽培〜',
      title: '自宅で簡単に始める無農薬野菜作り',
      reverse: true,
      charset: 'utf-8',
      description: 'スケジュール管理とアドバイスで、初心者でも安心。',
      keywords: '無農薬,野菜栽培',
      canonical: 'https://www.homegarden-harvest.com/',
      separator: '|'
    }
  end

  def og_meta_tags
    {
      og: og_base_meta
    }
  end

  def og_base_meta
    {
      site_name: '無NO薬〜野菜栽培〜',
      title: '自宅で簡単に始める無農薬野菜作り',
      description: 'スケジュール管理とアドバイスで、初心者でも安心。',
      type: 'website',
      url: 'https://www.homegarden-harvest.com/',
      image: image_url('ogp.png'),
      locale: 'ja_JP'
    }
  end

  def twitter_meta_tags
    {
      twitter: twitter_base_meta
    }
  end

  def twitter_base_meta
    {
      card: 'summary_large_image',
      site: '@',
      image: image_url('ogp.png')
    }
  end
end
