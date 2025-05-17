class DevSystem::NotFoundBench < DevSystem::Bench

  def self.call(menv)
    new.call menv
  end

  def call(menv)
    app_shell = AppShell.new
    app_shell.filter_by_unit Bench

    app_shell.filter_out_units SortedBench if defined? SortedBench
    failed_name = menv[:bench_name_original]
    app_shell.filter_by_name_including failed_name if failed_name

    outputs(app_shell, failed_name)
  end

  section :helpers

  def outputs(app_shell, failed_name)
    domains = app_shell.get_domains.reject(&:empty?)
    log "domains: #{domains.count}"
    puts

    if domains.empty?
      log stick :black, :green, "No results found for '#{failed_name}'"
      app_shell.undo_filter!
      domains = app_shell.get_domains
    end

    domains.each do |domain|
      next if domain.empty?

      if log? :normal
        puts typo.h1 domain.name.snakecase.upcase, domain.color
      end

      puts
      domain.layers.each do |layer|
        next if layer.objects.empty?

        if log? :normal
          m = "h#{layer.level}"
          name = layer.level==1 ? domain.name.to_s.upcase : layer.name.to_s
          puts typo.send m, name, layer.color unless layer.level==3

          puts stick layer.color, layer.path
          puts
        end

        layer.objects.each { print_class _1 }
        puts
      end
    end
  end

  def print_class klass, description: nil
    return if [NotFoundBench].include? klass

    sidebar_length = Log.panel.sidebar_size
    signature = {}
    signature[:name] = klass.token.to_s
    signature[:description] = "no description"

    puts [
      "liza bench #{signature[:name]}".ljust(sidebar_length),
      (description or signature[:description])
    ].join ""
  end

  def typo () = TypographyShell

end
