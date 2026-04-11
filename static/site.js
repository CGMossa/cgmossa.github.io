const nav = document.querySelector('[data-nav]');
const toggle = nav?.querySelector('.nav-toggle');
const links = nav?.querySelector('.nav-links');

if (nav && toggle && links) {
  const setOpen = (open) => {
    nav.dataset.open = open ? 'true' : 'false';
    toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
  };

  setOpen(false);

  toggle.addEventListener('click', () => {
    setOpen(nav.dataset.open !== 'true');
  });

  links.querySelectorAll('a').forEach((link) => {
    link.addEventListener('click', () => setOpen(false));
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      setOpen(false);
    }
  });

  const media = window.matchMedia('(min-width: 701px)');

  const handleViewportChange = (event) => {
    if (event.matches) {
      setOpen(false);
    }
  };

  if (typeof media.addEventListener === 'function') {
    media.addEventListener('change', handleViewportChange);
  } else if (typeof media.addListener === 'function') {
    media.addListener(handleViewportChange);
  }
}
