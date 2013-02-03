class User < ActiveRecord::Base
  belongs_to :role
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:name, :role_id
  #validates :password_confirmation, :presence => true

  validates :name, :presence => true
  validates :role_id, :presence => true
  # attr_accessible :title, :body

  state_machine :state, :initial => :active do
    after_transition :do => :log_admin_comment

    event :activate  do
      transition :inactive => :active
    end
    event :deactivate do
      transition :active => :inactive
    end
  end
  
  def super_admin?
    return self.role.nil? ? false : self.role.name.eql?("super_admin")
  end

  def admin?
    return self.role.nil? ? false : self.role.name.eql?("admin")
  end

  def spartan?
    return self.role.nil? ? false : self.role.name.eql?("spartan")
  end

  def status_tag
    case self.state
    when "Inactive" then :error
    when "Active" then :ok
    end
  end

  def log_admin_comment
    comment = ActiveAdmin::Comment.new
    comment.resource_id = self.id
    comment.resource_type = "User"
    comment.author_id = User.current.id
    comment.author_type = "User"
    comment.body = "#{Time.now.to_s} - #{User.current.name} --> #{state.titleize}"
    comment.namespace = "admin"
    comment.save
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end
  
  def active_for_authentication?
    active? && super
  end
  
  def inactive_message
    inactive? ? :deactivated : super
  end
  
end
