require 'rest-client'

class UserController < ApplicationController


	#---methods loading up pages----------------
	def log_in
		if !params[:username].blank? && !params[:password].blank?
			username = params[:username]
			password = params[:password]
			error_log = nil

			res = UserController.re_authenticate_user(username,password)
	
			if res['status'] == 200 && res['error'] == false
				session[:user] = {	"username" => username,
									"password" => password
								 }

				redirect_to '/home'
				
			else 
				@error_log = 'wrong username or password'
			end
		
		end
	end

	def home
		
	end



	#---methods processing data-----------------
	def self.load_configs
		configs = YAML.load_file("#{Rails.root}/config/application.yml")
		data = {
				"ip" => configs["service_ip"],
				"version" => configs["service_version"],
				"location" => configs["location"],
				"partner" =>  configs["partner"],
				"app_name" => configs["app_name"],
				"de_username" => configs["de_username"],
				"de_password" => configs["de_password"]
		}

		return data
	end



	def authenticate_user
		username = params['username']
		password = params['password']
		configs = load_configs

		url = configs['ip'] + configs['version'] + "authenticate/#{username}/#{password}"
		res = JSON.parse(RestClient.get(url, :content_type => 'application/json'))
		return password
	end

	def self.re_authenticate_user(username,password)
		configs = self.load_configs
		url = configs['ip'] + configs['version'] + "re_authenticate/#{username}/#{password}"
		res = JSON.parse(RestClient.get(url, :content_type => 'application/json'))
		return res
	end

	def self.check_token_validity(username)
		configs = self.load_configs
		token = JSON.parse(File.read("#{Rails.root}/public/tokens.json"))
		token = token[username]
		url = configs['ip'] + configs['version'] + "check_token_validity/#{token}"
		res = JSON.parse(RestClient.get(url, :content_type => 'application/json'))
		return res
	end


	def create_user
		pa_data = params
		token = JSON.parse(File.read("#{Rails.root}/public/tokens.json", 'a'))
		token = token['admin']

		url = configs['ip'] + configs['version'] + "create_user/#{token}"
		res = JSON.parse(RestClient.post(url,data, :content_type => 'application/json'))
		return res
	end




end
