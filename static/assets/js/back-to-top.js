(() => {
  function scrollToTop() {
    try {
      window.scrollTo({ top: 0, behavior: "smooth" });
    } catch (_) {
      window.scrollTo(0, 0);
    }
    if (window.location.hash) {
      history.replaceState(null, "", window.location.pathname + window.location.search);
    }
  }

  document.addEventListener("click", (event) => {
    const target = event.target.closest(".back-to-top");
    if (!target) return;
    event.preventDefault();
    scrollToTop();
  });
})();
