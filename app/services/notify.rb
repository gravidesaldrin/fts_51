class Notify
  def initialize params
    @resource = params
  end

  def notify_new_category
    @user = User.normal
    @user.each do |user|
      Notifier.new_category(user, @resource).deliver
    end
  end

  def notify_exam_expired
    Notifier.expired_exam(@resource).deliver if @resource.finished_time.nil?
  end
  handle_asynchronously :notify_exam_expired,
    run_at: Proc.new {8.hours.from_now}
end
