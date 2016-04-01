class Ability
  include CanCan::Ability

  def initialize user
   user ||= User.new # guest user (not logged in)

   if user.role == "Admin"
     can :manage, :all
     cannot :delete, User, id: user.id
   else
     can :read, User
     can :edit, User, id: user.id
     can :read, Category
     can :manage, Exam
     cannot :delete, Exam
     can :read, Answer
   end
  end
end
