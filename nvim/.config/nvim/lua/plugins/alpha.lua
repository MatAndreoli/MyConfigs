return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.startify'

    local pacman = require 'plugins.headers.pacman'
    local doom = require 'plugins.headers.doom'
    local onepiece = require 'plugins.headers.onepiece'
    local panda = require 'plugins.headers.panda'
    local hydra = require 'plugins.headers.hydra'
    local starwars = require 'plugins.headers.starwars'
    local planets = require 'plugins.headers.planets'
    local neovim = require 'plugins.headers.neovim'
    local skulls = require 'plugins.headers.skulls'

    math.randomseed(os.time())
    local headers = {
      pacman.basic,
      doom.logo,
      doom.cacodemon,
      onepiece.luffy,
      panda.panda,
      hydra.hydra,
      starwars.vader,
      planets.earth,
      neovim.elite,
      neovim.sharp,
      neovim.bloody,
      neovim.dos_rebel,
      skulls.mad_skull,
      skulls.skulls_group_meme,
    }

    dashboard.section.header.val = headers[math.random(#headers)]

    alpha.setup(dashboard.opts)
  end,
}
