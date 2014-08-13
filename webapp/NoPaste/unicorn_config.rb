worker_processes 10
preload_app true

pid "#{RAILS_ROOT}/tmp/pids/unicorn.pid"

stderr_path './log/unicorn.stderr.log'
stdout_path './log/unicorn.stdout.log'

before_fork do |server, worker|
  old_pid = "#{ server.config[:pid] }.oldbin"
  unless old_pid == server.pid
    begin
      Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH

    end
  end
end
