# in order for this test to pass, the event-machine reactor which - as a server - 
# forwards events to couchdb has to be running.

################################################################
# ATTENTION
# make sure that a event-machine test reactor process is running
# run from the root directory:
#  ruby extras/usage_tracker/reactor.rb test
#
# ##############################################################

require File.dirname(__FILE__) + '/../test_helper'
require 'extras/usage_tracker/initializer'

# this checks the end-point of the usage tracking (arrival in the database) ->
# consider checking intermediate steps.......
class UsageTrackerMiddlewareTest < ActionController::IntegrationTest   
  UsageTracker.connect!
  db = UsageTracker.database

  context "a request" do
    should "get tracked in the db backend (couch)" do
      assert_difference 'db.info["doc_count"]' do
        get '/'
        assert_response :success
      end
    end

    should "result in a db-entry containing search results" do
      get '/search/e'
      assert_response :success
      doc = db.view('basic/by_timestamp', :descending => true, :limit => 1).rows.first.value
      assert !doc.context.blank?
      assert doc.context.users.size > 0
    end
  end
end
