every 1.month, at: "end of the month at 11pm" do
  runner "User.send_statistics", environment: "development"
end
