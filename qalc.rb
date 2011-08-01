require 'open3'

TIMELIMIT=2

def qalc(equation)
  ret = nil
  qalc_pid = nil
  t = Thread.new do
    Open3.popen2e("qalc") do |stdin, stdout, wait_thr|
      qalc_pid = wait_thr.pid
      stdin.puts equation

      2.times { stdout.gets }

      ret = stdout.gets.strip
    end
  end

  (0..TIMELIMIT).each do |i|
    break unless t.alive?
    if i == TIMELIMIT || !ret.nil?
      t.kill
      `kill -9 #{qalc_pid}`
      ret = "Timelimit exceeded" if ret.nil?
    end
    sleep 1
  end
  ret
end
