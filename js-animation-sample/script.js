(function() {
  var animationStep = 10;
  function getPosition(obj) {
    var style = obj.currentStyle || document.defaultView.getComputedStyle(obj, '');
    return {
      x: parseInt(style.left),
      y: parseInt(style.top)
    };
  }
  function updatePosition(obj, target) {
    var position = getPosition(obj);
    var diff = {
      x: Math.floor((target.x - position.x) / animationStep),
      y: Math.floor((target.y - position.y) / animationStep),
    }
    if ( Math.abs(diff.x) < 0.01 ) {
      position.x = target.x;
    }
    if ( Math.abs(diff.y) < 0.01 ) {
      position.y = target.y;
    }
    obj.style.left = (position.x + diff.x) + 'px';
    obj.style.top = (position.y + diff.x) + 'px';
    if (target.x !== position.x || target.y !== position.y) {
      requestAnimationFrame(function() { updatePosition(obj, target); });
    }
  }

  var box = document.getElementById('box');
  box.addEventListener('click', function() {
    var position = getPosition(box);
    if (position.x < 100) {
      updatePosition(box, {x: 200, y: 200});
    } else {
      updatePosition(box, {x: 10, y: 10});
    }
  })
})();
