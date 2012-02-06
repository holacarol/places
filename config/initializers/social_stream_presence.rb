SocialStream::Presence.setup do |config| 
  #Configures XMPP Server Domain
  config.domain = "localhost"
  #Configures Bosh Service Path
  #config.bosh_service = "http://xmpp-proxy/http-bind"
  #Configures Authentication Method: "cookie" or "password"
  config.auth_method = "cookie"
  #Configures XMPP Server Password
  config.xmpp_server_password = "46d4766c3c7eeef789694454100555f0"
  #Uncomment to enable REST API Security
  #config.secure_rest_api = true
  #Remote or local mode
  config.remote_xmpp_server = false
  #Scripts path to execute ejabberd scripts: local or remote
  config.scripts_path = "/scripts_path"
  #Ejabberd module path in the xmpp server
  config.ejabberd_module_path = "/usr/lib/ejabberd/ebin"
  #Uncomment to enable Social Stream Presence
  #config.enable = true
  
  #Parameters for remote mode
  #SSH Login
  #config.ssh_domain = "domain"
  #config.ssh_user = "login"
  #Comment to allow SSH authentication with key instead of password
  #config.ssh_password= "password"

  #Configure to use a Xmpp Client on Rails App
  #Username of the the Social Stream Admin sid
  config.social_stream_presence_username = "social_stream-presence"
  #Configures Social Stream Rails App Password
  config.password = "83cb1ef72d35f387c0155b4ebc50e009e2ce023e7e1cfb920e81a19878d9bb44"  

end