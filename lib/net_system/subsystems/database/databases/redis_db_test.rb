class NetSystem::RedisDbTest < NetSystem::DatabaseTest

  test :subject_class do
    assert subject_class == NetSystem::RedisDb
  end

  test :subject do
    assert subject.client.class == NetSystem::RedisDbClient
  end

  test :now do
    t = subject.now
    assert! t.is_a? Time
    assert t.yday == Time.now.yday
  end if ENV["DBTEST"]

  # test :call do
  #   todo "write this"
  # end

end
