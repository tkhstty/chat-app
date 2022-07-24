module SignInSupport
  def sign_in(user)
    visit root_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_on 'Log in'
    expect(current_path).to eq root_path
  end
end