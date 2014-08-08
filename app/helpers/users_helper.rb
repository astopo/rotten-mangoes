module UsersHelper
  def is_admin?
    return "Yes" if @user.admin?
    "No"
  end
end
