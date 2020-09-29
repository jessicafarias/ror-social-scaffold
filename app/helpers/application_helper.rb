module ApplicationHelper
  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end

  def display_users(users)
    list_item = content_tag(:li, class: 'mt-2') do
    end
    users.each do |user|
      list_item +=
        content_tag(:h3) do
          user.name
        end +
        content_tag(:div, class: 'd-flex') do
          content_tag(:span, class: 'profile-link mr-2 ') do
            button_to 'See Profile', user_path(user), method: 'get', class: 'gbc-blue profile-link'
          end +
            friendship_buttons(user)
        end
    end
    list_item
  end

  def friendship_buttons(user)
    if current_user.invitee?(user) && !user.friend?(current_user)
      content_tag(:div, class: 'd-flex') do
        content_tag(:span, class: 'profile-link mr-2') do
          button_to 'Accept', "/friendships/#{user.id}", method: 'put', class: 'profile-link gbc-blue'
        end +
          content_tag(:span, class: 'profile-link') do
            button_to 'Decline', "/friendships/#{user.id}", method: 'delete', class: 'profile-link'
          end
      end
    elsif current_user.requested_friend?(user) && !user.friend?(current_user)
      content_tag(:span, class: 'disable profile-link') do
        button_to 'Pending', class: 'disable profile-link'
      end
    elsif !user.friend?(current_user)
      content_tag(:span, class: 'profile-link') do
        button_to 'Add Friend', "/adding/#{user.id}", method: 'get', class: 'bgc-green mr-2 profile-link'
      end
    else
      content_tag(:span, class: 'profile-link') do
        button_to "Remove #{user.id}", "/friendships/#{user.id}", method: 'delete', class: 'bgc-red profile-link'
      end
    end
  end
end