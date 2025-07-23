#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'ls_command'

LsCommand.new(ARGV).output
