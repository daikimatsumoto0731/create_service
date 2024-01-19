every 1.minute do
  runner "NotificationJob.perform_later"
end