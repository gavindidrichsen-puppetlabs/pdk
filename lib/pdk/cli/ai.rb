module PDK
    module CLI
      @ai_cmd = @base_cmd.define_command do
        name 'ai'
        usage 'ai [subcommand] [options]'
        summary 'Remove or delete information about the PDK or current project.'
        default_subcommand 'help'
  
        run do |_opts, args, _cmd|
          if args == ['help']
            PDK::CLI.run(['remove', '--help'])
            exit 0
          end
  
          PDK::CLI.run(['ai', 'help']) if args.empty?
        end
      end
      @ai_cmd.add_command Cri::Command.new_basic_help
    end
  end
  