require 'rails_helper'

  RSpec.describe Achievement, type: :model do
    describe "validations" do
      it { should validate_presence_of(:title) }
      it { should validate_uniqueness_of(:title).scoped_to(:user_id).with_message("you can't have two achievements with same title") }
      it { should validate_presence_of(:user) }
      it { should belong_to(:user) }
    end

    it "convers markdown to html" do
      achievement = Achievement.new(description: 'Awesome **thing** I *actually* did')
      expect(achievement.description_html).to include('<strong>thing</strong>')
      expect(achievement.description_html).to include('<em>actually</em>')
    end

    it "has sily title" do
      achievement = Achievement.new(title: "New Achievement", user: FactoryBot.create(:user, email: 'test@test.com'))
      expect(achievement.silly_title).to eq('New Achievement by test@test.com')
    end

    it "only fetches achievements which title starts from provided letter" do
      user = FactoryBot.create(:user)
      achievement1 = FactoryBot.create(:public_achievement, title: 'Read a book', user: user)
      achievement2 = FactoryBot.create(:public_achievement, title: 'Passed an exam', user: user)
      expect(Achievement.by_letter("R")).to eq([achievement1])
    end

    it "sorts achievements by user emails" do
      albert = FactoryBot.create(:user, email: 'albert@email.com')
      rob = FactoryBot.create(:user, email: 'rob@email.com')
      achievement2 = FactoryBot.create(:public_achievement, title: 'Rocked it', user: albert)
      achievement1 = FactoryBot.create(:public_achievement, title: 'Read a book', user: rob)
      expect(Achievement.by_letter("R")).to eq([achievement2, achievement1])
    end
  end




      # it "requires title" do
      #   achievement = Achievement.new(title: '')
      #   # achievement.valid?
      #   # expect(achievement.errors[:title]).to include("can't be blank ")
      #   # expect(achievement.errors[:title]).not_to be_empty
      #   expect(achievement.valid?).to be_falsy
      # end

      # it "requires unique title for one user" do
      #   user = FactoryBot.create(:user)
      #   first_achievement = FactoryBot.create(:public_achievement, title: "First achievement", user: user)
      #   new_achievement = Achievement.new(title: "First achievement", user: user)
      #   expect(new_achievement.valid?).to be_falsy
      # end

      # it "allows different users to have achievements with identical titles" do
      #   user1 = FactoryBot.create(:user)
      #   user2 = FactoryBot.create(:user)
      #   first_achievement = FactoryBot.create(:public_achievement, title: "First achievement", user: user1)
      #   new_achievement = FactoryBot.create(:public_achievement, title: "First achievement", user: user2)
      #   expect(new_achievement.valid?).to be_truthy
      # end

    # it "belongs to user" do
    #   achievement = Achievement.new(title: 'Some title', user: nil)
    #   expect(achievement.valid?).to be_falsy
    # end

    # it "has belongs_to user association" do
    #   #1
    #   user = FactoryBot.create(:user)
    #   achievement = Achievement.new(title: 'Some title', user: user)
    #   expect(achievement.user).to eq(user)
    #
    #   #2
    #   u = Achievement.reflect_on_association(:user)
    #   expect(u.macro).to eq(:belongs_to)
    # end
