class WorkSystem::WorkBox < Liza::Box

  #

  preconfigure :event do
    # 
  end

  preconfigure :publisher do
    # Publisher.panel gives you read-access to this instance
  end

  preconfigure :subscriber do
    # Subscriber.panel gives you read-access to this instance
  end

end