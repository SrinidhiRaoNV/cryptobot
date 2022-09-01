# Cryptobot

  * Cryptobot is a Elixir Messenger bot to communicate historical Cryptocurrency prices to the User.
  * The user needs to send a "hi" message in the messenger and than choose appropriately to get the info that they need.

**Initial setup**

1) Create a page on Facebook
2) Create a Messenger app in the developers.facebook.com and link it to the above page
3) Generate the API token in the Messenger settings of the app
4) Subscribe to messages an message postbacks
5) Add the callback URL(Webhook) and ensure that the server is on when adding it
6) Send a hi message in the messenger and you are good to start

**Server deployment**

**Local Setup**

mix deps.get
mix phx.server

**Docker build**

docker build ./ -t cryptobot

docker run -it -e SECRET_KEY_BASE='<<put your secret key base here>>' -e FACEBOOK_TOKEN='<Your page access token Here>' -p 4000:4000 cryptobot
