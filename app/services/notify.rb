class Notify
  def initialize category
    @category = category
  end

  def notify_users
    @user = User.normal
    @user.each do |user|
      Notifier.new_category(user, @category).deliver
    end
  end
end
