require 'rails_helper'

RSpec.feature 'Post index page', type: :feature do
  let!(:user) do
    User.create!(name: 'User', bio: 'user Bio', photo: 'https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80')
  end

  let!(:post1) do
    Post.create!(title: 'Test Post 1', text: 'Test post text 1', author: user)
  end

  let!(:post2) do
    Post.create!(title: 'Test Post 1', text: 'Test post text 1', author: user)
  end

  let!(:post3) do
    Post.create!(title: 'Test Post 1', text: 'Test post text 1', author: user)
  end

  let!(:comment1) do
    Comment.create!(text: 'Comment1', posts: post1, author: user)
  end

  let!(:comment2) do
    Comment.create!(text: 'Comment2', posts: post1, author: user)
  end

  let!(:comment3) do
    Comment.create!(text: 'Comment3', posts: post1, author: user)
  end

  let!(:comment4) do
    Comment.create!(text: 'Comment4', posts: post1, author: user)
  end

  before do
    visit user_posts_path(user)
  end

  scenario 'displays the posts index page selectors' do
    expect(page).to have_selector('#posts-index-page')
    within('#posts-index-page') do
      expect(page).to have_selector('.post-user')
      expect(page).to have_selector('.posts-list')
      expect(page).to have_selector('.flickr_pagination')
    end
  end

  scenario "shows the user's information" do
    within('.post-user') do
      expect(page).to have_css("img[src*='#{user.photo}']")
      expect(page).to have_content(user.name)
      expect(page).to have_content("#{user.posts.count} post")
      expect(page).to have_link('Create post', href: new_user_post_path(user))
    end
  end

  scenario 'shows post and comments' do
    within('.posts-list') do
      expect(page).to have_content(post1.title)
      expect(page).to have_content(post1.text)
      expect(page).to have_link(href: user_post_path(user, post1))
      expect(page).to have_content("Comments: #{post1.comments.count}")
      expect(page).to have_content("Likes: #{post1.likes.count}")

      within('.comments-list') do
        expect(page).to have_content(comment1.author.name)
        expect(page).to have_content(comment1.text)
        expect(page).to have_css("img[src*='#{comment1.author.photo}']")

        expect(page).to have_content(comment2.author.name)
        expect(page).to have_content(comment2.text)
        expect(page).to have_css("img[src*='#{comment2.author.photo}']")

        expect(page).to have_content(comment3.author.name)
        expect(page).to have_content(comment3.text)
        expect(page).to have_css("img[src*='#{comment3.author.photo}']")

        expect(page).to have_content(comment4.author.name)
        expect(page).to have_content(comment4.text)
        expect(page).to have_css("img[src*='#{comment4.author.photo}']")
      end
    end
  end

  scenario 'Create a new comment' do
    click_link href: new_user_post_comment_path(post1.author, post1)
    expect(page).to have_current_path(new_user_post_comment_path(post1.author, post1))

    visit user_posts_path(user)
    within '.comment-form', match: :first do
      fill_in 'Enter you comment', with: 'This is a test comment.'
      click_button 'Comment'
    end
    expect(page).to have_current_path(user_post_path(user, post1))
    expect(page).to have_content('This is a test comment.')
  end

  scenario 'Create a new like' do
    within '.like-form', match: :first do
      click_button
      expect(page).to have_current_path(user_post_path(post1.author, post1))
    end
  end

  scenario 'Create a new post' do
    within '.create-post-btn-container' do
      click_link href: new_user_post_path(post1.author)
      expect(page).to have_current_path(new_user_post_path(post1.author))
    end
  end

  scenario 'Go to show post page' do
    click_link href: user_post_path(post1.author, post1)
    expect(page).to have_current_path(user_post_path(post1.author, post1))
  end

  scenario 'Go to next page' do
    within '.flickr_pagination' do
      click_link 'Next', href: "/users/#{user.id}/posts?page=2"
      expect(page).to have_current_path("/users/#{user.id}/posts?page=2")
    end
  end
end
