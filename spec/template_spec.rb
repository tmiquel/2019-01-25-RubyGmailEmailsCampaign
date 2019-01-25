
require_relative '../lib/user'

describe User do

# describe Client do
#   before :each do
#     @client = Client.new
#   end

#   [ :connect, :disconnect, :server_address ].each do |method|
#     it "should respond to #{method}" do
#       @client.should respond_to(method)
#     end
#   end
# end


# METHODE D'INSTANCE
# describe Client do
#   describe '#initialize' do
#     it 'should respond with default values' do
#       # ... arrange, act, assert ...
#     end
#   end
# end

# METHODE DE CLASSE
# describe Client do
#   describe '.generate' do
#     it 'should return a valid Client instance' do
#       # ... arrange, act, assert ...
#     end
#   end
# end


# METHODE D'INSTANCE / UTILISATION DE SHOULD et de SUBJECT
# describe Client do
#   before(:all) do
#     @client = Client.new
#   end

#   subject { @client }

#   it { should respond_to :connect }
#   it { should respond_to :disconnect }
#   it { should respond_to :server_name }
# end


# METHODE D'INSTANCE / UTILISATION DE SHOULD et d'un SUBJECT implicite
# describe Client do
#   [ :connect, :disconnect, :server_name ].each do |attribute|
#     it { should respond_to attribute }
#   end
# end

# ITS : a shortcut for the implicit subject’s attributes.
# describe Client do
#   context "created with defaults" do
#     its(:server_name) { should eq("http://defaultserver.com") }
#   end
# end

# LET: The value returned by the let block is cached for the execution of the single example.
# describe Customer do

#   let (:customer) { Customer.first }

#   it 'should have a full name that is composed of their first name and last name' do
#       customer.full_name.should eq("#{customer.first_name} #{customer.last_name}")
#     end
#   end
# end

# SHARED TEST for multiple classes
# shared_examples "a published document" do
#   [ :author, :publish_date, :featured ].each do |attribute|
#     it { should respond_to attribute }
#   end
# end

# describe Article do
#   it_behaves_like "a published document"
# end

# describe Video do
#   it_behaves_like "a published document"
# end




  before(:each) do
  	# ligne trouvée ici : https://geminstallthat.wordpress.com/2008/08/11/reloading-classes-in-rspec/
  	# qui permet de remettre à zéro la classe. Pratique pour la méthode count, mais pas obligatoire.
    Object.send(:remove_const, 'User')
    load 'user.rb'
  end

	describe 'initializer' do

		it 'creates an user' do
      user = User.new("email@email.com")
      expect(user.class).to eq(User)
		end

		it 'saves @email as instance variable' do
			email = "email@email.com"
			user = User.new(email)
			expect(user.email).to eq(email)
		end

		it 'adds one to the @@count global variable' do
			count = User.count
			user = User.new("email@email.com")
			expect(User.count).to eq(count + 1)
		end
	end



	describe 'instance methods' do

		describe 'change_password' do
			it "changes password to ##ENCRYPTED##" do
				user = User.new("email@email.com")
				password = "some string"
				user.change_password(password)
				expect(user.password).to eq("##ENCRYPTED##")
			end
		end

		describe 'show_itself' do
			it "shows itself" do
				user = User.new("email@email.com")
				user.show_itself
				expect do
					user.show_itself
				end.to output("#{user}\n").to_stdout
				# OK celle là est super hard, mais en même temps c'est pas des méthodes que l'on utilise souvent. Solution trouvée ici : https://stackoverflow.com/a/38377720
			end
		end

	end

	describe 'instance variables' do

		describe '@email' do

			it 'can be read' do 
				email = "email@email.com"
				user = User.new(email)
				expect(user.email).to eq(email)
			end

			it 'can be written' do 
				email = "email@email.com"
				user = User.new(email)
				email_2 = "email_2@email.com"
				user.email = email_2
				expect(user.email).not_to eq(email)
				expect(user.email).to eq(email_2)
			end

		end

	end

	describe 'class methods' do

		describe 'self.count' do
			it 'shows the number of users' do 
				user_1 = User.new("email1@email.com")
				user_2 = User.new("email2@email.com")
				user_3 = User.new("email3@email.com")
				expect(User.count).to eq(3)
			end
		end

	end
