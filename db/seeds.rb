
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
  team.profile_fields.each do |profile_field|
    FactoryBot.create(:profile_value,:name,content:member.user.name,profile_field:,member:)
    FactoryBot.create(:profile_value,:birth,profile_field:,member:)
    FactoryBot.create(:profile_value,content:"同志社大学",profile_field:,member:)
    FactoryBot.create(:profile_value,content:"経済学部",profile_field:,member:)
    FactoryBot.create(:profile_value,content:"奈良県",profile_field:,member:)
    FactoryBot.create(:profile_value,content:"平城高校",profile_field:,member:)
    FactoryBot.create(:profile_value,content:"ウルトラソウル",profile_field:,member:)
    FactoryBot.create(:profile_value,content:"世界で活躍するエンジニア",profile_field:,member:)
    FactoryBot.create(:profile_value,content:"初めまして、#{member.user.name}です。まだまだ未熟者ですが、みなさんと一緒に成長していきたいです。よろしくお願いします。",profile_field:,member:)
  end
end

#管理者ユーザーを生成し、サンプルチームの管理者に設定
admin_user=FactoryBot.create(:user,name:"サンプルユーザー",email:"sample@sample.com",confirmed_at:Time.zone.now)
Admin.set_as_admin(admin_user,team)
