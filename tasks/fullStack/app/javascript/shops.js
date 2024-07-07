
document.addEventListener("DOMContentLoaded", function() {
  fetchShops();
});

function fetchShops() {
  fetch('/shops')
    .then(response => response.json())
    .then(data => {
      const selectTag = document.getElementById('shop_id');
      selectTag.innerHTML = '';
      selectTag.options[selectTag.options.length] = new Option('Select a shop', '');

      data.forEach(shop => {
        selectTag.options[selectTag.options.length] = new Option(shop.name, shop.id);
      });
    })
    .catch(error => {
      console.error('Error fetching shops:', error);
    });
}

document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.product-reviews-container').forEach(function(container) {
    var productId = container.dataset.productId;

    fetch(`/reviews/fetch_reviews?product_id=${productId}`)
      .then(response => response.text())
      .then(data => {
        container.innerHTML = data;
      });
  });
});