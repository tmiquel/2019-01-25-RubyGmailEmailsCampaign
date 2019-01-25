
Dotenv.load

class GmailSession


	attr_reader :session = GoogleDrive::Session.from_config("config.json")

	def initialize(session = GoogleDrive::Session.from_config("config.json"))
		self = session
	end

	def 


	end
end

