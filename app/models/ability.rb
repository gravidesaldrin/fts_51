class Ability
  include CanCan::Ability

  def initialize user
   user ||= User.new # guest user (not logged in)
   if user.role == "Admin"
     can :manage, :all
   else
     can :read, User
     can :edit, User, id: user.id
   end
  end
end
