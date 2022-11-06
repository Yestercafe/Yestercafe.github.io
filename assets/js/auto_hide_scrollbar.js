function isOverflownX(element) {
  return element.scrollWidth > element.clientWidth;
}

var hls = document.getElementsByTagName('pre');
for (var i = 0; i < hls.length; i++) {
  var hl = hls[i];
  var initial_padding_px = 14.0;
  hl.style.paddingBottom = `${initial_padding_px}px`;
  console.log(hl.style.paddingBottom);
  if (isOverflownX(hl)) {
    hl.addEventListener("mouseenter", (event) => {
        event.target.style.paddingBottom = `${initial_padding_px - 5}px`;
    }, false);
    hl.addEventListener("mouseleave", (event) => {
      event.target.style.paddingBottom = `${initial_padding_px}px`;
    }, false);
  }
}
