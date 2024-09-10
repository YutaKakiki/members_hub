class ProfileValue < ApplicationRecord
  belongs_to :profile_field
  belongs_to :member
  validates :content, presence: true

  def self.valid_content?(member)
    # 全てが正常な値（presence）かどうか
    true if member.profile_values.all?(&:valid?)
  end

  # profile_valueをそれぞれ更新
  # params:{profile_values=>{23=>{content:"〇〇"},{21=>{〇〇},,,,}}}
  def self.update_profile_values(params)
    params[:profile_values].each do |id,value|
      unless value[:content].blank?
        profile_value = self.find_by(id:)
        profile_value.update(content: value[:content])
      end
    end
  end

  def self.create_unfilled_profile(params,member)
    params[:unfilled_profile_values]&.each do |params|
      member.profile_values.build(profile_field_id: params[:profile_field_id], content: params[:content])
      member.save_profile_values
    end
  end


end
