require 'dotenv'
require 'pinboard'
require 'buffer'
require 'active_support/all'
require 'pp'
Dotenv.load

def client
  @client ||= Buffer::Client.new(Env.BUFFER_ACCESS_TOKEN)
end

def posted
  @posted ||= begin
		File.open("seen.txt").read.split("\n")
	      rescue Errno::ENOENT
		[]
	      end
end

def save_posted
  File.open("seen.txt", "w+") do |f|
    f.puts posted.join("\n")
    @posted = nil
  end
end
			
def profile_ids
  @profiles_id ||= begin
    if ENV['BUFFER_PROFILE_IDS'].nil?
      puts "Please fill in BUFFER_PROFILE_IDS to select on which profile to publish"
      PP.pp  client.profiles.map { |prof|
	{
	  _id: prof["_id"],
	  service: prof["formatted_service"],
	  username: prof["formatted_username"]
	}
      }
      exit 12
    else
      ENV['BUFFER_PROFILE_IDS'].split(",")
    end
 end
end



pinboard = Pinboard::Client.new(:token => ENV['PINBOARD_TOKEN'])
posts = pinboard.posts(fromdt: 5.days.ago,:tag => '@post')

if posts.count > 0
  posts.each do |post|
    if !posted.include? post.href
      PP.pp client.link({url:post.href})
      content = {body: {
	text: post.extended,
	profile_ids: profile_ids,
	media: {
	  link: post.href,
	  title: post.description
	}
      }}
      client.create_update(content)
      posted << post.href
      save_posted()
    end
  end
end




