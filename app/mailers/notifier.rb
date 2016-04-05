class Notifier < ActionMailer::Base
  default from: "fts@framgia.com"
  def new_category user, category
    @user = user
    @category = category
    mail(
      to: user.email,
      subject: t(".new_category"),
      sent_on: Time.now
    )
  end

  def expired_exam exam
    @exam = Exam.find exam
    mail(
      to: @exam.user.email,
      subject: t(".expired_exam"),
      sent_on: Time.now
    )
  end

  def exam_result exam
    @exam = Exam.find exam
    mail(
      to: @exam.user.email,
      subject: t(".exam_result"),
      sent_on: Time.now
    )
  end

  def send_statistics user
    @user = user
    mail(
      to: @user.email,
      subject: t(".statistics"),
      sent_on: Time.now
    )
  end
end
