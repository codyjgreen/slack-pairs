module SlackMessage
  module_function

  def pair_message(pair:)
    pair_usernames = pair.map{ |user| "<@#{user}>" }.to_sentence
    [
      {
        type: "section",
        block_id: "pair_introduction",
        text: {
          type: "mrkdwn",
          text: ":wave: Hi#{pair_usernames}! You've been paired up for a networking chat from #connect-in-tech! Find a time to meet and get to know each other!"
        }
      }
    ]
  end
end
