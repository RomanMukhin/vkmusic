class Ability
  include CanCan::Ability

  def initialize(user) 
    user ||= User.new # guest user (not logged in)
    if user.logged_in?
      can :create, Song
      can :create, List
      can :destroy, Song
      can :destroy, List
    else
      raise CanCan::AccessDenied.new("Not authorized!", :read, Article) 
    end
  end
end
