class UserMailer < ActionMailer::Base
  default from: "deleted@rottenmangoes.com"

  def delete_email(user)
    @user = user
    @url = 'http://localhost:3000'
    mail(to: @user.email)
  end
end
