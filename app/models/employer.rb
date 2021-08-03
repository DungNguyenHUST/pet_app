class Employer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  extend FriendlyId
  def convert_slug
    slug = name.downcase.to_s
    slug.gsub! /[àáạãảâậấẫầẩăặắằẵẳ]/, "a"
    slug.gsub! /[đ]/, "d"
    slug.gsub! /[èéẹẽẻêềếệễể]/, "e"
    slug.gsub! /[óòọõỏôốồộỗổơớợỡờở]/, "o"
    slug.gsub! /[úùụũủưứựừữử]/, "u"
    slug.gsub! /[íịìĩỉ]/, "i"
    slug.gsub! /[ýỵỹỳỷ]/, "y"
    return slug
  end
  friendly_id :convert_slug, use: :slugged

  mount_uploader :avatar, ImageUploader
  
  def self.approved
    where(approved: :true)
  end
end
