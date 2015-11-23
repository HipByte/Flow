class Tweet < Model
  attributes :name,
             :username,
             :avatar_url,
             :text
  has_one :user, User
end
