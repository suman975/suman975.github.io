document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.ps-gallery img').forEach(img => {
        if (img.complete) {
            // already loaded
            img.classList.add('loaded');
        } else {
            img.addEventListener('load', () => img.classList.add('loaded'));
        }
    });
});
