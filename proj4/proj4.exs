
Proj4.Registry.start_link
Proj4.Supervisor.start_link

Proj4.Supervisor.register_user("therealdonaldtrump")
Proj4.Supervisor.register_user("obama")
Proj4.Supervisor.register_user("hillary")

Proj4.Node.follow_user("therealdonaldtrump", "obama")

Proj4.Node.publish_tweet(
  "obama",
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

Proj4.Engine.main()
