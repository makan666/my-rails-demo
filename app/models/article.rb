# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  title      :string
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Article < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5 }
  has_many :comments, dependent: :destroy
end
