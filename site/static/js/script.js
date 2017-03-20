'use strict';

// Polyfill for requestAnimationFrame.
(function() {
  var lastTime = 0;
  if (!('performance' in window)) {
    window.performance = {};
  }
  if (!Date.now) {
    Date.now = function() { return new Date().getTime(); };
  }
  if (!('now' in window.performance)) {
    var nowOffset = Date.now();
    if (performance.timing && performance.timing.navigationStart) {
      nowOffset = performance.timing.navigationStart;
    }
    window.performance.now = function() { return Date.now() - nowOffset; };
  }
  var vendors = ['ms', 'moz', 'webkit', 'o'];
  for (var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
    window.requestAnimationFrame = window[vendors[x] + 'RequestAnimationFrame'];
    window.cancelAnimationFrame = window[vendors[x] + 'CancelAnimationFrame'] || window[vendors[x] + 'CancelRequestAnimationFrame'];
  }
  if (!window.requestAnimationFrame) {
    window.requestAnimationFrame = function(callback, element) {
      var currTime = Date.now();
      var timeToCall = Math.max(0, 16 - (currTime - lastTime));
      var id = window.setTimeout(function() { callback(currTime + timeToCall); }, timeToCall);
      lastTime = currTime + timeToCall;
      return id;
    }
  }
  if (!window.cancelAnimationFrame) {
    window.cancelAnimationFrame = function(id) { clearTimeout(id); };
  }
}());


// Menu handler.
(function() {
  var navbar;
  var navOffsetTop = -1;

  function onDOMContentLoaded() {
    navbar = document.getElementsByClassName('navbar')[0];
    navOffsetTop = navbar.offsetHeight;
  }
  window.addEventListener('DOMContentLoaded', onDOMContentLoaded);

  function onResize() {
    navOffsetTop = -1;
    window.requestAnimationFrame(fixNavBar);
  }
  window.addEventListener('resize', onResize);

  function onScroll() {
    window.requestAnimationFrame(fixNavBar);
  }
  window.addEventListener('scroll', onScroll);

  function fixNavBar() {
    if (navOffsetTop == -1) {
      // Update cached offset.
      navOffsetTop = navbar.offsetHeight;
      document.body.classList.remove('has-docked-nav');
    }
    var scrollY = window.scrollY;
    var has = document.body.classList.contains('has-docked-nav');
    if (navOffsetTop < scrollY && !has) {
      // Removes position:fixed.
      document.body.classList.add('has-docked-nav');
    }
    if (navOffsetTop > scrollY && has) {
      // Adds position:fixed.
      document.body.classList.remove('has-docked-nav');
    }
  }
}());
