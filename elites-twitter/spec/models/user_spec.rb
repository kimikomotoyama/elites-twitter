# spec/models/user_spec.rb 新規作成

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it 'nameは必須' do
      is_expected.to validate_presence_of(:name)
    end
    it 'emailは必須' do
      is_expected.to validate_presence_of(:email)
    end
    it '@を2個含むemailは無効' do
      is_expected.not_to allow_value("user@@gmali.com").for(:email)
    end
    it 'imageは必須' do
      is_expected.to validate_presence_of(:image)
    end
    it 'profileは必須' do
      is_expected.to validate_presence_of(:profile)
    end
  end
end