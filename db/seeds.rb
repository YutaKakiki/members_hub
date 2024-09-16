
User.destroy_all
Team.destroy_all

# 開発環境＆テスト環境
if !Rails.env.production?
  # Botユーザーを用意
  30.times do
    User.create!(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      confirmed_at: Time.zone.now,
    )
  end
  users=User.limit(30)

  # チームを一つ用意
  FactoryBot.create(:team,name:"サンプルチーム",uuid:SecureRandom.uuid)
  team=Team.last
  team.logo.attach(io:File.open("public/images/logo.png"),filename:"logo.ping")

  # 30人のメンバーをチームに参加させる
  users.each do |user|
    FactoryBot.create(:member,team:,user:)
  end
  members=Member.limit(30)
  members.map do |member|
    member.image.attach(io:File.open("public/images/image.png"),filename:"image.png")
  end

  # チームのプロフィール項目を設定
   profile_field1= FactoryBot.create(:profile_field,:name,team:)
   profile_field2= FactoryBot.create(:profile_field,:birth,team:)
   profile_field3= FactoryBot.create(:profile_field,team:,name:"大学名")
   profile_field4= FactoryBot.create(:profile_field,team:,name:"学部名")
   profile_field5= FactoryBot.create(:profile_field,team:,name:"出身地")
   profile_field6= FactoryBot.create(:profile_field,team:,name:"高校名")
   profile_field7= FactoryBot.create(:profile_field,team:,name:"好きな曲")
   profile_field8= FactoryBot.create(:profile_field,team:,name:"あなたの夢")
   profile_field9= FactoryBot.create(:profile_field,team:,name:"コメント")

  # 30人のメンバーにプロフィールを登録させる
  members.each do |member|
    FactoryBot.create(:profile_value, :name, content: member.user.name, profile_field:profile_field1, member: member)
    FactoryBot.create(:profile_value, :birth, content: Faker::Date.birthday(min_age: 18, max_age: 65), profile_field: profile_field2, member: member)
    FactoryBot.create(:profile_value, content: Faker::University.name, profile_field: profile_field3, member: member)
    FactoryBot.create(:profile_value, content: Faker::Educator.degree, profile_field:profile_field4, member: member)
    FactoryBot.create(:profile_value, content: Faker::Address.state, profile_field:profile_field5, member: member)
    FactoryBot.create(:profile_value, content: Faker::Educator.secondary_school, profile_field:profile_field6, member: member)
    FactoryBot.create(:profile_value, content: Faker::Music::RockBand.song, profile_field:profile_field7, member: member)
    FactoryBot.create(:profile_value, content: Faker::Job.title, profile_field:profile_field8, member: member)
    FactoryBot.create(:profile_value, content: "初めまして、#{member.user.name}です。#{Faker::Lorem.sentence}", profile_field:profile_field9, member: member)
  end

  #管理者ユーザーを生成し、サンプルチームの管理者に設定
  admin_user=FactoryBot.create(:user,name:"サンプルユーザー",email:"sample@sample.com",confirmed_at:Time.zone.now)
  Admin.set_as_admin(admin_user,team)
end

# 本番環境(お試し版)
if Rails.env.production?
  # Botユーザーを用意
  30.times do
    User.create!(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      confirmed_at: Time.zone.now,
      password: "password",                 # 任意のパスワードを設定
      password_confirmation: "password"     # パスワード確認
    )
  end
  users = User.limit(30)

  # チームを一つ用意
  team = Team.create!(
    name: "サンプルチーム",
    uuid: SecureRandom.uuid
  )
  team.logo.attach(io: File.open("public/images/logo.png"), filename: "logo.png")

  # 30人のメンバーをチームに参加させる
  users.each do |user|
    Member.create!(team: team, user: user)
  end
  members = Member.limit(30)
  members.each do |member|
    member.image.attach(io: File.open("public/images/image.png"), filename: "image.png")
  end

  # チームのプロフィール項目を設定
  profile_field1 = ProfileField.create!(name: "名前（偽名で構いません）", team: team)
  profile_field2 = ProfileField.create!(name: "誕生日", team: team)
  profile_field3 = ProfileField.create!(name: "大学名(学生の方であれば)", team: team)
  profile_field4 = ProfileField.create!(name: "学部名", team: team)
  profile_field5 = ProfileField.create!(name: "出身地", team: team)
  profile_field6 = ProfileField.create!(name: "高校名", team: team)
  profile_field7 = ProfileField.create!(name: "職業(社会人の方であれあば)", team: team)
  profile_field8 = ProfileField.create!(name: "あなたの夢", team: team)
  profile_field9 = ProfileField.create!(name: "コメント", team: team)

  # 30人のメンバーにプロフィールを登録させる
  members.each do |member|
    ProfileValue.create!(content: member.user.name, profile_field: profile_field1, member: member)
    ProfileValue.create!(content: Faker::Date.birthday(min_age: 18, max_age: 65).to_s, profile_field: profile_field2, member: member)
    ProfileValue.create!(content: Faker::University.name, profile_field: profile_field3, member: member)
    ProfileValue.create!(content: Faker::Educator.degree, profile_field: profile_field4, member: member)
    ProfileValue.create!(content: Faker::Address.state, profile_field: profile_field5, member: member)
    ProfileValue.create!(content: Faker::Educator.secondary_school, profile_field: profile_field6, member: member)
    ProfileValue.create!(content: Faker::Music::RockBand.song, profile_field: profile_field7, member: member)
    ProfileValue.create!(content: Faker::Job.title, profile_field: profile_field8, member: member)
    ProfileValue.create!(content: "初めまして、#{member.user.name}です。#{Faker::Lorem.sentence}", profile_field: profile_field9, member: member)
  end

  # 管理者ユーザーを生成し、サンプルチームの管理者に設定
  admin_user = User.create!(
    name: "サンプルユーザー",
    email: "sample@sample.com",
    confirmed_at: Time.zone.now,
    password:"password",
    password_confirmation:"password",
  )
  Admin.set_as_admin(admin_user, team)
end
