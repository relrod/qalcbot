require 'open3'

def qalc(equation)
  Open3.popen3("qalc") do |stdin, stdout, stderr|
    stdin.puts equation

    2.times { stdout.gets }

    stdout.gets.strip
  end
end
