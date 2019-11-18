
Proj4.Registry.start_link
Proj4.Supervisor.start_link

# nodes = Enum.reduce(
#   ,
#   [],
#   fn id, nodes ->  end
# )


Proj4.Supervisor.start_node("therealdonaldtrump")
Proj4.Supervisor.start_node("obama")
Proj4.Supervisor.start_node("hillary")

Proj4.Node.publish_tweet(
  "therealdonaldtrump",
  %{
    hashtags: ["trump", "america"],
    mentions: ["obama"],
    content: "For the love of MAGA"
  }
)

Proj4.Node.publish_tweet(
  "therealdonaldtrump",
  %{
    hashtags: ["trump","2020", "election"],
    mentions: ["therealdonaldtrump"],
    content: "Guess who has my vote in 2020?!"
  }
)

Proj4.Node.query_tweets("therealdonaldtrump", "trump")
|> Enum.each(fn tweet -> IO.puts tweet[:content] end)
