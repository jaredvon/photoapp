####### Warden will set the cookies when a user login ######
Warden::Manager.after_set_user do |user, auth, opts| 
    scope = opts[:scope] 
    auth.cookies.signed["#{scope}.id"] = user.id
end

####### Warden will destroy the cookies once the user logout, since normally only session is destroyed #######3

Warden::Manager.before_logout do |user, auth, opts| 
    scope = opts[:scope] 
    auth.cookies.signed["#{scope}.id"] = nil
end