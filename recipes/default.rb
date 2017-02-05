#
# Cookbook:: services
# Recipe:: default
#

# This function managed the service
def manage_service(
    service,
    ignore_fail_option,
    service_name_option,
    actions_option,
    notifies_option,
    init_cmd_option,
    pattern_option,
    priority_option,
    provider_option,
    reload_cmd_option,
    restart_cmd_option,
    retries_option,
    retry_delay_option,
    start_cmd_option,
    status_cmd_option,
    stop_cmd_option,
    subscribes_option,
    supports_option,
    timeout_option

)
# After gathering all of the options define the service here.
  service service do

    # Set the action(s)
    action actions_option

    # Set the ignore failure option
    ignore_failure ignore_fail_option

    # Set the init command directive if needed
    if init_cmd_option
      init_command init_cmd_option
    end

    # Set the notifies option if needed
    if notifies_option
      if notifies_option['action'] && notifies_option['resource']
        if notifies_option['timer']
          notifies notifies_option['action'].to_s.to_sym, notifies_option['resource'].to_s, notifies_option['timer'].to_s.to_sym
        else
          notifies notifies_option['action'].to_s.to_sym, notifies_option['resource'].to_s, :delayed
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
    if reload_cmd_option
      reload_command reload_cmd_option
    end

    # Set the restart command directive if needed
    if restart_cmd_option
      restart_command restart_cmd_option
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
    if start_cmd_option
      start_command start_cmd_option
    end

    # Set the status command directive if needed
    if status_cmd_option
      status_command status_cmd_option
    end

    # Set the stop command directive if needed
    if stop_cmd_option
      stop_command stop_cmd_option
    end

    # Set the subscribes directive if needed
    if subscribes_option
      if subscribes_option['action'] && subscribes_option['resource']
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




# Global value for ignoring failures
ignore_fail_option = node['manage_services']['ignore_failures']

if node['manage_services']['services']

  node['manage_services']['services'].each do |service, service_options|

    # Grab the service name option
    service_name_option = service
    if service_options['service_name']
      service_name_option = service_options['service_name']
    end

    # get the actions that we should run on the service
    actions_option = []
    if service_options['action']
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
      ignore_fail_option = service_options['ignore_failure']
    end

    # If we need to grab the init command
    init_cmd_option = false
    if service_options['init_command']
      init_cmd_option = service_options['init_command']
    end

    # Determine if there is anything to notify
    notifies_option = false
    if service_options['notifies']
      notifies_option = service_options['notifies']
    end

    # Grab the pattern
    pattern_option = service_name_option
    if service_options['pattern']
      pattern_option = service_options['pattern']
    end

    # Grab the priority if the node is debian based
    priority_option = false
    if node['platform'] == 'debian'
      if service_options['priority']
        priority_option = service_options['priority']
      end
    end

    # Grab the provider
    provider_option = false
    if service_options['provider']
      provider_option = service_options['provider']
    end

    # Grab the reload command
    reload_cmd_option = false
    if service_options['reload_command']
      reload_cmd_option = service_options['reload_command']
    end

    # Grab the restart command
    restart_cmd_option = false
    if service_options['restart_command']
      restart_cmd_option = service_options['restart_command']
    end

    # Grab the retries option
    retries_option = 0
    if service_options['retries']
      retries_option = service_options['retries']
    end

    # Grab the retries delay option
    retry_delay_option = 2
    if service_options['retry_delay']
      retry_delay_option = service_options['retry_delay']
    end

    # Grab the start command option
    start_cmd_option = false
    if service_options['start_command']
      start_cmd_option = service_options['start_command']
    end

    # Grab the status command option
    status_cmd_option = false
    if service_options['status_command']
      status_cmd_option = service_options['status_command']
    end

    # Grab the stop command option
    stop_cmd_option = false
    if service_options['stop_command']
      stop_cmd_option = service_options['stop_command']
    end

    # Grab the subscribes option
    subscribes_option = false
    if service_options['subscribes']
      subscribes_option = service_options['subscribes']
    end

    # Grab the supports option
    supports_option = false
    if service_options['supports']
      supports_option = service_options['supports']
    end

    # Grab the timeout option if on windows
    timeout_option = false
    if node['platform'] == 'windows'
      timeout_option = 60
      if service_options['timeout']
        timeout_option = service_options['timeout']
      end
    end

    # Call the manage_service function
    manage_service(
        service,
        ignore_fail_option,
        service_name_option,
        actions_option,
        notifies_option,
        init_cmd_option,
        pattern_option,
        priority_option,
        provider_option,
        reload_cmd_option,
        restart_cmd_option,
        retries_option,
        retry_delay_option,
        start_cmd_option,
        status_cmd_option,
        stop_cmd_option,
        subscribes_option,
        supports_option,
        timeout_option
    )
  end
else
  log 'Services' do
    message "No services defined..."
    level :warn
  end
end