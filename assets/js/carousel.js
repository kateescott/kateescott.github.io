function setItemActive(currentIndex, newIndex, { itemContainerEl, indicatorEl }) {
  const currentItem = itemContainerEl.children.item(currentIndex);
  const currentIndicatorItem = indicatorEl.children.item(currentIndex);
  const nextItem = itemContainerEl.children.item(newIndex);
  const nextIndicatorItem = indicatorEl.children.item(newIndex);

  currentItem.classList.add('fadeOut');
  window.setTimeout(() => {
    currentItem.classList.remove('fadeOut', 'active');
    nextItem.classList.add('fadeIn');
    window.requestAnimationFrame(() => {
      nextItem.classList.add('active');
      window.setTimeout(() => {
        nextItem.classList.remove('fadeIn');
      }, 50);
    });
  }, 50);

  currentIndicatorItem.classList.remove('active');
  nextIndicatorItem.classList.add('active');
}

function initCarousel(el) {
  const indicatorEl = el.querySelector('.carousel__indicator');
  const itemContainerEl = el.querySelector('.carousel__itemContainer');
  const activeItemEl = el.querySelector('.carousel__item.active');
  const totalItems = itemContainerEl.children.length;
  let activeIndex = [...itemContainerEl.children].indexOf(activeItemEl);
  let tickerTimer = undefined;
  let resumeTimer = undefined;

  const onTick = () => {
    const nextIndex = (activeIndex + 1) % totalItems;
    // TODO(NW): Pre-load image before switching to it.
    setItemActive(activeIndex, nextIndex, { itemContainerEl, indicatorEl });
    activeIndex = nextIndex;
  };

  const stopTicker = () => {
    window.clearInterval(tickerTimer);
    window.clearTimeout(resumeTimer);
    resumeTimer = undefined;
    tickerTimer = undefined
  };

  const pauseTicker = () => {
    if (!tickerTimer) {
      // Already stopped for another reason.
      return;
    }

    stopTicker();
    resumeTimer = window.setTimeout(startTicker, 10000);
  };

  const startTicker = () => {
    if (tickerTimer) {
      return;
    }

    tickerTimer = window.setInterval(onTick, 5000);
  };

  const onIndicatorItemClick = (itemIndex) => {
    pauseTicker();
    if (itemIndex === activeIndex) {
      return;
    }

    setItemActive(activeIndex, itemIndex, { itemContainerEl, indicatorEl });
    activeIndex = itemIndex;
  };

  [...indicatorEl.children].forEach((el, index) =>
      el.addEventListener('click', () => onIndicatorItemClick(index)));
  el.addEventListener('mouseenter', () => stopTicker());
  el.addEventListener('mouseleave', () => startTicker());

  startTicker();
}

function main() {
  document.querySelectorAll('.carousel')
      .forEach(el => initCarousel(el));
}

window.addEventListener('DOMContentLoaded', main);
