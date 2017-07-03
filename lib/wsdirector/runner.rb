module WsDirector
  class Runner
    def initialize(path, scenario)
      mutex = Mutex.new
      cond = ConditionVariable.new
      clients_count = scenario.inject(0) { |a, e| a + e['client']['multiplier'].to_i }
      waited_clients = 0
      wait_proc = proc do
        mutex.synchronize do
          waited_clients += 1
<<<<<<< HEAD
          p "waited_clients = #{waited_clients}"
=======
          p waited_clients
>>>>>>> 5c2cc98... realization executable; some improvements
          if clients_count == waited_clients
            cond.broadcast
            waited_clients = 0
            p 'free'
          else
            cond.wait(mutex)
          end
        end
      end
      threads = []
      scenario.each do |client_scenario|
        threads << Thread.new do
          WsDirector::Client.new(path, client_scenario['client']['actions'], wait_proc)
                            .perform(client_scenario['client']['multiplier'])
        end
      end
      threads.each(&:join)
      p 'success'
    end
  end
end
