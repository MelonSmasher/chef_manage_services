#
# Cookbook:: services
# Recipe:: default
#

# Global value for ignoring failures
ignore_failure_option = node['chef_services']['ignore_failure']

node['chef_services']['services'].each do |service, service_options|

  # Grab the service name option
  service_name_option = service
  unless service_options['service_name'].nil?
    service_name_option = service_options['service_name']
  end

  # get the actions that we should run on the service
  actions_option = []
  service_options['action'].each do |action|
    case action.downcase
      when 'disable'
        actions_option.push(:disable)
      when 'enable'
        actions_option.push(:enable)
      when 'nothing'
        actions_option.push(:nothing)
      when 'reload'
        actions_option.push(:reload)
      when 'restart'
        actions_option.push(:restart)
      when 'start'
        actions_option.push(:start)
      when 'stop'
        actions_option.push(:stop)
      else
        log 'Services' do
          message "The service: '#{service}' contains a malformed or unknown action (#{action})... ignoring it!"
          level :warn
        end
    end
  end

  # If the actions option is empty throw a warning and set the action to nothing
  if actions_option.empty?
    log 'Services' do
      message "The service: '#{service}' was not supplied any valid actions. Setting action to 'nothing'."
      level :warn
    end
    actions_option.push(:nothing)
  end


  # If the service has ignore failure overridden, set it.
  unless service_options['ignore_failure'].nil?
    ignore_failure_option = service_options['ignore_failure']
  end

  # If we need to grab the init command
  init_command_option = false
  unless service_options['init_command'].nil?
    init_command_option = service_options['init_command']
  end

  # Determine if there is anything to notify
  notify_option = false
  unless service_options['notify'].nil?
    notify_option = service_options['notify']
  end

  # Grab the pattern
  pattern_option = service_name_option
  unless service_options['pattern'].nil?
    pattern_option = service_options['pattern']
  end

  # Grab the priority if the node is debian based
  priority_option = false
  if node['platform'] == 'debian'
    unless service_options['priority'].nil?
      priority_option = service_options['priority']
    end
  end

  # Grab the provider
  provider_option = false
  unless service_options['provider'].nil?
    provider_option = service_options['provider']
  end

  # Grab the reload command
  reload_command_option = false
  unless service_options['reload_command'].nil?
    reload_command_option = service_options['reload_command']
  end

  # Grab the restart command
  restart_command_option = false
  unless service_options['restart_command'].nil?
    restart_command_option = service_options['restart_command']
  end

  # Grab the retries option
  retries_option = 0
  unless service_options['retries'].nil?
    retries_option = service_options['retries']
  end

  # Grab the retries delay option
  retry_delay_option = 2
  unless service_options['retry_delay'].nil?
    retry_delay_option = service_options['retry_delay']
  end

  # Grab the start command option
  start_command_option = false
  unless service_options['start_command'].nil?
    start_command_option = service_options['start_command']
  end

  # Grab the status command option
  status_command_option = false
  unless service_options['status_command'].nil?
    status_command_option = service_options['status_command']
  end

  # Grab the stop command option
  stop_command_option = false
  unless service_options['stop_command'].nil?
    stop_command_option = service_options['stop_command']
  end

  # Grab the subscribes option
  subscribes_option = false
  unless service_options['subscribes'].nil?
    subscribes_option = service_options['subscribes']
  end

  # Grab the supports option
  supports_option = false
  unless service_options['supports'].nil?
    supports_option = service_options['supports']
  end

  # Grab the timeout option if on windows
  timeout_option = false
  if node['platform'] == 'windows'
    timeout_option = 60
    unless service_options['timeout'].nil?
      timeout_option = service_options['timeout']
    end
  end

  # After gathering all of the options define the service here.
  service service do

    # Set the action(s)
    action actions_option

    # Set the ignore failure option
    ignore_failure ignore_failure_option

    # Set the init command directive if needed
    if init_command_option
      init_command init_command_option
    end

    # Set the notifies option if needed
    if notify_option
      if notify_option['action'] and notify_option['resource']
        if notify_option['timer']
          notifies notify_option['action'].to_s.to_sym, notify_option['resource'].to_s, notify_option['timer'].to_s.to_sym
        else
          notifies notify_option['action'].to_s.to_sym, notify_option['resource'].to_s, :delayed
        end
      end
    end

    # Set the pattern option if needed
    if pattern_option
      unless pattern_option == service_name_option
        pattern pattern_option
      end
    end

    # If on debian set the priority directive if needed
    if node['platform'] == 'debian'
      if priority_option
        priority priority_option
      end
    end

    # Set the provider directive if needed
    if provider_option
      provider provider_option
    end

    # Set the reload command directive if needed
    if reload_command_option
      reload_command reload_command_option
    end

    # Set the restart command directive if needed
    if restart_command_option
      restart_command restart_command_option
    end

    # Set the retries directive if needed
    if retries_option
      retries retries_option
    end

    # Set the retry delay directive if needed
    if retry_delay_option
      retry_delay retry_delay_option
    end

    # Set the service name option
    if service_name_option
      service_name service_name_option
    end

    # Set the start command directive if needed
    if start_command_option
      start_command start_command_option
    end

    # Set the status command directive if needed
    if status_command_option
      status_command status_command_option
    end

    # Set the stop command directive if needed
    if stop_command_option
      stop_command stop_command_option
    end

    # Set the subscribes directive if needed
    if subscribes_option
      if subscribes_option['action'] and subscribes_option['resource']
        if subscribes_option['timer']
          subscribes subscribes_option['action'].to_s.to_sym, subscribes_option['resource'], subscribes_option['timer'].to_s.to_sym
        else
          subscribes subscribes_option['action'].to_s.to_sym, subscribes_option['resource'], :delayed
        end
      end
    end

    # Set the supports directive if needed
    if supports_option
      s = {}
      supports_option.each do |symbol, value|
        s[symbol.to_s.to_sym] = value
      end
      unless s.empty?
        supports s
      end
    end

    # Set the timeout directive if needed
    if node['platform'] == 'windows'
      if timeout_option
        timeout timeout_option
      end
    end

  end
end
