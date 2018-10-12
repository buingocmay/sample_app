class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader

  validates :content, presence: true,
    length: {maximum: Settings.max_length_post}
  validates :user, presence: true
  validate :picture_size

  scope :order_desc, ->{order created_at: :desc}

  private

  def picture_size
    return unless picture.size > Settings.size_image_mb.megabytes
    errors.add(:picture, I18n.t("max_size_file"))
  end
end
