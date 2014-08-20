require 'logger'
require 'faraday'
require 'labyrintti/version'
require 'labyrintti/base'
require 'labyrintti/sms'
require 'active_support/core_ext/string'

module Labyrintti
  extend self
  attr_accessor :user, :password, :debug, :secure
  attr_writer :user_agent, :logger

  # ensures the setup only gets run once
  @_ran_once = false

  def reset!
    @logger = nil
    @_ran_once = false
    @user_agent = nil
    @user = nil
    @password = nil
    @secure = nil
  end

  def user_agent
    @user_agent ||= "Labyrintti Ruby Client v#{::Labyrintti::VERSION}"
  end

  def setup
    yield self unless @_ran_once
    @_ran_once = true
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  reset!
end
