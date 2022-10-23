class DevSystem
  class AppGeneratorTest < GeneratorTest

    test :subject_class do
      assert subject_class == DevSystem::AppGenerator
    end

    test :settings do
      assert subject_class.log_level == :normal
      assert subject_class.log_color == :green
    end

  end
end
