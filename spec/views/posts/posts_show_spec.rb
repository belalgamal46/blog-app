require 'rails_helper'

RSpec.feature 'Post show page', type: :feature do
  let!(:user) do
    User.create(name: 'John Doe', bio: 'a user bio', photo: 'https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80')
  end

  let!(:post) do
    Post.create(title: 'Test Post', text: 'Lorem ipsum dolor sit amet', author: user)
  end

  let!(:comment1) { Comment.create!(text: 'Comment1', posts: post, author: user) }
  let!(:comment2) { Comment.create!(text: 'Comment2', posts: post, author: user) }
  let!(:comment3) { Comment.create!(text: 'Comment3', posts: post, author: user) }
  let!(:comment4) { Comment.create!(text: 'Comment4', posts: post, author: user) }

  before do
    visit user_post_path(user, post)
  end

  scenario 'Post content is visible' do
    expect(page).to have_selector('.show-post-title h2', text: 'Test Post')
    expect(page).to have_selector('.show-post-text p', text: 'Lorem ipsum dolor sit amet')
    expect(page).to have_selector('.show-post-counters span', text: "Comments: #{post.comments_counter}")
    expect(page).to have_selector('.show-post-counters span', text: "Likes: #{post.likes_counter}")
    expect(page).to have_selector('.like-btn')
    expect(page).to have_content("by: #{user.name}")

    within('.show-post-comments') do
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

  scenario 'Create a new comment' do
    click_link href: new_user_post_comment_path(post.author, post)
    expect(page).to have_current_path(new_user_post_comment_path(post.author, post))

    visit user_posts_path(user)
    within '.comment-form', match: :first do
      fill_in 'Enter you comment', with: 'This is a test comment.'
      click_button 'Comment'
    end
    expect(page).to have_current_path(user_post_path(user, post))
    expect(page).to have_content('This is a test comment.')
  end

  scenario 'Create a new like' do
    within '.like-form', match: :first do
      click_button
      expect(page).to have_current_path(user_post_path(post.author, post))
    end
  end
end
