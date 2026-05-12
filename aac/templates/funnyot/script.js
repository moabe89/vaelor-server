// FunnyOt Template — script de interatividade

document.addEventListener('DOMContentLoaded', function() {
  // Collapsible panels
  document.querySelectorAll('[data-toggle]').forEach(function(btn) {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      var target = btn.getAttribute('data-toggle');
      var content = document.querySelector('[data-content="' + target + '"]');
      var plaque = btn;
      if (!content) return;

      content.classList.toggle('collapsed');
      plaque.classList.toggle('expanded');

      // Atualiza chevron
      var chev = btn.querySelector('.chevron');
      if (chev) {
        chev.textContent = content.classList.contains('collapsed') ? '▸' : '▾';
      }
    });
  });

  // Inicializa chevrons baseado no estado inicial
  document.querySelectorAll('[data-toggle]').forEach(function(btn) {
    var target = btn.getAttribute('data-toggle');
    var content = document.querySelector('[data-content="' + target + '"]');
    var chev = btn.querySelector('.chevron');
    if (chev && content) {
      chev.textContent = content.classList.contains('collapsed') ? '▸' : '▾';
    }
    if (content && !content.classList.contains('collapsed')) {
      btn.classList.add('expanded');
    }
  });
});
