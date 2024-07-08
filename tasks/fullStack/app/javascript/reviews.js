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