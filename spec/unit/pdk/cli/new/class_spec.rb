require 'spec_helper'
require 'pdk/cli'

describe 'PDK::CLI new class' do
  let(:help_text) { a_string_matching(/^USAGE\s+pdk new class/m) }

  before do
    # Stop printing out the result
    allow(PDK::CLI::Util::UpdateManagerPrinter).to receive(:print_summary)
  end

  context 'when not run from inside a module' do
    include_context 'run outside module'

    it 'exits with an error' do
      expect(logger).to receive(:error).with(a_string_matching(/must be run from inside a valid module/))

      expect { PDK::CLI.run(['new', 'class', 'test_class']) }.to exit_nonzero
    end
  end

  context 'when run from inside a module' do
    let(:root_dir) { '/path/to/test/module' }

    before do
      allow(PDK::Util).to receive(:module_root).and_return(root_dir)
    end

    context 'and not provided with a class name' do
      it 'exits non-zero and prints the `pdk new class` help' do
        expect { PDK::CLI.run(['new', 'class']) }.to exit_nonzero.and output(help_text).to_stdout
      end
    end

    context 'and provided an empty string as the class name' do
      it 'exits non-zero and prints the `pdk new class` help' do
        expect { PDK::CLI.run(['new', 'class', '']) }.to exit_nonzero.and output(help_text).to_stdout
      end
    end

    context 'and provided an invalid class name' do
      it 'exits with an error' do
        expect(logger).to receive(:error).with(a_string_matching(/'test-class' is not a valid class name/))

        expect { PDK::CLI.run(['new', 'class', 'test-class']) }.to exit_nonzero
      end
    end

    context 'and provided a valid class name' do
      let(:generator) { instance_double(PDK::Generate::PuppetClass, run: true) }

      after do
        PDK::CLI.run(['new', 'class', 'test_class'])
      end

      it 'generates the class' do
        expect(PDK::Generate::PuppetClass).to receive(:new).with(anything, 'test_class', instance_of(Hash)).and_return(generator)
        expect(generator).to receive(:run)
      end
    end
  end
end
