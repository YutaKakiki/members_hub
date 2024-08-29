class ProfileValue < ApplicationRecord
  belongs_to :profile_field
  belongs_to :member
  validates :content, presence: true

  def self.set_content_in_session(team, params, controller)
    content_count = team.profile_fields.count
    content_count.times do |i|
      controller.session["content#{i + 1}"] = params["content#{i + 1}"]
    end
  end

  def self.reset_content_from_session(controller)
    5.times do |i|
      controller.session["content#{i}"] = nil
    end
  end
end
