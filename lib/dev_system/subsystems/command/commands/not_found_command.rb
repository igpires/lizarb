class DevSystem::NotFoundCommand < DevSystem::SimpleCommand

  def before
    super
    menv[:command_action] = "default"
  end

  def call_default
    is_global = App.global?
    self.log_level 1 if is_global

    app_shell = AppShell.new
    app_shell.filter_by_unit Command

    if is_global
      app_shell.filter_in_units NewCommand, NotFoundCommand
    else
      app_shell.filter_out_units BaseCommand, SimpleCommand, NewCommand
      failed_name = menv[:command_name_original]
      app_shell.filter_by_name_including failed_name if failed_name
    end

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
          name = layer.level==1 ? domain.name.snakecase.upcase : layer.name.to_s
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
    return if [NotFoundCommand].include? klass

    sidebar_length = Log.panel.sidebar_size
    klass.get_command_signatures.each do |signature|
      signature[:name] =
        signature[:name].empty? \
          ? klass.token.to_s
          : "#{klass.token}:#{signature[:name]}"
      #
    end.sort_by { _1[:name] }.map do |signature|
      puts [
        "liza #{signature[:name]}".ljust(sidebar_length),
        (description or signature[:description])
      ].join ""
    end
  end
  
end
