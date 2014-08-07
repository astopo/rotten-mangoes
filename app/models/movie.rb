class Movie < ActiveRecord::Base
  has_many :reviews

  validates :title,
  presence: true

  validates :director,
  presence: true

  validates :runtime_in_minutes,
  numericality: { only_integer: true }

  validates :description,
  presence: true

  validates :poster_image_url,
  presence: true

  validates :release_date,
  presence: true

  validate :release_date_is_in_the_future

  mount_uploader :poster, PosterUploader

  scope :director?, ->(director) { where("director LIKE ?", "%#{director}%") }
  scope :title?, ->(title) { where("title LIKE ?", "%#{title}%") }
  scope :runtime?, ->(time) { 
    if time == "< 90"
      runtime = where("runtime_in_minutes < ?", 90)
    elsif time == "90to120"
      runtime = where("runtime_in_minutes >= ?", 90).where("runtime_in_minutes <= ?", 120)
    else time == ">120"
      runtime = where("runtime_in_minutes > ?", 120)
    end
    runtime
  }

  def review_average
    reviews.sum(:rating_out_of_ten)/reviews.size if reviews.size > 0
  end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end 
end
