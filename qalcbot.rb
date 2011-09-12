#!/usr/bin/env ruby

require 'configru'
require 'cinch'
require 'cinch/plugins/basic_ctcp'
require File.join(File.dirname(__FILE__), 'qalc.rb')

Configru.load do
  just 'config.yml'
  defaults do
    nick     'qalc'
    channels ['#bots', '#offtopic', '#programming']
    server do
      address 'onyx.tenthbit.net'
      port    6667
    end
  end

  verify do
    nick     String
    channels Array
    server do
      address String
      port    (0..65535)
    end
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = Configru.server.address
    c.port     = Configru.server.port
    c.channels = Configru.channels
    c.nick     = Configru.nick
    c.plugins.plugins = [Cinch::Plugins::BasicCTCP]
    c.plugins.options[Cinch::Plugins::BasicCTCP][:commands] = [:version, :time, :ping]
  end

  on :message, /^qalc[:,]? (.+)$/ do |m|
    parts = m.params[1].split(' ')
    if parts.length > 1
      reply = qalc(parts[1..-1].join(' '))
    else
      reply = "usage:  qcalc: [stuff]"
    end
    m.reply(reply, true)
  end
end

bot.start
