class ExamResultsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform resource
    Notifier.exam_result(resource).deliver
  end
end
