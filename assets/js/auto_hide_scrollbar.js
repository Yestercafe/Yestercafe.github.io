function isOverflownX(element) {
  return element.scrollWidth > element.clientWidth;
}

var hls = document.getElementsByTagName('pre');
for (var i = 0; i < hls.length; i++) {
  var hl = hls[i];
  hl.style.marginBottom = '15px';
  if (isOverflownX(hl)) {
    hl.style.marginBottom = '20px';
    hl.addEventListener("mouseenter", (event) => {
      event.target.style.marginBottom = '15px';
    }, false);
    hl.addEventListener("mouseleave", (event) => {
      event.target.style.marginBottom = '20px';
    }, false);
  }
}
