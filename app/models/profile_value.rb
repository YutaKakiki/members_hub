class ProfileValue < ApplicationRecord
  belongs_to :profile_field
  belongs_to :member
  validates :content,presence: true

  #TODO: contentは、空で保存させないようにしたい

  # profile_field(厳密にはid)とcontentのペア配列を作る
  # ペア配列を回して、ProfileValuesに二つの値を入れるため
  def self.create_field_and_content_pairs_arr(params,team)
    # profile_fieldの配列を用意
    profile_field_ids=team.profile_field_ids
    profile_field_size=profile_field_ids.size
    contents=[]
    # contentの配列を用意
    profile_field_size.times do |i|
      contents.push(params["content_#{i+1}"])
    end
    # ex// [[2,"Example Name"],[4,"Example University"]]
    field_and_content_pairs_arr=profile_field_ids.zip(contents)
  end

  def self.set_content_in_session(team,params,controller)
    content_count=team.profile_fields.count
    content_count.times do |i|
      controller.session["content_#{i+1}"] = params["content_#{i+1}"]
    end
  end

  def self.reset_content_from_session(controller)
    5.times do |i|
      controller.session["content_#{i}"]=nil
    end
  end


end
