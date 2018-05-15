require 'rest-client'


class SampleController < ApplicationController

	def load_configs
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



	def patient
		
	end

	def get_patients
		search_string = params[:search_string]
		configs = load_configs
		tokens = JSON.parse(File.read("#{Rails.root}/public/tokens.json"))
		username = session[:user]['username']
		password = session[:user]['password']

		res = UserController.check_token_validity(username)
		if res['error'] == false
			token = tokens['lims6']
			url = configs['ip'] + configs['version'] + "get_patients/" +  search_string + "/#{token}"
			res = JSON.parse(RestClient.get(url, :content_type => 'application/json'))			
			if res['error'] == false 
				res = res['data']['results']
				render plain: res.to_json and return
			else
				render plain: [false,res['message']] and return
			end

		elsif res['message'] == 'token expired'
			res = UserController.re_authenticate_user(username, password)
			if res['error'] == false
			   token = res['data']['token']			   
			   tokens[username] = token			   
			   File.open("#{Rails.root}/public/tokens.json", 'w') { |f|

			   		f.write(tokens.to_json)
			   	}

			   	url = configs['ip'] + configs['version'] + "get_patients/" +  search_string + "/#{token}"
				res = JSON.parse(RestClient.get(url, :content_type => 'application/json'))
			
				if res['error'] == false 
					res = res['data']['results']
					render plain: res.to_json and return
				else
					render plain: [false,res['message']] and return
				end
			end		
		end
		
	end


	def create_sample
		@details = JSON.parse(params[:data]).split(",")

	end

	def create

		redirect_to '/sam' and return
	end

	def sample

	end

end
