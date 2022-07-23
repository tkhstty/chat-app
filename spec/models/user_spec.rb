require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context 'ユーザー登録できるとき' do
      it 'nameとemail、passwordとpassword_confirmationが存在すれば登録できる' do
        expect(@user).to be_valid
      end
    end
    context 'ユーザー登録できないとき' do
      it 'nameが空では登録できない' do
        @user.name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include "Name can't be blank"
      end
      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include "Email can't be blank"
      end
      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include "Password can't be blank"
      end
      it 'passwordが5文字以下では登録できない' do
        @user.password = '01234'
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include "Password is too short (minimum is 6 characters)"
      end
      it 'passwordが129文字以上では登録できない' do
        @user.password = Faker::Internet.password(min_length: 129)
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include "Password is too long (maximum is 128 characters)"
      end
      it 'passwordとpassword_confirmationが不一致では登録できない' do
        @user.password = '012345'
        @user.password_confirmation = '0123456'
        @user.valid?
        expect(@user.errors.full_messages).to include "Password confirmation doesn't match Password"
      end
      it '登録したemailが存在する場合は登録できない' do
        @user.save
        @user_email_test = FactoryBot.build(:user, email: @user.email)
        @user_email_test.valid?
        expect(@user_email_test.errors.full_messages).to include "Email has already been taken"
      end
      it 'emailは@を含まないと登録できない' do
        @user.email = 'emailtest'
        @user.valid?
        expect(@user.errors.full_messages).to include "Email is invalid"
      end
    end
  end
end
