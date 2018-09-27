require 'gserver'
class LogServer < GServer

  def initialize
    super(12345)
  end

  def serve(client)
    remote_ip = client.peeraddr
    log "Connected from #{remote_ip[2]}:#{remote_ip[1]}"
    client.puts get_end_of_log_file
  end

  private
    def get_end_of_log_file
      File.open("/var/log/syslog") do |log|
        # back up 1000 characters from end
        log.seek(-1000, IO::SEEK_END)
        # ignore partial line
        log.gets
        # and return rest
        log.read
      end
    end
end

server = LogServer.new
server.start.join
