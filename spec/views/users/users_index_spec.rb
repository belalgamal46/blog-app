require 'rails_helper'

RSpec.feature 'Root Page', type: :feature do
  let!(:user) do
    User.create(name: 'User', bio: 'user Bio', photo: 'https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80')
  end

  before do
    visit root_path
  end

  scenario 'displays user' do
    expect(page).to have_content(user.name)
    expect(page).to have_link(href: user_path(user))
    expect(page).to have_css("img[src*='#{user.photo}']")
    expect(page).to have_content("#{user.posts_counter} post")
    expect(page).to have_link('Create post', href: new_user_post_path(user))
  end

  scenario 'redirect to create post form' do
    click_on 'Create post'
    expect(page).to have_current_path(new_user_post_path(user))
  end

  scenario 'redirect to users show page' do
    click_link href: user_path(user)
    expect(page).to have_current_path(user_path(user))
  end
end
