class Notifier < ActionMailer::Base
  default from: "fts@framgia.com"
  def new_category user, category
    @user = user
    @category = category
    mail(
      to: user.email,
      subject: "New Category",
      sent_on: Time.now
    )
  end
end
