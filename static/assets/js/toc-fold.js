(function () {
  function initTocFold() {
    var MAX_VISIBLE_TOP_LEVEL = 8;

    var tocRoots = document.querySelectorAll('#toc, .wikipage-toc');
    tocRoots.forEach(function (root) {
      var hasDeepItems = root.querySelector('.toc-list .toc-list, #TableOfContents ul ul');
      var topList = root.querySelector('details > .toc-list, #TableOfContents > ul');
      var topLevelCount = 0;
      if (topList) {
        topLevelCount = Array.prototype.filter.call(topList.children, function (el) {
          return el.tagName === 'LI';
        }).length;
      }
      var hasOverflowItems = topLevelCount > MAX_VISIBLE_TOP_LEVEL;
      var hiddenTopLevelCount = hasOverflowItems ? (topLevelCount - MAX_VISIBLE_TOP_LEVEL) : 0;

      if (!hasDeepItems && !hasOverflowItems) return;

      if (hasDeepItems) {
        root.classList.add('toc-folded');
      }
      if (hasOverflowItems) {
        root.classList.add('toc-truncated');
        var cutoffSelector = 'details > .toc-list > li:nth-child(' + MAX_VISIBLE_TOP_LEVEL + '), #TableOfContents > ul > li:nth-child(' + MAX_VISIBLE_TOP_LEVEL + ')';
        var cutoffItem = root.querySelector(cutoffSelector);
        if (cutoffItem) {
          cutoffItem.classList.add('toc-fold-cutoff');
          var hintBtn = document.createElement('button');
          hintBtn.type = 'button';
          hintBtn.className = 'toc-fold-hint-btn';
          hintBtn.textContent = '还有 ' + hiddenTopLevelCount + ' 项';
          cutoffItem.appendChild(hintBtn);
        }
      }

      if (root.querySelector('.toc-fold-toggle')) return;

      var btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'toc-fold-toggle';
      btn.setAttribute('aria-expanded', 'false');
      btn.textContent = '展开目录';

      function toggleExpanded() {
        var expanded = root.classList.toggle('toc-expanded');
        btn.setAttribute('aria-expanded', expanded ? 'true' : 'false');
        btn.textContent = expanded ? '收起目录' : '展开目录';
      }

      btn.addEventListener('click', function () {
        toggleExpanded();
      });

      root.insertBefore(btn, root.firstChild);

      var inlineHintBtn = root.querySelector('.toc-fold-hint-btn');
      if (inlineHintBtn) {
        inlineHintBtn.addEventListener('click', function (event) {
          event.preventDefault();
          toggleExpanded();
        });
      }
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initTocFold);
  } else {
    initTocFold();
  }
})();
