class Model
  def initialize(hash={})
    @attributes = hash
  end

  def read_attribute_for_serialization(name)
    if name == :id || name == 'id'
      object_id
    else
      @attributes[name]
    end
  end
end


###
## Models
###
class User < Model
  def profile
    @profile ||= Profile.new(name: 'N1', description: 'D1')
  end
end

class Profile < Model
end

class Event < Model
end

class Post < Model
  def comments
    @comments ||= [Comment.new(content: 'C1'),
                   Comment.new(content: 'C2')]
  end
end

class Comment < Model
end

###
## Serializers
###
class UserSerializer < ActiveModel::Serializer
  attributes :name, :email

  has_one :profile
end

class ProfileSerializer < ActiveModel::Serializer
  def description
    description = object.read_attribute_for_serialization(:description)
    scope ? "#{description} - #{scope}" : description
  end

  attributes :name, :description
end

class PostSerializer < ActiveModel::Serializer
  attributes :title, :body, :created_at, :updated_at

  has_many :comments
end

class EventSerializer < ActiveModel::Serializer
  attributes :created_at, :updated_at
end

class CommentSerializer < ActiveModel::Serializer
  attributes :content
end
