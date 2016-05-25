class Recipe < ActiveRecord::Base
  belongs_to :chef
  has_many   :likes

  validates :chef_id,     presence: true
  validates :name,        presence: true, length: { minimum: 5,  maximum: 100 }
  validates :summary,     presence: true, length: { minimum: 10, maximum: 150 }
  validates :description, presence: true, length: { minimum: 20, maximum: 500 }

  mount_uploader :picture, PictureUploader
    # To impliment ordering by number of likes, will have to
    # add a column to the recipes table, and increment every time
    # the like button is pressed, then update this method to order
    # by that column
  default_scope -> { order(updated_at: :desc) }

  validate :picture_size
  def thumbs_up_total
      self.likes.where(like: true).size
  end

  def thumbs_down_total
      self.likes.where(like: false).size
  end

  private

    def picture_size
        if picture.size > 5.megabytes
            errors.add(:picture, "should be less than 5MB")
        end
    end


end
