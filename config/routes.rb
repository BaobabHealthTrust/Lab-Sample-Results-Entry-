Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	root 'user#log_in'
	get  '/home' 			=> 'user#home'

	post '/login' 			=> 'user#log_in'
	get  '/login' 			=> 'user#log_in'
	get	 '/find_patient' 	=> 'sample#patient'
	get  '/get_patients/:search_string' => 'sample#get_patients'
	get  '/create_sample' 	=> 'sample#create_sample'
	post '/sample'			=> 'sample#create'
	get  '/sam'				=> 'sample#sample' 

end
