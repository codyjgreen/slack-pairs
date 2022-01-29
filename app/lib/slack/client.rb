module Slack
  require 'pry'
  class Client
    attr_reader :client

    def self.get_channel_users(client: nil)
      client ||= default_client
      # Get an array of all user ids in the channel
      members = client.conversations_members(
        channel: ENV["PAIR_CHANNEL"],
        limit: 10000
      ).members
      # Map that onto a array of hashes, where each hash contains
	  # "user_id" and "email" values
    
      all_members = members.map do |member|
		 {
			 "user_id" => member,
			 "email" => client.users_info(user: member)["user"]["profile"]["email"]
		 }
      end
      # Select just the users with emails and exclude nil
      real_members = all_members.reject do |member|
         member["email"].nil? 
      end
     # Select just the users with emails that don't end with "flatironschool.com"
      non_staff_members = real_members.reject do |member|
        member["email"].include?("flatironschool")
      end
      non_staff_members.map{ |member| member["user_id"] }
    end
  
    def self.create_conversation(pair:)
      client ||= default_client
      conv = client.conversations_open(users: pair.join(","))
      client.chat_postMessage(
        channel: conv.channel.id,
        blocks: SlackMessage.pair_message(pair: pair)
      )
    end

    private

    def self.default_client
      ::Slack::Web::Client.new(token: ENV["SLACK_OAUTH_TOKEN"])
    end
  end
end
