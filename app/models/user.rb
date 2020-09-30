class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  # Explain THIS and WHY it's relevant sent_req & received_req
  has_many :sent_requests, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :received_requests, class_name: 'Friendship', foreign_key: 'friend_id'

    # user_id       friend_id     confirmed

  def accepted_friendships
    # self.sent_requests.where(confirmed: true)
    # esto funciona por que hicimos el double row en el controlador. Entonces por eso solo buscamos en el lado izquierdo (user_id) y no el derecho (friend_id). Creamos lo que el TSE pide que busquemos con el puro user_id al hacer el double row, por eso aqui no necesitamos hacer un double query ni un join explicito.
    sent_requests.where(confirmed: true)
  end
  
  # Users who has SENT a friend request and is waiting for confirmation
  def pending_request
    sent_requests.where(confirmed: nil)
  end
  
  # Users who RECEIVED a friend request and needs to confirm the request.
  def pending_accept
    received_requests.where(confirmed: nil)
  end
  
  # To Confirm a Friend from (User) When I want to confirm someone's friendship
  # When a friend is confirmed, the mirror (second row) needs to be created. Ctrlr shouldn't really do logic.
  def confirm_friend(user)
    # this method is applied to the invitee. Who will be confirming friendship from requesting user.
    # friendships_list = Friendship.where(friend_id: current_user, user_id: user)
    friendships_list = pending_accept.where(user_id: user)
    # User.find(2).pending_accept.where(user_id: 3)
    # where gives us a list, in this case an element from a list, can't save it, it's a full list object, & haven't made chgs. Need to filter first what I want to change, make the chg and THEN save THE change. not the full list element.
    puts "HELLOOOOOO I'M HEREEEEEEEEEEEEEEEEEEE"
    puts friendships_list.first
    puts "HELLOOOOOO I'M HEREEEEEEEEEEEEEEEEEEE"
    # 1. obtener la lista donde tenga invitaciones pendientes donde aparece ESE USER ie. tengo invitaciones pendientes de Barry especificamente. like this -> [[]]
    # 2. Obtengo el elemento de esa lista (1 row de la tabla Friendships)but i just want the element inside that list even though i just had the one, this one goes INTO the list and gives me specifically THAT ONE element  like this -> []
    # 3. Le cambio el status de confirmed de nil a true a ese row especifico. -> []
    # 4. Guardo ese friendship
    # 5. Creo un nuevo friendship donde yo soy el que manda la invitacion, el user es quien la recibe y el estatus es verdadero. Osea la amistad espejo, inversa, symetrica...su OPUESTO IGUAL! bajajajajajaj
    # 6. Guardo esta nueva friendship que cree 
  end

  # To Confirm a Friend (User) When I want to confirm someone's friendship
  # def confirm_friend(user)
  #   confirmed_friend = inverse_friendships.find { |friendship| friendship.user == user }
  #   confirmed_friend
  # end
  
  def delete_friend(user)
    delete_friend = received_requests.find { |friendship| friendship.user == user }
    delete_friend
  end
  
  # Determines if The User is the Invitee RECEIVER
  # Yo Lola tengo invitacion de Tony?
  # Lola.invitee?(tony)
  def invitee?(user)
    # am I receiving the invite from user?
    # confirmed_friend = received_requests.find { |friendship| friendship.user == user }
    # return false if confirmed_friend.nil?
    # true
    !received_requests.where(user_id: user, confirmed: nil).empty?
  end

  # Determines if the User is the invited SENDER
  # Lola.requested_friend?(tony) true or false
  def requested_friend?(user)
    # did I send the user an invitation?
    # pending_friends.include?(user)
    !sent_requests.where(friend_id: user, confirmed: nil).empty?
  end
  
  # To Confirm if it's an existing Friend
  # Yo Lola soy amiga de Tony?
  # Lola.friend?(tony)
  def friend?(user)
    # accepted_friendships.include?(user)
    !received_requests.where(user_id: user, confirmed: true).empty?
  end

end

# scope :accepted_friendships, -> { where("friendships.sent_friendships.confirmed = true") }
# has_many :friendships
# busca amigo usando FK user_id RESULTADO= user.find(id_friend)
# has_many :friends, through: :friendships

# busca amigo usando FK id_friend
# has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
# has_many :inverse_friends, through: :friendships, source: :user

# Confirmed Friendships
# def amigos
#   friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
#   friends_array.concat(inverse_friendships.map { |friendship| friendship.user if friendship.confirmed })
#   friends_array.compact
# end

# Users who has SENT a friend request and is waiting for confirmation
# def pending_friends
#   friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
# end
# confirmed Friendships
# Users who RECEIVED a friend request and needs to confirm the request.
# def friend_requests
#   inverse_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
# end