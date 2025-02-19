class ArtSystem::ChatgptCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, ArtSystem::ChatgptCommand
    assert_equality subject.class, ArtSystem::ChatgptCommand
  end

end
