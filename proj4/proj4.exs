Proj4.Registry.start_link
Proj4.Supervisor.start_link

Proj4.Supervisor.start_node("user1")
Proj4.Supervisor.start_node("user2")
Proj4.Supervisor.start_node("user3")

Proj4.Node.add_follower("user1", "user2")
Proj4.Node.add_follower("user1", "user3")
Proj4.Node.publish_tweet("user1", "In the name of the father, the son, and the holy MAGA")

