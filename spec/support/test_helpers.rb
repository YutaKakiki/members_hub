module TestHelpers
  def set_up_all_data(team)
     # チームのプロフィール項目を作成
     name_field = create(:profile_field, :name, team:)
     birth_field = create(:profile_field, :birth, team:)
     7.times do |i|
       create(:profile_field,name:"項目#{i+1}" ,team:)
     end
     custom_profile_fields = ProfileField.limit(3).offset(2)
     # 30人分のメンバーを用意
     30.times do
       create(:user, :multiple)
     end
     users = User.limit(30)
     users.map do |user|
       create(:member, user:, team:)
     end
     # 30人のメンバープロフィールを登録
     members = Member.limit(30)
     members.map do |member|
       create(:profile_value, :name, member:, profile_field: name_field)
       create(:profile_value, :birth, member:, profile_field: birth_field)
       custom_profile_fields.map do |custom_profile_field|
         # 内容には、「内容１」など、フィルタリング検索がうまくいくように区別する
         create(:profile_value,content:"内容#{member.id}" ,member:, profile_field: custom_profile_field)
       end
     end
  end

  def clean_up_all_data
    User.destroy_all
    ProfileField.destroy_all
    Member.destroy_all
    ProfileValue.destroy_all
  end
end
