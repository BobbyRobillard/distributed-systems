
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

Proj4.Node.query_tweets("therealdonaldtrump", "maga")
|> Enum.each(fn tweet ->
      res = tweet
      |> Tuple.to_list
      |> Enum.at(0)

      IO.puts res[:content]
    end
)
