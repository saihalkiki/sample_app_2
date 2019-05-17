require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home(URL[Home]のテスト。GETリクエストをhomeアクションに対して発行 (=送信) 。レスポンスはリクエストに対して[成功]を返す。タイトルはRuby on Rails Tutorial Sample App)" do
    get static_pages_home_url
    assert_response :success
    assert_select 'title', "Home | Ruby on Rails Tutorial Sample App"
  end

  test "should get help(URL[Help]ページのテスト。GETリクエストをhelpアクションに対して発行 (=送信) 。レスポンスはリクエストに対して[成功]を返す。タイトルはRuby on Rails Tutorial Sample App)" do
    get static_pages_help_url
    assert_response :success
    assert_select 'title', "Help | Ruby on Rails Tutorial Sample App"
  end

 test "should get about page(URL[About]ページのテスト。GETリクエストをaboutアクションに対して発行 (=送信) 。レスポンスはリクエストに対して[200-299]を返す。タイトルはRuby on Rails Tutorial Sample App)" do
   get static_pages_about_url
   assert_response :success
   assert_select 'title', "About | Ruby on Rails Tutorial Sample App"
 end

end
