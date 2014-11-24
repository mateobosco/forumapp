require "cuba"
require "cuba/render"
require "ohm"

require_relative "models/topic"
require_relative "models/comment"


Cuba.plugin(Cuba::Render)
Cuba.use Rack::Session::Cookie, secret: "foobar"

Ohm.redis = Redic.new(ENV["REDIS_URL"])

Cuba.define do
  @page = {}

  on get, "topics/:id" do |id|
    res.write(view("topic", topic: Topic[id]))
  end
  
  on get, "preguntar" do
    res.write(view("new_topic"))
  end
  
  on post, "topics/:id/comment" do |id|
    Comment.create(
      body: req.POST["body"],
      topic: Topic[id]
      )
    
    res.redirect("topic/#{id}")
  end
  
  on post, "preguntar" do
    Topic.create( 
      title: req.POST["title"],
      body: req.POST["body"]
      )
    res.write(view("home", topics: Topic.all))
  end
  
  on root do
    res.write(view("home", topics: Topic.all))
  end
end