require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get root(rootルーティング(home)のテスト。レスポンスはリクエストに対して[成功]を返す。タイトルはRuby on Rails Tutorial Sample App)" do
    get root_url
    assert_response :success
    assert_select 'title', "Home | #{@base_title}"
  end

  test "should get help(URL[Help]ページのテスト。GETリクエストをhelpアクションに対して発行 (=送信) 。レスポンスはリクエストに対して[成功]を返す。タイトルはRuby on Rails Tutorial Sample App)" do
    get static_pages_help_url
    assert_response :success
    assert_select 'title', "Help | #{@base_title}"
  end

 test "should get about page(URL[About]ページのテスト。GETリクエストをaboutアクションに対して発行 (=送信) 。レスポンスはリクエストに対して[200-299]を返す。タイトルはRuby on Rails Tutorial Sample App)" do
   get static_pages_about_url
   assert_response :success
   assert_select 'title', "About | #{@base_title}"
 end

end
