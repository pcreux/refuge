class Member < ActiveRecord::Base

  belongs_to :user
  belongs_to :location
  belongs_to :status
  has_many :profiles
  has_many :networks, :through=>:profiles

  validates_presence_of :first_name

  image_accessor :avatar

  before_create :set_birthday_to_now
  before_update :compose_birthday

  normalize_attributes :website, :organisation, :prestations, :references, :city, :hobbies, :powers
  normalize_attribute :phone, :with=>:phone

  def self.can_edit?(current_user, current_id)
    (current_user.role == 'admin' || current_id == current_user.id)? true : false
  end

  def age
    now = Time.now.year - self.birthday.year
  end

  def http_website
    "http://#{self.website}"
  end

  # Searchable DB fields
  def self.fields
    fields = ['first_name', 'last_name', 'prestations', 'powers', 'organisation']

    out = Hash.new
    fields.each{|f|out.update(f => f)}

    return out
  end

private

  # Compose SQL date from day and month
  def compose_birthday
    self.birthday['day'] = 1 if (self.birthday['day'].strip.blank? || self.birthday['day'].to_i == 0)
    self.birthday = "#{self.birthday['year']}-#{self.birthday['month']}-#{self.birthday['day']}"
  end

  # Force birthday to now on create
  def set_birthday_to_now
    self.birthday = Time.now
  end


end

