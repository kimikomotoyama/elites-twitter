class Tweet < ActiveRecord::Base
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 140 }
  
  scope :with_keywords, -> keywords {
    if keywords.present?
      columns = [:content]
      where(keywords.split(/[[:space:]]/).reject(&:empty?).map {|keyword|
        columns.map { |a| arel_table[a].matches("%#{keyword}%") }.inject(:or)
      }.inject(:and))
    end
  }
end
