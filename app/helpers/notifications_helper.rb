module NotificationsHelper
  def posted_time(time)
    time > Date.today ? "#{time_ago_in_words(time)}前" : time.strftime('%m月%d日')
  end

  def read_status(read)
    read ? content_tag(:span,"既読",class:"blue") : content_tag(:span,"未読",class:"red")
  end
end
