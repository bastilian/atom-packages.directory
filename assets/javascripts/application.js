//= require fetch
//= require utilities

function AtomPackageAdmin() {

  this.initialize = function () {
    this.panel = el('div');

    this.addPanel();
  }

  this.addPanel = function () {
    document.body.appendChild(this.panel);
  }

  this.initialize.apply(this, arguments)
}

ready(function () {
  var admin = new AtomPackageAdmin();
})
