class LabSystem::LizaKrokiClientTest < LabSystem::LabKrokiClientTest

  test :subject_class do
    assert_equality subject_class, LabSystem::LizaKrokiClient
  end

  #

  test :call do
    result = subject_class.call(:nomnoml, :ab, :svg)
    assert result.start_with? "<svg"
  end

  #

  test :nomnoml do
    result = subject_class.nomnoml(:ab, :svg)
    assert result.start_with? "<svg"
  end

  test :plantuml do
    result = subject_class.plantuml(:ab, :svg)
    unless assert result.start_with? %|<?xml version="1.0" encoding="us-ascii" standalone="no"?><svg|
      puts result
    end
  end

end
