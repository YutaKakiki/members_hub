
User.destroy_all
Team.destroy_all


# Botユーザーを用意
30.times do
  FactoryBot.create(:user,name:Faker::Name.name,email:Faker::Internet.email,confirmed_at:Time.zone.now)
end
users=User.limit(30)

# チームを一つ用意
FactoryBot.create(:team,name:"サンプルチーム",uuid:"uuid")
team=Team.last
team.logo.attach(io:File.open("public/images/logo.png"),filename:"logo.ping")

# 30人のメンバーをチームに参加させる
users.each do |user|
  FactoryBot.create(:member,team:,user:)
end
members=Member.limit(30)
members.map do |member|
  member.image.attach(io:File.open("public/images/image.png"),filename:"image.ping")
end

# チームのプロフィール項目を設定
FactoryBot.create(:profile_field,:name,team:)
FactoryBot.create(:profile_field,:birth,team:)
FactoryBot.create(:profile_field,team:,name:"大学名")
FactoryBot.create(:profile_field,team:,name:"学部名")
FactoryBot.create(:profile_field,team:,name:"出身地")

# 30人のメンバーにプロフィールを登録させる
members.each do |member|
  team.profile_fields.each do |profile_field|
    FactoryBot.create(:profile_value,:name,content:member.user.name,profile_field:,member:)
    FactoryBot.create(:profile_value,:birth,profile_field:,member:)
    FactoryBot.create(:profile_value,content:"同志社大学",profile_field:,member:)
    FactoryBot.create(:profile_value,content:"経済学部",profile_field:,member:)
    FactoryBot.create(:profile_value,content:"奈良県",profile_field:,member:)
  end
end

#カレントユーザーを生成し、サンプルチームの管理者に設定
current_user=FactoryBot.create(:user,name:"example",email:"example@gmail.com",confirmed_at:Time.zone.now)
Admin.set_as_admin(current_user,team)
