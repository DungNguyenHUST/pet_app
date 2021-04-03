# frozen_string_literal: true

class Ckeditor::Asset < ActiveRecord::Base
  Rails.application.config.assets.precompile += %w[ckeditor/config.js]
  
  include Ckeditor::Orm::ActiveRecord::AssetBase

  delegate :url, :current_path, :content_type, to: :data

  validates :data, presence: true
end
