require 'vimrunner'
require 'vimrunner/rspec'
require_relative './support/vim'

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  plugin_path = Pathname.new(File.expand_path('.'))

  config.start_vim do
    vim = Vimrunner.start_gvim
    vim.add_plugin(plugin_path, 'plugin/splitjoin.vim')

    vim.add_plugin(plugin_path.join('spec/support/rust.vim'))
    vim.append_runtimepath(plugin_path.join('spec/support/rust.vim/after'))

    vim.add_plugin(plugin_path.join('spec/support/vim-javascript'))
    vim.append_runtimepath(plugin_path.join('spec/support/vim-javascript/after'))

    if vim.echo('exists(":packadd")').to_i > 0
      vim.command('packadd matchit')
    else
      vim.command('runtime macros/matchit.vim')
    end

    vim
  end
end

RSpec.configure do |config|
  tmp_dir = File.expand_path(File.dirname(__FILE__) + '/../tmp')

  config.include Support::Vim
  config.example_status_persistence_file_path = tmp_dir + '/examples.txt'
end
