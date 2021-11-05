# Set the host name for URL creation
require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = "https://www.firework.vn/"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  
  add root_path, :priority => 0.7, :changefreq => 'daily'

  Company.find_each do |company|
    add company_path(company), :changefreq => 'daily', :lastmod => company.updated_at

    company.company_reviews.find_each do |company_review|
      add company_company_review_path(company, company_review), :changefreq => 'daily', :lastmod => company_review.updated_at
    end

    company.company_interviews.find_each do |company_interview|
      add company_company_interview_path(company, company_interview), :changefreq => 'daily', :lastmod => company_interview.updated_at
    end

    company.company_images.find_each do |company_image|
      add company_company_image_path(company, company_image), :changefreq => 'daily', :lastmod => company_image.updated_at
    end

    company.company_salaries.find_each do |company_salary|
      add company_company_salary_path(company, company_salary), :changefreq => 'daily', :lastmod => company_salary.updated_at
    end

    company.company_questions.find_each do |company_question|
      add company_company_question_path(company, company_question), :changefreq => 'daily', :lastmod => company_question.updated_at
    end
  end

  CompanyJob.find_each do |company_job|
    add company_job_path(company_job), :changefreq => 'daily', :priority => 0.7, :lastmod => company_job.updated_at
  end

  Post.find_each do |post|
    add post_path(post), :changefreq => 'daily', :lastmod => post.updated_at
    post.post_comments.find_each do |post_comment|
      add post_post_comment_path(post, post_comment), :changefreq => 'daily', :lastmod => post_comment.updated_at
    end
  end

  Problem.find_each do |problem|
    add problem_path(problem), :changefreq => 'daily', :lastmod => problem.updated_at
    problem.problem_solutions.find_each do |problem_solution|
      add problem_problem_solution_path(problem, problem_solution), :changefreq => 'daily', :lastmod => problem_solution.updated_at
    end
  end

  add '/home', :changefreq => 'daily', :priority => 0.9
  add about_us_path, :changefreq => 'weekly'
  add contact_us_path, :changefreq => 'weekly'
  add our_product_path, :changefreq => 'weekly'
  add policy_path, :changefreq => 'weekly'
  add term_path, :changefreq => 'weekly'
end
SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks
