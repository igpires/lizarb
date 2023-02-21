class WebSystem::RequestCommand < Liza::Command

  VALID_ACTIONS = %w[find get post]

  def self.call(args)
    log "Called #{self}.#{__method__} with args #{args}"
    new.call(args)
  end

  # instance methods

  def call(args)
    log "Called #{self}.#{__method__} with args #{args}"

    @command = args.shift
    @args = args
    
    return help unless VALID_ACTIONS.include? @command
    perform
  rescue StandardError => error
    @error = error
    handle
  end

  def perform
    log "Called #{self}.#{__method__}"
    
    case @command
    when "find"
      find
    when "get"
      get_request
    when "post"
      post_request
    end
  end

  def handle
    log "Called #{self}.#{__method__}"
    log render "error.txt"
  end

  def help
    log "Called #{self}.#{__method__}"
    log render "help.txt"
  end

  # actions

  def find
    log "Called #{self}.#{__method__}"
    path = @args.first

    @env = {}
    @env["REQUEST_PATH"] = path

    request_panel.find @env

    @request_class = @env["LIZA_REQUEST_CLASS"]

    puts render "find.txt"
  end

  def get_request
    log "Called #{self}.#{__method__}"
    path = @args.first
    
    @env = {}
    @env["REQUEST_METHOD"] = "GET"
    @env["REQUEST_PATH"]   = path

    @status, @headers, @body = request_panel.call @env
    log "STATUS #{@status} with #{@headers.count} headers and a #{@body.first.size} byte body"
    puts render "response.http"
  end

  def post_request
    log "Called #{self}.#{__method__}"
    path = @args.first
    
    @env = {}
    @env["REQUEST_METHOD"] = "POST"
    @env["REQUEST_PATH"]   = path

    @status, @headers, @body = request_panel.call @env
    log "STATUS #{@status} with #{@headers.count} headers and a #{@body.first.size} byte body"
    puts render "response.http"
  end

  # helpers

  def request_panel
    Liza.const(:web_box).requests
  end
end

__END__

# success.txt.erb

RESULT:

class      <%= @result.class %>
value      <%= @result %>

# error.txt.erb

ERROR:

class      <%= @error.class %>
message    <%= @error.message %>
backtrace  <%= @error.backtrace.select { |s| @stop = true if s.include?("/exe/lizarb:"); !defined? @stop }.join "\n           " %>

# help.txt.erb

USAGE:

liza request find /path/to/action.format
liza request get /path/to/action.format
liza request post /path/to/action.format

# find.txt.erb

ENV:
<% @env.each do |k, v| %>
env["<%= k %>"] = <%= v.inspect -%>
<% end %>

REQUEST CLASS:

# <%= @request_class.source_location.join ":" %>
class <%= @request_class %> < <%= @request_class.superclass %>
  # ...
end

# response.http.erb

<%= @status %>
<% @headers.each do |k, v| -%>
<%= k %>: <%= v %>
<% end -%>

<%= @body.first %>
