require 'rails_helper'

RSpec.feature 'User Show Page', type: :feature do
  let!(:user) do
    User.create(name: 'Test User', bio: 'Test bio', photo: 'https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80')
  end

  let!(:post1) do
    user.posts.create(title: 'Test Post 1', text: 'Test post text 1', author: user)
  end

  let!(:post2) do
    user.posts.create(title: 'Test Post 2', text: 'Test post text 2', author: user)
  end

  let!(:post3) do
    user.posts.create(title: 'Test Post 3', text: 'Test post text 3', author: user)
  end

  before do
    visit user_path(user)
  end

  scenario 'display selectors' do
    expect(page).to have_selector('.show-page')
    expect(page).to have_selector('.bio')
    expect(page).to have_selector('.posts-list')
    expect(page).to have_selector('.see-all-posts-btn-container')
  end

  scenario "displays user's information" do
    expect(page).to have_selector('.show-user')
    within('.show-user') do
      expect(page).to have_css("img[src*='#{user.photo}']")
      expect(page).to have_content(user.name)
      expect(page).to have_content("#{user.posts_counter} post")
      expect(page).to have_link('Create post', href: new_user_post_path(user))
    end
  end

  scenario 'display users bio' do
    within('.bio') do
      expect(page).to have_content(user.bio)
    end
  end

  scenario 'display posts information' do
    expect(page).to have_content("Latest Posts (#{user.posts_counter})")
    within('.posts-list') do
      expect(page).to have_content(post1.title)
      expect(page).to have_content(post1.text)
      expect(page).to have_link(href: user_post_path(user, post1))
      expect(page).to have_content("Comments: #{post1.comments_counter}")
      expect(page).to have_content("Likes: #{post1.likes_counter}")

      expect(page).to have_content(post2.title)
      expect(page).to have_content(post2.text)
      expect(page).to have_link(href: user_post_path(user, post2))
      expect(page).to have_content("Comments: #{post2.comments_counter}")
      expect(page).to have_content("Likes: #{post2.likes_counter}")

      expect(page).to have_content(post3.title)
      expect(page).to have_content(post3.text)
      expect(page).to have_link(href: user_post_path(user, post3))
      expect(page).to have_content("Comments: #{post3.comments_counter}")
      expect(page).to have_content("Likes: #{post3.likes_counter}")
    end
  end

  scenario 'displays see all post btn' do
    within('.see-all-posts-btn-container') do
      expect(page).to have_link('See all posts', href: user_posts_path(user))
    end
  end

  scenario 'redirect to create post' do
    click_link href: new_user_post_path(user)
    expect(page).to have_current_path(new_user_post_path(user))
  end

  scenario 'redirect to see all posts' do
    click_link href: user_posts_path(user)
    expect(page).to have_current_path(user_posts_path(user))
  end

  scenario 'redirect to see post' do
    click_link href: user_post_path(post1.author, post1)
    expect(page).to have_current_path(user_post_path(post1.author, post1))
  end
end
