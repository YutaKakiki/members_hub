
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
FactoryBot.create(:profile_field,team:,name:"高校名")
FactoryBot.create(:profile_field,team:,name:"好きな曲")
FactoryBot.create(:profile_field,team:,name:"あなたの夢")
FactoryBot.create(:profile_field,team:,name:"コメント")

# 30人のメンバーにプロフィールを登録させる
members.each do |member|
  FactoryBot.create(:profile_value, :name, content: member.user.name, profile_field_id: 1, member: member)
  FactoryBot.create(:profile_value, :birth, content: Faker::Date.birthday(min_age: 18, max_age: 65), profile_field_id: 2, member: member)
  FactoryBot.create(:profile_value, content: Faker::University.name, profile_field_id: 3, member: member)
  FactoryBot.create(:profile_value, content: Faker::Educator.degree, profile_field_id: 4, member: member)
  FactoryBot.create(:profile_value, content: Faker::Address.state, profile_field_id: 5, member: member)
  FactoryBot.create(:profile_value, content: Faker::Educator.secondary_school, profile_field_id: 6, member: member)
  FactoryBot.create(:profile_value, content: Faker::Music::RockBand.song, profile_field_id: 7, member: member)
  FactoryBot.create(:profile_value, content: Faker::Job.title, profile_field_id: 8, member: member)
  FactoryBot.create(:profile_value, content: "初めまして、#{member.user.name}です。#{Faker::Lorem.sentence}", profile_field_id: 9, member: member)
end

#管理者ユーザーを生成し、サンプルチームの管理者に設定
admin_user=FactoryBot.create(:user,name:"サンプルユーザー",email:"sample@sample.com",confirmed_at:Time.zone.now)
Admin.set_as_admin(admin_user,team)
